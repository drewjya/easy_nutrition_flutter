import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';

class DefaultTopBarAuth extends StatelessWidget {
  final String labelButton;
  final VoidCallback? onTap;
  const DefaultTopBarAuth({
    Key? key,
    required this.labelButton,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "EasyNutrition",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: CustomColor.orangeBackground.withOpacity(0.24),
            foregroundColor: CustomColor.orangeForeground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(labelButton),
          ),
        ),
      ],
    );
  }
}
