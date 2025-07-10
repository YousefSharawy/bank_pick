import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/utils/app_validator.dart';
import 'package:bank_pick/core/widgets/custome_text_field.dart';
import 'package:bank_pick/feature/auth/view_model/auth_states.dart';
import 'package:bank_pick/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes/routes.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/widgets/custom_elevated_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneCotroller = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        leading: Padding(
          padding:   EdgeInsetsDirectional.only(start: 15.0.w),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.offWhite,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 20.w,
            bottom: MediaQuery.of(context).viewInsets.bottom.h,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.05.h),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: FontSizeManager.s32,
                    color: ColorManager.dark,
                  ),
                ),
                SizedBox(height: 38.h),
                Text("Full Name", style: TextStyle(color: ColorManager.gray)),
                SizedBox(height: 15.h),
                Padding(
                  padding:   EdgeInsetsDirectional.only(start: 10.w),
                  child: Row(
                    children: [
                      CustomeTextField(
                        textEditingController: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name can't be empty";
                          }
                          if (!AppValidator.isUserExpr(value)) {
                            return "Name is short";
                          }
                          return null;
                        },
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: ColorManager.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 21.h),
                Text(
                  "Phone Number",
                  style: TextStyle(color: ColorManager.gray),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding:  EdgeInsetsDirectional.only(start: 10.w),
                  child: Row(
                    children: [
                      CustomeTextField(
                        textEditingController: phoneCotroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone Number can't be empty";
                          }
                          if (!AppValidator.isPhoneExpr(value) ) {
                            return "Phone Number isn't correct";
                          }
                          return null;
                        },
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: ColorManager.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 21.h),
                Text(
                  "Email Address",
                  style: TextStyle(color: ColorManager.gray),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding:   EdgeInsetsDirectional.only(start: 10.w),
                  child: Row(
                    children: [
                      CustomeTextField(
                        textEditingController: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email Address can't be empty";
                          } else if (!AppValidator.isEmail(value)) {
                            return "Invalid Email";
                          }
                          return null;
                        },
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: ColorManager.gray,
                        ),
                      ),
                    ],
                  ),
                ),

                Text("Password", style: TextStyle(color: ColorManager.gray)),
                SizedBox(height: 15),
                Padding(
                  padding:   EdgeInsetsDirectional.only(start: 10.w),
                  child: Row(
                    children: [
                      CustomeTextField(
                        isPassword: true,
                        textEditingController: passwordController,
                        validator: (value) {
                          if (value == null || value.trim().length < 8) {
                            return 'Password can not be less than 8 characters';
                          }
                          return null;
                        },
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: ColorManager.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                BlocListener<AuthViewModel, AuthStates>(
                  listener: (_, state) {
                    if (state is RegisterLoading) {
                      UIUtils.showLoading(context);
                    } else if (state is RegisterSuccess) {
                      UIUtils.hideLoading(context);
                      Navigator.of(context).pushReplacementNamed(Routes.login);
                    } else if (state is RegisterError) {
                      UIUtils.hideLoading(context);
                      UIUtils.showMessage(state.msg);

                    }
                  },

                  child: CustomElevatedButton(
                    text: "Sign Up",
                    onPressed: register,
                  ),
                ),
                SizedBox(height: 29.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account",
                      style: TextStyle(
                        color: ColorManager.gray,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.login);
                      },
                      child: Text(
                        "  Sign in",
                        style: TextStyle(
                          color: ColorManager.blue,
                          fontSize: FontSizeManager.s14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
        if(formKey.currentState!.validate()){
      BlocProvider.of<AuthViewModel>(context).register(
        emailController.text,
        passwordController.text,
        nameController.text,
        phoneCotroller.text,
      );
    }
  }
}
