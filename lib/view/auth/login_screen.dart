import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailer_app/controller/auth_controller.dart';

import 'package:tailer_app/view/auth/sign_up_screen.dart';
import 'package:tailer_app/widget/common_button.dart';
import 'package:tailer_app/widget/common_password_text_box.dart';
import 'package:tailer_app/widget/common_text_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/ly1.png"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 28,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonTextBox(
                      label: "Email",
                      controller: controller.emailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonPasswordTextBox(
                      label: "Password",
                      controller: controller.passwordController,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return controller.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : CommonButton(
                              onClick: () {
                                controller.signIn();
                              },
                              title: "LOGIN",
                            );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Don't Have an Account?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    CommonButton(
                      onClick: () {
                        Get.to(() => SignUpScreen());
                      },
                      title: "Create Account",
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/img1.png",
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
