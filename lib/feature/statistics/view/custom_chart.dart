import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class CustomChart extends StatefulWidget {
  final Function(double)? onBalanceChanged;

  const CustomChart({super.key, this.onBalanceChanged});

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  List<Color> gradientColors = [
    const Color(0xFF4285F4),
    const Color(0xFF1976D2),
  ];

  bool showAvg = false;
  List<double> balanceHistory = [0.0];
  List<DateTime> transactionTimes = [DateTime.now()];
  RealtimeChannel? _balanceChannel;
  double currentBalance = 0 ;
  final double STARTING_BALANCE = 0.0;
  String? currentCardId;
  bool isInitialized = false;
  DateTime? lastBalanceCheck;
  List<FlSpot> chartSpots = [];
  bool isCheckingBalance = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeChart();
      _startMonitoringBalanceChanges();
    });
  }

  Future<void> _saveChartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardKey = 'chart_data_$currentCardId';
      final chartData = {
        'balanceHistory': balanceHistory,
        'transactionTimes':
            transactionTimes.map((t) => t.millisecondsSinceEpoch).toList(),
        'currentBalance': currentBalance,
        'chartSpots':
            chartSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
        'lastSaved': DateTime.now().millisecondsSinceEpoch,
      };
      await prefs.setString(cardKey, json.encode(chartData));
    } catch (e) {}
  }

  Future<bool> _loadChartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardKey = 'chart_data_$currentCardId';
      final savedData = prefs.getString(cardKey);
      if (savedData != null) {
        final Map<String, dynamic> chartData = json.decode(savedData);
        balanceHistory =
            (chartData['balanceHistory'] as List<dynamic>)
                .map((e) => (e as num).toDouble())
                .toList();
        transactionTimes =
            (chartData['transactionTimes'] as List<dynamic>)
                .map((e) => DateTime.fromMillisecondsSinceEpoch(e as int))
                .toList();
        currentBalance = (chartData['currentBalance'] as num).toDouble();
        chartSpots =
            (chartData['chartSpots'] as List<dynamic>)
                .map(
                  (spotData) => FlSpot(
                    (spotData['x'] as num).toDouble(),
                    (spotData['y'] as num).toDouble(),
                  ),
                )
                .toList();
        return true;
      }
    } catch (e) {}
    return false;
  }

  Future<void> _clearChartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardKey = 'chart_data_$currentCardId';
      await prefs.remove(cardKey);
    } catch (e) {}
  }

  void _startMonitoringBalanceChanges() {
    _checkBalanceOnce();
  }

  Future<void> _checkBalanceOnce() async {
    if (!isInitialized || !mounted || isCheckingBalance) return;
    final cardsViewModel = context.read<CardsViewModel>();
    if (cardsViewModel.cards.isNotEmpty) {
      isCheckingBalance = true;
      try {
        final latestBalance = await _getCurrentBalanceFromSupabase();
        if (latestBalance != currentBalance && mounted) {
          _addNewBalancePoint(latestBalance);
        }
      } catch (e) {
      } finally {
        isCheckingBalance = false;
      }
    }
  }

  @override
  void dispose() {
    _balanceChannel?.unsubscribe();
    super.dispose();
  }

  Future<void> _initializeChart() async {
    final cardsViewModel = context.read<CardsViewModel>();
    if (cardsViewModel.cards.isEmpty) return;
    final newCardId = cardsViewModel.cards[cardsViewModel.index].cardNumber;
    if (currentCardId != newCardId || !isInitialized) {
      currentCardId = newCardId;
      final hasLoadedData = await _loadChartData();
      if (!hasLoadedData) {
        final realCurrentBalance = await _getCurrentBalanceFromSupabase();
        if (mounted) {
          setState(() {
            currentBalance = realCurrentBalance;
            balanceHistory = [STARTING_BALANCE];
            transactionTimes = [DateTime.now()];
            chartSpots = [FlSpot(0.0, STARTING_BALANCE)];
            if (currentBalance != STARTING_BALANCE) {
              balanceHistory.add(currentBalance);
              transactionTimes.add(DateTime.now());
              chartSpots.add(FlSpot(1.0, currentBalance));
            }
          });
        }
        await _saveChartData();
      } else {
        await _checkBalanceOnce();
        if (mounted) {
          setState(() {
            isInitialized = true;
          });
        }
      }
      cardsViewModel.currentUserBalance = currentBalance;
      _balanceChannel?.unsubscribe();
      _startListeningToBalanceChanges();
      isInitialized = true;
    }
  }

  Future<double> _getCurrentBalanceFromSupabase() async {
    try {
      final cardsViewModel = context.read<CardsViewModel>();
      if (cardsViewModel.cards.isEmpty) return STARTING_BALANCE;
      final currentCard = cardsViewModel.cards[cardsViewModel.index];
      final cardNumber = currentCard.cardNumber;
      final response =
          await Supabase.instance.client
              .from('cards')
              .select('balance')
              .eq('card_number', cardNumber)
              .single();
      final balance = response['balance']?.toDouble() ?? STARTING_BALANCE;
      return balance;
    } catch (e) {
      return currentBalance;
    }
  }

  void _startListeningToBalanceChanges() {
    if (currentCardId == null) return;
    _balanceChannel = Supabase.instance.client.channel(
      'balance_changes_${currentCardId}',
    );
    _balanceChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'cards',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'card_number',
            value: currentCardId,
          ),
          callback: (PostgresChangePayload payload) async {
            if (mounted) {
              final newBalance = payload.newRecord['balance']?.toDouble();
              if (newBalance != null && newBalance != currentBalance) {
                _addNewBalancePoint(newBalance);
              }
            }
          },
        )
        .subscribe();
  }

  void _addNewBalancePoint(double newBalance) {
    if (newBalance != currentBalance && mounted) {
      setState(() {
        currentBalance = newBalance;
        balanceHistory.add(newBalance);
        transactionTimes.add(DateTime.now());
        double nextXPosition = chartSpots.length.toDouble();
        chartSpots.add(FlSpot(nextXPosition, newBalance));
        if (chartSpots.length > 20) {
          chartSpots.removeAt(1);
          balanceHistory.removeAt(1);
          transactionTimes.removeAt(1);
          for (int i = 1; i < chartSpots.length; i++) {
            chartSpots[i] = FlSpot(i.toDouble(), chartSpots[i].y);
          }
        }
      });
      _saveChartData();
      final cardsViewModel = context.read<CardsViewModel>();
      cardsViewModel.currentUserBalance = newBalance;
      if (widget.onBalanceChanged != null) {
        widget.onBalanceChanged!(newBalance);
      }
    }
  }

  void addBalanceChange(double amount) {
    double newBalance = currentBalance + amount;
    _addNewBalancePoint(newBalance);
  }

  void setBalance(double newBalance) {
    _addNewBalancePoint(newBalance);
  }

  void resetChartData() {
    _clearChartData();
    setState(() {
      balanceHistory = [STARTING_BALANCE];
      transactionTimes = [DateTime.now()];
      chartSpots = [FlSpot(0.0, STARTING_BALANCE)];
      currentBalance = STARTING_BALANCE;
    });
    _saveChartData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardsViewModel, CardsStates>(
      builder: (context, state) {
        final cardsViewModel = context.read<CardsViewModel>();
        if (cardsViewModel.cards.isNotEmpty) {
          final newCardId =
              cardsViewModel.cards[cardsViewModel.index].cardNumber;
          if (currentCardId != newCardId) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await _initializeChart();
            });
          }
        }
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(0.0, 0.3), end: Offset.zero),
                    ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  '${currentBalance.toStringAsFixed(2)} LE',
                  key: ValueKey(currentBalance),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              if (isInitialized && chartSpots.isNotEmpty)
                AspectRatio(
                  aspectRatio: 2.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: animation.drive(
                              Tween(
                                begin: const Offset(0.1, 0.0),
                                end: Offset.zero,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: LineChart(
                        mainData(),
                        key: ValueKey(
                          '${currentCardId}_${chartSpots.length}_${currentBalance}',
                        ),
                      ),
                    ),
                  ),
                )
              else
                const AspectRatio(
                  aspectRatio: 2.0,
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  LineChartData mainData() {
    if (chartSpots.isEmpty) return LineChartData();
    double minY = chartSpots
        .map((spot) => spot.y)
        .reduce((a, b) => a < b ? a : b);
    double maxY = chartSpots
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);
    double padding = (maxY - minY) * 0.1;
    if (padding < 1000) padding = 1000;
    minY = minY - padding;
    maxY = maxY + padding;
    if (maxY - minY < 10000) {
      double center = (maxY + minY) / 2;
      minY = center - 5000;
      maxY = center + 5000;
    }
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              String label;
              if (barSpot.x == 0) {
                label = '${barSpot.y.toStringAsFixed(0)} LE (Starting Balance)';
              } else {
                if (barSpot.x.toInt() > 0 &&
                    barSpot.x.toInt() < chartSpots.length) {
                  double prevBalance = chartSpots[barSpot.x.toInt() - 1].y;
                  double change = barSpot.y - prevBalance;
                  String changeText =
                      change > 0
                          ? '+${change.toStringAsFixed(0)}'
                          : '${change.toStringAsFixed(0)}';
                  label = '${barSpot.y.toStringAsFixed(0)} LE ($changeText)';
                } else {
                  label = '${barSpot.y.toStringAsFixed(0)} LE';
                }
              }
              return LineTooltipItem(
                label,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        verticalInterval:
            chartSpots.length > 10 ? (chartSpots.length / 5).ceilToDouble() : 1,
        horizontalInterval: (maxY - minY) / 5,
        getDrawingVerticalLine: (value) {
          return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value == 0) {
                return const Text(
                  'Start',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                );
              } else if (value == chartSpots.length - 1) {
                return const Text(
                  'Now',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                );
              } else {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(color: Colors.grey, fontSize: 8),
                );
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (maxY - minY) / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                '${(value / 1000).toStringAsFixed(0)}k',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: chartSpots.length > 1 ? chartSpots.length.toDouble() - 1 : 1,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: chartSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              if (index == 0) {
                return FlDotCirclePainter(
                  radius: 8,
                  color: Colors.orange,
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                );
              } else if (index == chartSpots.length - 1) {
                return FlDotCirclePainter(
                  radius: 8,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: gradientColors[0],
                );
              } else {
                double prevBalance = chartSpots[index - 1].y;
                bool isIncrease = spot.y > prevBalance;
                return FlDotCirclePainter(
                  radius: 5,
                  color: isIncrease ? Colors.green : Colors.red,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              }
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradientColors[0].withOpacity(0.3),
                gradientColors[0].withOpacity(0.1),
                gradientColors[0].withOpacity(0.05),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
