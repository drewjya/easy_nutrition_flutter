// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:easy_nutrition/src/src.dart';

class CustomChecklistTile extends StatelessWidget {
  final bool value;
  final String title;
  final Function(String)? onValueChange;
  const CustomChecklistTile({
    Key? key,
    required this.value,
    required this.title,
    this.onValueChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: CustomColor.backgroundTextField,
        ),
        width: 20,
        height: 20,
        child: value
            ? const Center(
                child: Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ))
            : null,
      ),
      onTap: () => onValueChange?.call(title),
      title: Text(title),
    );
  }
}
