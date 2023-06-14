// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/edit_recipe.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UtilitiesPage extends HookConsumerWidget {
  const UtilitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final selectedDropdown = ref.watch(selectedDropdownProvider);

    String label;
    if (selectedDropdown.isEmpty) {
      label = "Semua Kategori";
    } else {
      final count = ((selectedDropdown.length - 1) == 0)
          ? ""
          : "+${selectedDropdown.length - 1}";

      label = "${selectedDropdown.first}$count";
    }

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
            children: [
              const Text(
                "Resep Pribadi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AbsorbPointer(
                absorbing: ref.watch(currUserProvider).asData?.value == null,
                child: CustomDropdownButton(
                  label: label,
                  foregroundColor: CustomColor.orangeForeground,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // const SubheaderWidget(),
          Expanded(
            child: LoggedOutWarning(
              builder: (ref, isLoggedOut) {
                final createdRecipe =
                    ref.watch(currUserProvider).asData?.value?.createdRecipe ??
                        [];
                var recipeList = ref.watch(recipeProvider).asData?.value ?? [];
                recipeList = recipeList
                    .where((element) => createdRecipe.contains(element.id))
                    .where((element) {
                  if (selectedDropdown.isEmpty) {
                    return true;
                  }
                  for (var i = 0; i < selectedDropdown.length; i++) {
                    if (element.categoriesList.contains(selectedDropdown[i])) {
                      return true;
                    }
                  }
                  return false;
                }).toList();
                return SingleChildScrollView(
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
                            onTap: isLoggedOut
                                ? null
                                : () {
                                    ref
                                        .read(selectedDropdownProvider.notifier)
                                        .restart();
                                    ref
                                        .read(detailActivateProvider.notifier)
                                        .active();
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const CreateRecipe(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                            onHover: (value) {},
                            hoverColor: CustomColor.bodyPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                            child: (recipeList.isEmpty)
                                ? DottedBorder(
                                    strokeWidth: 0.5,
                                    padding: EdgeInsets.zero,
                                    borderType: BorderType.RRect,
                                    color: CustomColor.orangeBackground,
                                    dashPattern: const [5, 5],
                                    radius: const Radius.circular(8),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.69,
                                      height: 190,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.add,
                                            color: CustomColor.orangeBackground,
                                          ),
                                          Text(
                                            "Buat Resep Baru",
                                            style: TextStyle(
                                              color:
                                                  CustomColor.orangeBackground,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : DottedBorder(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.add,
                                            color: CustomColor.orangeBackground,
                                          ),
                                          Text(
                                            "Tambah Resep",
                                            style: TextStyle(
                                              color:
                                                  CustomColor.orangeBackground,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        if (isLoggedOut) ...[
                          const EditRecipeCard()
                        ] else ...[
                          ...recipeList.map(
                            (e) => EditRecipeCard(recipeModel: e),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditRecipeCard extends StatelessWidget {
  final RecipeModel? recipeModel;
  const EditRecipeCard({
    Key? key,
    this.recipeModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColor.primaryBackgroundColor,
      child: InkWell(
        onTap: recipeModel == null ? null : () {},
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Visibility(
                      visible: recipeModel == null,
                      replacement: CircleAvatar(
                        radius: 40,
                        backgroundColor: CustomColor.bodyPrimaryColor,
                        backgroundImage: recipeModel != null
                            ? NetworkImage(
                                recipeModel!.fileUrl,
                              )
                            : null,
                      ),
                      child: const ShimmerWidget(
                        child: CircleAvatar(
                          radius: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Visibility(
                        visible: recipeModel != null,
                        replacement: const ShimmerWidget(
                          height: 12,
                          width: 50,
                        ),
                        child: Text(
                          recipeModel?.recipeName ?? "",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white38,
                      ),
                      child: Visibility(
                        visible: recipeModel != null,
                        replacement: const ShimmerWidget(
                          height: 12,
                          width: 40,
                        ),
                        child: Text(
                          "${recipeModel?.calories} kals",
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Material(
                color: CustomColor.primaryButtonColor.withOpacity(0.24),
                child: InkWell(
                  onTap: recipeModel == null
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditRecipePage(recipeModel: recipeModel!),
                              ));
                        },
                  hoverColor: CustomColor.primaryButtonColor.withOpacity(0.3),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.edit,
                          size: 13, color: CustomColor.primaryButtonColor),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Edit Resep",
                        style: TextStyle(
                            fontSize: 14,
                            color: CustomColor.primaryButtonColor),
                      ),
                    ],
                  )),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
