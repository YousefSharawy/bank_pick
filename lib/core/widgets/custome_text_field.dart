import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeTextField extends StatefulWidget {
  TextEditingController textEditingController;
  bool isPassword;
  bool readOnly ;
  String? Function(String?)? validator;
  Widget prefixIcon;

  CustomeTextField({
    required this.textEditingController,
    required this.validator,
    this.isPassword = false,
    this.readOnly = false,
    required this.prefixIcon,
  });

  @override
  State<CustomeTextField> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  late bool isObsecure = widget.isPassword;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        style: TextStyle(color: ColorManager.dark),
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.w, color: ColorManager.offWhite),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.w, color: ColorManager.offWhite),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.w, color: ColorManager.offWhite),
          ),
          suffixIcon:
              widget.isPassword
                  ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    icon: Icon(
                      isObsecure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  )
                  : null,
        ),
        controller: widget.textEditingController,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isObsecure,
      ),
    );
  }
}
