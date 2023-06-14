// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPressed = useState(false);

    ref.listen(authProvider, (previous, next) {
      next.maybeWhen(
        orElse: () {},
        error: (error, stackTrace) {
          if (isPressed.value) {
            Navigator.pop(context);
            isPressed.value = false;
          }
          showToast(message: "$error");
        },
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
                          builder: (context) => const RegisterView(),
                        ));
                  },
                  labelButton: "Create Account",
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthTextField(
                          controller: usernameController, label: "Email"),
                      const SizedBox(
                        height: 8,
                      ),
                      AuthTextField(
                          controller: passwordController,
                          label: "Password",
                          isPassword: true),
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
                              showLoadingDialog(context: context);
                              ref.read(authProvider.notifier).login(
                                  email: usernameController.text,
                                  password: passwordController.text);
                              isPressed.value = true;
                            },
                            child: const Center(
                              child: Text(
                                "Login",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class AuthTextField extends HookWidget {
  final bool isPassword;
  const AuthTextField(
      {super.key,
      required this.label,
      this.isPassword = false,
      required this.controller,
      this.validator});
  final String label;

  final String? Function(String?)? validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isShown = useState(false);
    useEffect(() {
      isShown.value = isPassword;
    }, []);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: min(MediaQuery.of(context).size.width, 400),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            TextFormField(
              validator: validator,
              controller: controller,
              obscureText: isShown.value,
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                fillColor: CustomColor.fillTextField,
                suffixIcon: isPassword
                    ? GestureDetector(
                        onTap: () => isShown.value = !isShown.value,
                        child: Icon(
                          isShown.value
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        ),
                      )
                    : null,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  color: CustomColor.orangeForeground,
                )),
                errorBorder: const OutlineInputBorder(
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

showLoadingDialog({
  required BuildContext context,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => true,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(4),
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: CustomColor.primaryBackgroundColor,
            ),
          ),
        ),
      );
    },
  );
}
