import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/shared/custom_transaction_section.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  // Helper method to group transactions by date
  Map<String, List<dynamic>> _groupTransactionsByDate(List<dynamic> transactions) {
    final Map<String, List<dynamic>> groupedTransactions = {};
    
    for (var transaction in transactions) {
      // Parse the timestamp from Supabase
      DateTime transactionDate;
      if (transaction.created_at != null) {
        transactionDate = DateTime.parse(transaction.created_at.toString());
      } else {
        transactionDate = DateTime.now();
      }
      
      // Format date for grouping (e.g., "Today", "Yesterday", or "Jan 15, 2024")
      String dateKey = _formatDateKey(transactionDate);
      
      if (groupedTransactions[dateKey] == null) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }
    
    return groupedTransactions;
  }

  // Helper method to format date keys
  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDay = DateTime(date.year, date.month, date.day);
    
    if (transactionDay == today) {
      return "Today";
    } else if (transactionDay == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  // Helper method to get sort order for date keys
  int _getDateSortOrder(String dateKey) {
    if (dateKey == "Today") return 0;
    if (dateKey == "Yesterday") return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        title: Text(
          "All Transactions",
          style: TextStyle(
            color: ColorManager.navyBlue,
            fontSize: FontSizeManager.s18,
            fontWeight: FontWeightManager.medium,
          ),
        ),
        centerTitle: true,
       
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CardsViewModel, CardsStates>(
              builder: (_, state) {
                final cardsViewModel = context.read<CardsViewModel>();
                
                if (cardsViewModel.allTransactions.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                if (state is LoadingGetTransaction) {
                  UIUtils.showLoading(context);
                }
                
                // Group transactions by date
                final groupedTransactions = _groupTransactionsByDate(cardsViewModel.allTransactions);
                
                // Sort the date keys (Today, Yesterday, then chronological)
                final sortedDateKeys = groupedTransactions.keys.toList()
                  ..sort((a, b) {
                    int orderA = _getDateSortOrder(a);
                    int orderB = _getDateSortOrder(b);
                    
                    if (orderA != orderB) {
                      return orderA.compareTo(orderB);
                    }
                    
                    // For other dates, sort chronologically (newest first)
                    if (orderA == 2 && orderB == 2) {
                      try {
                        DateTime dateA = DateFormat('MMM dd, yyyy').parse(a);
                        DateTime dateB = DateFormat('MMM dd, yyyy').parse(b);
                        return dateB.compareTo(dateA);
                      } catch (e) {
                        return 0;
                      }
                    }
                    
                    return 0;
                  });
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedDateKeys.length,
                  itemBuilder: (_, index) {
                    final dateKey = sortedDateKeys[index];
                    final transactions = groupedTransactions[dateKey]!;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Header
                        Padding(
                          padding:  EdgeInsets.only(bottom: 12, top: index == 0 ? 1 : 0),
                          child: Text(
                            dateKey,
                            style: TextStyle(
                              color: ColorManager.navyBlue,
                              fontSize: FontSizeManager.s18,
                              fontWeight: FontWeightManager.semiBold,
                            ),
                          ),
                        ),
                        
                        // Transactions for this date
                        ...transactions.map((transaction) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CustomTransactionSection(
                              label: transaction.f_type,
                              labelType: "Transaction",
                              imagepath: AssetsManager.moneyTransferIcon,
                              price: transaction.amount.toString(),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}