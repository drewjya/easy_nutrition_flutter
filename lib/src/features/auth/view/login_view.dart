// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:easy_nutrition/src/src.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isMobile = Responsive.isMobile(context);
    if (isMobile) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      backgroundColor: CustomColor.primaryBackgroundColor,
      body: Form(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTopBarAuth(
                  onTap: () {},
                  labelButton: "Create Account",
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthTextField(
                          controller: usernameController, label: "Username"),
                      const SizedBox(
                        height: 8,
                      ),
                      AuthTextField(
                          controller: passwordController, label: "Password"),
                      const SizedBox(
                        height: 38,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          width: min(MediaQuery.of(context).size.width, 360),
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 300,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.validator});
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: min(MediaQuery.of(context).size.width, 400),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            TextFormField(
              validator: validator,
              controller: controller,
              decoration: const InputDecoration(
                filled: true,
                isDense: true,
                fillColor: CustomColor.fillTextField,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: CustomColor.orangeForeground,
                )),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.red,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
