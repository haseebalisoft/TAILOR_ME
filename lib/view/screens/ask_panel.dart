import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailer_app/view/auth/login_screen.dart';
import 'package:tailer_app/view/auth/sign_up_screen.dart';

class AskPanelScreen extends StatelessWidget {
  const AskPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Column(
            children: [
              Text(
                "Welcome To The AR Tailor Me",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2a87ef),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset('assets/image3.png'),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Hello There!",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2a87ef),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.off(() => LoginScreen());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  decoration: BoxDecoration(
                      color: Color(0xff2a87ef),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.off(() => SignUpScreen());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  decoration: BoxDecoration(
                      color: Color(0xff2a87ef),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
