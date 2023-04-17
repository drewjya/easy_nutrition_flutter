import 'package:easy_nutrition/src/core/common/widget/custom_checklist_tile.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomDropdownButton extends HookWidget {
  final String label;
  final Color? foregroundColor;
  final Color? backgroundColor;
  const CustomDropdownButton({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDropdownOpened = useState(false);
    final focusNode = useFocusNode();
    final actionKey = useMemoized(() => LabeledGlobalKey(label));
    final height = useState(0.0);
    final width = useState(0.0);
    final xPos = useState(0.0);
    final yPos = useState(0.0);
    final overlayEntry = useState<OverlayEntry?>(null);

    return Focus(
      focusNode: focusNode,
      onFocusChange: (value) {
        if (isDropdownOpened.value) {
          overlayEntry.value?.remove();
        } else {
          final render =
              actionKey.currentContext?.findRenderObject() as RenderBox;
          height.value = render.size.height;
          width.value = render.size.width;
          final widthScreen = MediaQuery.of(context).size.width - 80 - 40;
          Offset offSet = render.localToGlobal(Offset.zero);
          xPos.value = offSet.dx;
          yPos.value = offSet.dy;
          overlayEntry.value = OverlayEntry(
            builder: (context) {
              return Positioned(
                width: widthScreen,
                top: yPos.value,
                right: 24,
                height: 6.5 * height.value,
                child: Material(
                  color: CustomColor.primaryBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                      color: CustomColor.borderGreyTextField,
                      width: 0.6,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: GestureDetector(
                    onTap: () {
                      focusNode.unfocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.expand_less,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(label),
                              const Spacer(),
                            ],
                          ),
                          Expanded(
                            child: Consumer(builder: (context, ref, child) {
                              final listDropdown = ref.watch(dropdownProvider);
                              final selectedDropdown =
                                  ref.watch(selectedDropdownProvider);
                              return ListView(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomChecklistTile(
                                          value: selectedDropdown
                                              .contains(listDropdown[0]),
                                          title: listDropdown[0],
                                          onValueChange: (p0) {
                                            ref
                                                .read(selectedDropdownProvider
                                                    .notifier)
                                                .onSelect(p0);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomChecklistTile(
                                          value: selectedDropdown
                                              .contains(listDropdown[1]),
                                          title: listDropdown[1],
                                          onValueChange: (p0) {
                                            ref
                                                .read(selectedDropdownProvider
                                                    .notifier)
                                                .onSelect(p0);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomChecklistTile(
                                          value: selectedDropdown
                                              .contains(listDropdown[2]),
                                          title: listDropdown[2],
                                          onValueChange: (p0) {
                                            ref
                                                .read(selectedDropdownProvider
                                                    .notifier)
                                                .onSelect(p0);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomChecklistTile(
                                          value: selectedDropdown
                                              .contains(listDropdown[3]),
                                          title: listDropdown[3],
                                          onValueChange: (p0) {
                                            ref
                                                .read(selectedDropdownProvider
                                                    .notifier)
                                                .onSelect(p0);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomChecklistTile(
                                          value: selectedDropdown
                                              .contains(listDropdown[4]),
                                          title: listDropdown[4],
                                          onValueChange: (p0) {
                                            ref
                                                .read(selectedDropdownProvider
                                                    .notifier)
                                                .onSelect(p0);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomChecklistTile(
                                          value: selectedDropdown
                                              .contains(listDropdown[5]),
                                          title: listDropdown[5],
                                          onValueChange: (p0) {
                                            ref
                                                .read(selectedDropdownProvider
                                                    .notifier)
                                                .onSelect(p0);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
          Overlay.of(context).insert(overlayEntry.value!);
        }
        isDropdownOpened.value = value;
      },
      child: OutlinedButton(
        key: actionKey,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          foregroundColor: foregroundColor ?? Colors.white,
          backgroundColor:
              backgroundColor ?? CustomColor.primaryBackgroundColor,
          side: BorderSide(color: foregroundColor ?? Colors.white, width: 0.3),
        ),
        onPressed: () {
          if (isDropdownOpened.value) {
            focusNode.unfocus();
          } else {
            focusNode.requestFocus();
          }
        },
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            const SizedBox(
              width: 15,
            ),
            const Icon(Icons.expand_more)
          ],
        )),
      ),
    );
  }
}
