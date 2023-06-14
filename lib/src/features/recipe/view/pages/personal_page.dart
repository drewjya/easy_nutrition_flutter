// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/all_favorite_recipe.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/edit_recipe.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class PersonalPage extends HookConsumerWidget {
  const PersonalPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currUserProvider).asData?.value;
    log("${user?.desc}");
    final profileNameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    ref.watch(currentRecipeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24).copyWith(bottom: 6),
            child: const Text(
              "Profile",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Divider(
            color: CustomColor.borderGreyTextField,
          ),
          Expanded(
            child: LoggedOutWarning(
              builder: (ref, isLoggedOut) {
                return SingleChildScrollView(
                  physics:
                      isLoggedOut ? const NeverScrollableScrollPhysics() : null,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: CustomColor.primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Visibility(
                              visible: user != null,
                              replacement: const ShimmerWidget(
                                child: CircleAvatar(
                                  radius: 35,
                                ),
                              ),
                              child: ImagePickerWidget(
                                onPicked: (file) {
                                  if (file != null) {
                                    ref
                                        .read(currUserProvider.notifier)
                                        .uploadPicture(file);
                                  }
                                },
                                url: user?.profileUrl ?? '',
                                file: null,
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 45,
                                    color: CustomColor.primaryBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0)
                                        .copyWith(bottom: 4),
                                    child: Visibility(
                                      visible: user != null,
                                      replacement: const ShimmerWidget(
                                        height: 18,
                                        width: 200,
                                      ),
                                      child: OnHoverEdit(
                                        onSaved: (value, ref) {
                                          ref
                                              .read(currUserProvider.notifier)
                                              .changeDescription(
                                                  profileName:
                                                      profileNameController
                                                          .text,
                                                  description: null);
                                        },
                                        controller: profileNameController,
                                        value: user?.name ?? "",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0)
                                        .copyWith(top: 4),
                                    child: Visibility(
                                      visible: user != null,
                                      replacement: const ShimmerWidget(
                                        height: 14,
                                        width: 100,
                                      ),
                                      child: OnHoverEdit(
                                          onSaved: (value, ref) {
                                            ref
                                                .read(currUserProvider.notifier)
                                                .changeDescription(
                                                    description:
                                                        descriptionController
                                                            .text,
                                                    profileName: null);
                                          },
                                          isDesc: true,
                                          controller: descriptionController,
                                          value: user?.desc ?? "",
                                          color: CustomColor.borderTextField),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColor.primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Resep",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  OutlinedButton(
                                    onPressed: () {
                                      ref
                                          .read(
                                              selectedDropdownProvider.notifier)
                                          .restart();
                                      if (ref.read(detailActivateProvider)) {
                                        ref
                                            .read(
                                                detailActivateProvider.notifier)
                                            .back();

                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  const HomeView(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero,
                                            ),
                                            (route) => false);
                                      }
                                      ref
                                          .read(
                                              navLinkProviderProvider.notifier)
                                          .changeIndex(1);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.white, width: 0.3),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Lihat Semua Resep"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: CustomColor.borderGreyTextField,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                if (user == null) {
                                  return const RecipeProfileCard();
                                }
                                final recipe =
                                    ref.watch(recipeProvider).asData?.value ??
                                        [];
                                final currUserRecipe = ref
                                        .watch(currUserProvider)
                                        .asData
                                        ?.value
                                        ?.createdRecipe ??
                                    [];

                                final fetchRecipe = recipe
                                    .where((element) =>
                                        currUserRecipe.contains(element.id))
                                    .take(3);
                                if (fetchRecipe.isEmpty) {
                                  return const SizedBox(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        "Belum Ada Resep\nSilahkan buat resep baru",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                                return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(currentRecipeProvider
                                                  .notifier)
                                              .update((state) =>
                                                  fetchRecipe.elementAt(index));
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  const DetailRecipeView(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: CustomColor
                                              .primaryBackgroundColor,
                                          child: RecipeProfileCard(
                                            recipeModel:
                                                fetchRecipe.elementAt(index),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 8,
                                        ),
                                    itemCount: fetchRecipe.length);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: CustomColor.primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Resep Favorit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AllFavoriteRecipe(),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.white, width: 0.3),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Lihat Semua Resep"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: CustomColor.borderGreyTextField,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                if (user == null) {
                                  return const RecipeProfileCard();
                                }
                                final recipe =
                                    ref.watch(recipeProvider).asData?.value ??
                                        [];
                                final currUserRecipe = user.favoriteRecipe;
                                final fetchRecipe = recipe
                                    .where((element) =>
                                        currUserRecipe.contains(element.id))
                                    .take(3);

                                if (fetchRecipe.isEmpty) {
                                  return const SizedBox(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        "Belum Ada Resep\nSilahkan pilih resep",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                                return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(currentRecipeProvider
                                                  .notifier)
                                              .update((state) =>
                                                  fetchRecipe.elementAt(index));
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  const DetailRecipeView(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: CustomColor
                                              .primaryBackgroundColor,
                                          child: RecipeProfileCard(
                                            recipeModel:
                                                fetchRecipe.elementAt(index),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 8,
                                        ),
                                    itemCount: fetchRecipe.length);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

class OnHoverEdit extends HookConsumerWidget {
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextEditingController? controller;
  final Function(String value, WidgetRef ref) onSaved;
  final String value;
  final bool isDesc;
  const OnHoverEdit({
    Key? key,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.controller,
    required this.onSaved,
    required this.value,
    this.isDesc = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final onEdited = useState(false);

    useEffect(() {
      controller?.text = value;

      return;
    }, [value]);
    return InkWell(
      onTap: () => onEdited.value = true,
      child: onEdited.value
          ? TextField(
              cursorColor: Colors.white,
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                filled: true,
                isDense: true,
                fillColor: CustomColor.backgroundTextField,
                suffixIcon: InkWell(
                  onTap: () {
                    onSaved(controller?.text ?? "", ref);
                    onEdited.value = false;
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                ),
                hintText: "Search for food, coffee, etc..",
                hintStyle: const TextStyle(
                  color: CustomColor.borderTextField,
                ),
                suffixIconConstraints: const BoxConstraints(),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CustomColor.borderGreyTextField,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CustomColor.borderGreyTextField,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: CustomColor.borderGreyTextField,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                Text(
                  isDesc && value.isEmpty ? "description" : value,
                  style: TextStyle(
                    color: color,
                    fontStyle:
                        isDesc && value.isEmpty ? FontStyle.italic : null,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    fontSize: fontSize ?? 14,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Icon(
                  Icons.edit,
                  size: 15,
                  color: Colors.white,
                ),
              ],
            ),
    );
  }
}

class LoggedOutWarning extends ConsumerWidget {
  final Widget Function(WidgetRef ref, bool isLoggedOut) builder;
  const LoggedOutWarning({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(currUserProvider).asData?.value;
    return Stack(
      children: [
        builder(ref, user == null),
        if (user == null)
          Center(
            child: GestureDetector(
              onTap: () {
                ref.read(selectedDropdownProvider.notifier).restart();

                if (ref.read(detailActivateProvider)) {
                  ref.read(detailActivateProvider.notifier).back();
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const HomeView(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                      (route) => false);
                }
                ref.read(navLinkProviderProvider.notifier).changeIndex(0);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: CustomColor.bodyPrimaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                    child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    "Harap Login Untuk Mengakses Fitur Ini",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )),
              ),
            ),
          ),
      ],
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  const ShimmerWidget({
    Key? key,
    this.height,
    this.width,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Shimmer.fromColors(
        baseColor: CustomColor.bodyPrimaryColor,
        highlightColor: CustomColor.borderGreyTextField,
        child: child ??
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black,
              ),
            ),
      ),
    );
  }
}

class RecipeProfileCard extends StatelessWidget {
  final RecipeModel? recipeModel;
  const RecipeProfileCard({
    Key? key,
    this.recipeModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Visibility(
            visible: recipeModel != null,
            replacement: const ShimmerWidget(
              child: CircleAvatar(
                radius: 30,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: recipeModel != null
                  ? NetworkImage(recipeModel!.fileUrl)
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0).copyWith(bottom: 2),
                child: Visibility(
                  visible: recipeModel != null,
                  replacement: const ShimmerWidget(
                    height: 16,
                    width: 100,
                  ),
                  child: Text(
                    "${recipeModel?.recipeName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0).copyWith(top: 2),
                child: Visibility(
                  visible: recipeModel != null,
                  replacement: const ShimmerWidget(
                    height: 12,
                    width: 40,
                  ),
                  child: Text(
                    "${recipeModel?.calories} kals",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
