// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/features/recipe/view/pages/all_favorite_recipe.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/edit_recipe.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  final User user;
  const ProfilePage({
    super.key,
    required this.user,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeA = ref.watch(currentRecipeProvider);
    return Scaffold(
      body: NavLinkWidget(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24)
                    .copyWith(bottom: 6),
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
                                AbsorbPointer(
                                  absorbing: true,
                                  child: ImagePickerWidget(
                                    onPicked: (file) {},
                                    url: user.profileUrl ?? '',
                                    file: null,
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 45,
                                        color:
                                            CustomColor.primaryBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0)
                                            .copyWith(bottom: 4),
                                        child: Text(
                                          user.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0)
                                            .copyWith(top: 4),
                                        child: Text(
                                          user.desc.isEmpty
                                              ? "desc"
                                              : user.desc,
                                          style: TextStyle(
                                              fontStyle: user.desc.isEmpty
                                                  ? FontStyle.italic
                                                  : null,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color:
                                                  CustomColor.borderTextField),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AllFavoriteRecipe(
                                                      isUser: true,
                                                      userPassed: user),
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
                                    final recipe = ref
                                            .watch(recipeProvider)
                                            .asData
                                            ?.value ??
                                        [];
                                    final currUserRecipe = user.createdRecipe;

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
                                                  .update((state) => fetchRecipe
                                                      .elementAt(index));
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation1,
                                                          animation2) =>
                                                      const DetailRecipeView(),
                                                  transitionDuration:
                                                      Duration.zero,
                                                  reverseTransitionDuration:
                                                      Duration.zero,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              color: CustomColor
                                                  .primaryBackgroundColor,
                                              child: RecipeProfileCard(
                                                recipeModel: fetchRecipe
                                                    .elementAt(index),
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
        ),
      ),
    );
  }
}
