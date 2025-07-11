import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/feature/statistics/custom_chart.dart';
import 'package:bank_pick/feature/statistics/month_selector.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AssetsManager.background),
        ),
      ),
      child: Scaffold(
        backgroundColor: ColorManager.transparent,
        appBar: AppBar(
          backgroundColor: ColorManager.transparent,
          title: const Text('Statistics'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [CustomChart(), MonthSelector()]),
      ),
    );
  }
}
