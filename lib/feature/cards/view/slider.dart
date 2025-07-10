import 'package:bank_pick/core/resources/color_manager.dart';

import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    Key? key,
    this.initialValue = 0.0,
    this.min = 0.0,
    this.max = 10000.0,
    this.onChanged,
  }) : super(key: key);

  final double initialValue;
  final double min;
  final double max;
  final Function(double)? onChanged;

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  void initState() {
    final bloc = context.read<CardsViewModel>();
    bloc.getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CardsViewModel>();

    return Padding(
      padding:  EdgeInsetsDirectional.only(start: 10.0.w),
      child: Container(
        height: 110.h,
        decoration: BoxDecoration(
          color: ColorManager.offWhite,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsetsDirectional.only(start: 25.0.w),
              child: Text(
                "Amount:\$${bloc.limit.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SfSlider(
              activeColor: ColorManager.blue,
              min: widget.min,
              max: widget.max,
              value: bloc.limit,
              showLabels: true,
              enableTooltip: false,
              onChanged: (value) {
                bloc.setValue(value);
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                  // bloc.getValue();
                }
              },
              numberFormat: NumberFormat.compact(),
            ),
          ],
        ),
      ),
    );
  }
}
