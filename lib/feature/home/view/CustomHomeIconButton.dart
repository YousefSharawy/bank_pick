import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class CustomHomeIconButton extends StatelessWidget {
  IconData ?cutsomIcon;
  Widget ?customImage;
  String label;
  CustomHomeIconButton({required this.label,this.cutsomIcon,this.customImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon:  customImage ?? Icon(cutsomIcon),
          style: IconButton.styleFrom(
            fixedSize: Size(54, 54),
            backgroundColor: ColorManager.offWhite,
            shape: CircleBorder(),
          ),
        ),
        SizedBox(height: 7,),
        Text(label),
      ],
    );
  }
}
