import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailRecipeView extends HookConsumerWidget {
  const DetailRecipeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: CustomColor.primaryBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 150,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Selamat Menikmati",
                          style: TextStyle(
                            fontSize: 30,
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
                        const SizedBox(
                          width: 250,
                          child: TextField(
                            maxLines: 4,
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
                        ElevatedButton(
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8),
                              child: Text("Submit"),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Step 1: Potong Bawang Putih",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Potong Bawang Putih",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      CustomColor.primaryButtonColor,
                                  backgroundColor:
                                      CustomColor.primaryBackgroundColor,
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
                                  ref
                                      .read(reviewRecipeProvider.notifier)
                                      .toggle();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      CustomColor.primaryButtonColor,
                                  backgroundColor:
                                      CustomColor.primaryBackgroundColor,
                                  side: const BorderSide(
                                    color: CustomColor.primaryButtonColor,
                                    width: 1,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(11.0),
                                  child: Text("Next Step"),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
