import 'package:dotted_border/dotted_border.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UtilitiesPage extends HookConsumerWidget {
  const UtilitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: CustomColor.primaryBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Resep Pribadi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomDropdownButton(
                label: "Atur Kategori",
                foregroundColor: CustomColor.orangeForeground,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // const SubheaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Material(
                      color: CustomColor.primaryBackgroundColor,
                      child: InkWell(
                        onTap: () {
                          ref.read(detailActivateProvider.notifier).active();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const CreateRecipe(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        onHover: (value) {},
                        hoverColor: CustomColor.bodyPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                        child: DottedBorder(
                          strokeWidth: 0.5,
                          padding: EdgeInsets.zero,
                          borderType: BorderType.RRect,
                          color: CustomColor.orangeBackground,
                          dashPattern: const [5, 5],
                          radius: const Radius.circular(8),
                          child: SizedBox(
                            width: 140,
                            height: 190,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: CustomColor.orangeBackground,
                                ),
                                Text(
                                  "Tambah Resep",
                                  style: TextStyle(
                                    color: CustomColor.orangeBackground,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(
                      10,
                      (index) => Material(
                        color: CustomColor.primaryBackgroundColor,
                        child: InkWell(
                          onTap: () {},
                          onHover: (value) {},
                          hoverColor: CustomColor.bodyPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: CustomColor.borderGreyTextField,
                                  width: 0.5,
                                )),
                            clipBehavior: Clip.antiAlias,
                            width: 140,
                            height: 190,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const CircleAvatar(
                                        radius: 40,
                                      ),
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Ay sjha hjasham",
                                          maxLines: 2,
                                        ),
                                      ),
                                      DefaultTextStyle(
                                        style: const TextStyle(
                                          color:
                                              CustomColor.borderGreyTextField,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text("data"),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text("data"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Material(
                                  color: CustomColor.primaryButtonColor
                                      .withOpacity(0.24),
                                  child: InkWell(
                                    onTap: () {},
                                    hoverColor: CustomColor.primaryButtonColor
                                        .withOpacity(0.3),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.edit,
                                            size: 13,
                                            color:
                                                CustomColor.primaryButtonColor),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                          "Edit Resep",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: CustomColor
                                                  .primaryButtonColor),
                                        ),
                                      ],
                                    )),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
