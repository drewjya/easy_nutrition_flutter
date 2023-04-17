// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/features/recipe/providers/ui/navbar_provider.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/home_page.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/leaderboard_page.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/personal_page.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/utilities_page.dart';
import 'package:easy_nutrition/src/features/recipe/widget/navlink_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:easy_nutrition/src/core/core.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navLinkProviderProvider);

    return NavLinkWidget(
      body: [
        const HomePage(),
        const UtilitiesPage(),
        const PersonalPage(),
        const LeaderboardPage(),
      ][selectedIndex % 4],
    );
  }
}

class ItemTile extends HookWidget {
  final VoidCallback? onTap;
  const ItemTile(
      {super.key,
      this.onTap,
      required this.isSelected,
      required this.icon,
      this.isLast = false});

  final bool isSelected;
  final IconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final height = useState(0.0);
    final isHovered = useState(false);

    return Stack(
      children: [
        MeasureSize(
          onChange: (size) {
            height.value = size.height;
          },
          child: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              onTap?.call();
            },
            onHover: (value) {
              isHovered.value = value;
            },
            child: SizedBox(
              width: 80,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSelected || isHovered.value
                        ? CustomColor.bodyPrimaryColor
                        : null,
                    borderRadius: BorderRadius.horizontal(
                        left: const Radius.circular(15),
                        right: isHovered.value
                            ? const Radius.circular(15)
                            : Radius.zero),
                  ),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected || isHovered.value
                          ? CustomColor.primaryButtonColor
                          : null,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Icon(
                      icon,
                      color: isSelected || isHovered.value
                          ? Colors.white
                          : CustomColor.primaryButtonColor,
                    )),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            right: 0,
            child: Container(
              width: 20,
              height: height.value,
              color: CustomColor.bodyPrimaryColor,
            ),
          )
      ],
    );
  }
}
