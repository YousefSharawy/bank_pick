import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/core/widgets/custome_text_field.dart';
import 'package:bank_pick/feature/auth/view_model/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/app_validator.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.offWhite,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(Routes.onBoarding);
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 53),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: FontSizeManager.s32,
                  color: ColorManager.dark,
                ),
              ),
              SizedBox(height: 38),
              Text(
                "Email Address",
                style: TextStyle(color: ColorManager.gray),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(height: 21),
              Text("Password", style: TextStyle(color: ColorManager.gray)),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(height: 40),
              BlocListener<AuthViewModel, AuthStates>(
                listener: (_, state) {
                  if (state is LoginLoading) {
                    UIUtils.showLoading(context);
                  } else if (state is LoginSuccess) {
                    UIUtils.hideLoading(context);
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  } else if (state is LoginError) {
                    UIUtils.hideLoading(context);
                    UIUtils.showMessage(state.msg);
                  }
                },
                child: CustomElevatedButton(
                  text: "Sign In",
                  onPressed: login,
                ),
              ),
              SizedBox(height: 29),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Iam a new user",
                    style: TextStyle(
                      color: ColorManager.gray,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.register);
                    },
                    child: Text(
                      "  Sign Up",
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
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthViewModel>(
        context,
      ).login(emailController.text, passwordController.text);
    }
  }
}
