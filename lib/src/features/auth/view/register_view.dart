import 'dart:math';

import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterView extends HookConsumerWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final fullnameController = useTextEditingController();

    ref.listen(authProvider, (previous, next) {
      next.maybeWhen(
        orElse: () {},
        data: (data) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ),
              (route) => false);
        },
      );
    });
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
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ));
                  },
                  labelButton: "Login",
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthTextField(
                          controller: fullnameController,
                          label: "Nama Lengkap"),
                      const SizedBox(
                        height: 8,
                      ),
                      AuthTextField(
                          controller: emailController, label: "Email"),
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
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).createAccount(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    fullName: fullnameController.text,
                                  );
                            },
                            child: const Center(
                              child: Text(
                                "Create Account",
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
