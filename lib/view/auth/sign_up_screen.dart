import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailer_app/controller/auth_controller.dart';
import 'package:tailer_app/view/auth/login_screen.dart';
import 'package:tailer_app/widget/common_button.dart';
import 'package:tailer_app/widget/common_password_text_box.dart';
import 'package:tailer_app/widget/common_text_box.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/ly1.png"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  CommonTextBox(
                    label: "Name",
                    controller: controller.nameController,
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  CommonTextBox(
                    label: "Phone",
                    controller: controller.phoneController,
                    textInputType: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  CommonTextBox(
                    label: "Email",
                    controller: controller.emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  CommonPasswordTextBox(
                    label: "Password",
                    controller: controller.passwordController,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  CommonPasswordTextBox(
                    label: "Confirm Password",
                    controller: controller.confirmPasswordController,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 10,
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
                              controller.signUp();
                            },
                            title: "Create Account",
                          );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.off(() => LoginScreen());
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Already Have an Account?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
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
    ));
  }
}
