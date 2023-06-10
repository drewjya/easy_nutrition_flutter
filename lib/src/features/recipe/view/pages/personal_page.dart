import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalPage extends HookConsumerWidget {
  const PersonalPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: SingleChildScrollView(
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
                        const CircleAvatar(
                          radius: 35,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0)
                                    .copyWith(bottom: 4),
                                child: Text(
                                  ref.watch(currUserProvider.select((value) =>
                                      value.asData?.value?.name ?? "")),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.all(8.0).copyWith(top: 4),
                                child: const Text(
                                  "data",
                                  style: TextStyle(
                                    color: CustomColor.borderTextField,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
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
                                onPressed: () {},
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
                        const SizedBox(
                          height: 16,
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final recipe =
                                ref.watch(recipeProvider).asData?.value ?? [];
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
                                height: 200,
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return const RecipeProfileCard();
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
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
                                onPressed: () {},
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
                        const SizedBox(
                          height: 16,
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final recipe =
                                ref.watch(recipeProvider).asData?.value ?? [];
                            final currUserRecipe = ref
                                    .watch(currUserProvider)
                                    .asData
                                    ?.value
                                    ?.favoriteRecipe ??
                                [];
                            final fetchRecipe = recipe
                                .where((element) =>
                                    currUserRecipe.contains(element.id))
                                .take(3);
                            if (fetchRecipe.isEmpty) {
                              return const SizedBox(
                                height: 200,
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return const RecipeProfileCard();
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

class RecipeProfileCard extends StatelessWidget {
  const RecipeProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0).copyWith(bottom: 2),
                child: const Text(
                  "Susilo Widodo",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0).copyWith(top: 2),
                child: const Text(
                  "data",
                  style: TextStyle(
                    color: CustomColor.borderTextField,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
