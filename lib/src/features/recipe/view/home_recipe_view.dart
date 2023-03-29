// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/features/recipe/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:easy_nutrition/src/core/common/widget/measure_size.dart';
import 'package:easy_nutrition/src/core/core.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final items = [
      ItemTile(
        onTap: () {
          selectedIndex.value = 0;
        },
        icon: Icons.home_outlined,
        isSelected: selectedIndex.value == 0,
      ),
      ItemTile(
          onTap: () {
            selectedIndex.value = 1;
          },
          isSelected: selectedIndex.value == 1,
          icon: Icons.settings),
      ItemTile(
          onTap: () {
            selectedIndex.value = 2;
          },
          isSelected: selectedIndex.value == 2,
          icon: Icons.people),
      ItemTile(
          onTap: () {
            selectedIndex.value = 3;
          },
          isSelected: selectedIndex.value == 3,
          icon: Icons.bookmark_outline_outlined),
    ];

    var remainingItem = items.where((element) {
      if (selectedIndex.value == 4) {
        return true;
      }
      return element.icon != items[selectedIndex.value].icon;
    }).toList();

    return Scaffold(
      backgroundColor: CustomColor.bodyPrimaryColor,
      body: Row(
        children: [
          Container(
            width: 80,
            color: CustomColor.primaryBackgroundColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                if (selectedIndex.value != 4)
                  items[selectedIndex.value]
                else
                  items[0],
                const SizedBox(
                  height: 10,
                ),
                remainingItem[0],
                const SizedBox(
                  height: 10,
                ),
                remainingItem[1],
                const SizedBox(
                  height: 10,
                ),
                remainingItem[2],
                const Spacer(),
                ItemTile(
                    onTap: () {
                      selectedIndex.value = 4;
                    },
                    isSelected: selectedIndex.value == 4,
                    icon: Icons.logout_outlined),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const Expanded(
            child: HomePage(),
          )
        ],
      ),
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
            onTap: onTap,
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
