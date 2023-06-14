// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/core/core.dart';
import 'package:easy_nutrition/src/features/features.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AllFavoriteRecipe extends ConsumerWidget {
  final bool isUser;
  final User? userPassed;
  const AllFavoriteRecipe({
    super.key,
    this.isUser = false,
    this.userPassed,
  }) : assert((isUser == true && userPassed != null) || (isUser == false));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayam = ref.watch(currentRecipeProvider);
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: CustomColor.bodyPrimaryColor,
        body: NavLinkWidget(
            body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24).copyWith(bottom: 6),
              child: Text(
                isUser ? "Profile ${userPassed?.name}" : "Favorite",
                style: const TextStyle(
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
            Expanded(child: Consumer(
              builder: (context, ref, child) {
                if (userPassed != null) {
                  final recipe = ref.watch(recipeProvider).asData?.value ?? [];
                  final userRecipe = userPassed!.createdRecipe;
                  final fetchRecipe = recipe
                      .where((element) => userRecipe.contains(element.id));
                  final currUser = ref.watch(currUserProvider).asData?.value;
                  if (fetchRecipe.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          "Tidak Ada Resep",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(currentRecipeProvider.notifier)
                                      .update((state) =>
                                          fetchRecipe.elementAt(index));
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const DetailRecipeView(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                                child: Container(
                                  color: CustomColor.bodyPrimaryColor,
                                  child: RecipeProfileCard(
                                    recipeModel: fetchRecipe.elementAt(index),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    ref
                                        .read(currUserProvider.notifier)
                                        .likeDislike(
                                            recipeId: fetchRecipe
                                                .elementAt(index)
                                                .id,
                                            favorite: !(currUser
                                                    ?.favoriteRecipe
                                                    .contains(fetchRecipe
                                                        .elementAt(index)
                                                        .id) ??
                                                false));
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: !(currUser?.favoriteRecipe.contains(
                                                fetchRecipe
                                                    .elementAt(index)
                                                    .id) ??
                                            false)
                                        ? Colors.white
                                        : Colors.pink,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                      itemCount: fetchRecipe.length);
                }
                final user = ref.watch(currUserProvider).asData?.value;
                if (user == null) {
                  return const RecipeProfileCard();
                }
                final recipe = ref.watch(recipeProvider).asData?.value ?? [];
                final currUserRecipe = user.favoriteRecipe;
                final fetchRecipe = recipe
                    .where((element) => currUserRecipe.contains(element.id));

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
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref.read(currentRecipeProvider.notifier).update(
                                    (state) => fetchRecipe.elementAt(index));
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const DetailRecipeView(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Container(
                                color: CustomColor.bodyPrimaryColor,
                                child: RecipeProfileCard(
                                  recipeModel: fetchRecipe.elementAt(index),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  ref
                                      .read(currUserProvider.notifier)
                                      .likeDislike(
                                          recipeId:
                                              fetchRecipe.elementAt(index).id,
                                          favorite: false);
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: fetchRecipe.length);
              },
            )),
          ],
        )),
      ),
    );
  }
}
