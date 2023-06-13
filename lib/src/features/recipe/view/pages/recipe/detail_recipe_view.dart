// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailRecipeView extends HookConsumerWidget {
  const DetailRecipeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(currentRecipeProvider);
    if (recipe == null) {
      return const NavLinkWidget(body: SizedBox());
    }

    final controlller = useTextEditingController();

    final active = useState(-1);
    final reviewRecipe = ref.watch(reviewRecipeProvider);
    return NavLinkWidget(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: !reviewRecipe,
          replacement: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  color: CustomColor.borderGreyTextField,
                  thickness: 2,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: CustomColor.primaryBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.15,
                            foregroundImage: NetworkImage(recipe.fileUrl),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Selamat Menikmati",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(
                                    5,
                                    (index) => InkWell(
                                      onTap: () {
                                        active.value = index;
                                      },
                                      child: Icon(
                                        active.value >= index
                                            ? Icons.star
                                            : Icons.star_outline,
                                        color: active.value >= index
                                            ? Colors.yellow
                                            : Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "Berikan Rating Anda!",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 250,
                            child: TextField(
                              maxLines: 4,
                              controller: controlller,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColor.primaryButtonColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColor.primaryButtonColor,
                                  ),
                                ),
                                hintText: "Berikan komentar anda...",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColor.primaryButtonColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(reviewRecipeProvider.notifier)
                                        .toggle();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 8),
                                    child: Text("Kembali"),
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(recipeProvider.notifier)
                                        .updateRecipe(
                                            recipeModel: recipe.copyWith(
                                          rating: (recipe.rating *
                                                      recipe.totalLikes +
                                                  active.value) /
                                              (recipe.totalLikes + 1),
                                          totalLikes: recipe.totalLikes + 1,
                                          reviews: [
                                            ...recipe.reviews,
                                            Reviews(
                                                desc: controlller.text,
                                                userId: ref
                                                        .read(currUserProvider)
                                                        .asData
                                                        ?.value
                                                        ?.id ??
                                                    ""),
                                          ],
                                        ));
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 8),
                                    child: Text("Submit"),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: CarouselRecipeSteps(recipe: recipe),
        ),
      ),
    );
  }
}

class CarouselRecipeSteps extends HookConsumerWidget {
  final RecipeModel recipe;
  const CarouselRecipeSteps({
    super.key,
    required this.recipe,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxLength = recipe.steps.length;
    final currSteps = useState(0);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Step ${currSteps.value + 1}:",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const Divider(
            color: CustomColor.borderGreyTextField,
            thickness: 2,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: CustomColor.primaryBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(child: Builder(
                    builder: (context) {
                      final e = recipe.steps[currSteps.value];
                      return Column(
                        children: [
                          Expanded(
                            child: Image.network(e.fileUrl),
                          ),
                          Text(e.desc),
                        ],
                      );
                    },
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                          onPressed: currSteps.value == 0
                              ? null
                              : () {
                                  currSteps.value = currSteps.value - 1;
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: CustomColor.primaryButtonColor,
                            disabledForegroundColor: Colors.white,
                            backgroundColor: CustomColor.primaryBackgroundColor,
                            side: const BorderSide(
                              color: CustomColor.primaryButtonColor,
                              width: 1,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(11.0),
                            child: Text("Previous Step"),
                          )),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (index) => [
                                const CircleAvatar(
                                  radius: 10,
                                ),
                                if (index != 4)
                                  const SizedBox(
                                    width: 5,
                                  ),
                              ],
                            ).expand((element) => element).toList(),
                          ),
                        ),
                      ),
                      OutlinedButton(
                          onPressed: () {
                            if (currSteps.value == maxLength - 1) {
                              ref.read(reviewRecipeProvider.notifier).toggle();
                            } else {
                              currSteps.value = currSteps.value + 1;
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: CustomColor.primaryButtonColor,
                            backgroundColor: CustomColor.primaryBackgroundColor,
                            side: const BorderSide(
                              color: CustomColor.primaryButtonColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Text((currSteps.value == maxLength - 1)
                                ? "Reviews"
                                : "Next Step"),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
