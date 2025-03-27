import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/widgets/custome_text_field.dart';
import 'package:flutter/material.dart';

import '../../core/routes/routes.dart';
import '../../core/widgets/custom_elevated_button.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneCotroller = TextEditingController();
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
                Navigator.of(context).pop();
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
                'Sign Up',
                style: TextStyle(
                  fontSize: FontSizeManager.s32,
                  color: ColorManager.dark,
                ),
              ),
              SizedBox(height: 38),
              Text("Full Name", style: TextStyle(color: ColorManager.gray)),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CustomeTextField(
                      textEditingController: nameController,
                      validator: (aa) {},
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: ColorManager.gray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 21),
              Text("Phone Number", style: TextStyle(color: ColorManager.gray)),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CustomeTextField(
                      textEditingController: phoneCotroller,
                      validator: (aa) {},
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: ColorManager.gray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 21),
              Text("Email Address", style: TextStyle(color: ColorManager.gray)),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CustomeTextField(
                      textEditingController: emailController,
                      validator: (aa) {},
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CustomeTextField(
                      isPassword: true,
                      textEditingController: passwordController,
                      validator: (aa) {},
                      prefixIcon: Icon(
                        Icons.lock_outlined,
                        color: ColorManager.gray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              CustomElevatedButton(text: "Sign Up", onPressed: (){}),
              SizedBox(height: 29),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account",style: TextStyle(color: ColorManager.gray,fontSize: FontSizeManager.s14),),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(Routes.login);
                      },
                      child: Text("  Sign in",style: TextStyle(color: ColorManager.blue,fontSize: FontSizeManager.s14),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
