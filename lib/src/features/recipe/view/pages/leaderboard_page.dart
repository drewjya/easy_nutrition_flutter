import 'package:easy_nutrition/src/core/core.dart';
import 'package:easy_nutrition/src/features/features.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final recipeList = ref.watch(recipeProvider).asData?.value ?? [];
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: CustomColor.primaryBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Leaderboard",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColor.backgroundTextField,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12.0).copyWith(
                      top: 8,
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Center(child: Text("No")),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(child: Text("Nama")),
                        ),
                        Expanded(
                          flex: 4,
                          child: Center(child: Text("Point")),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(child: Text("Aksi")),
                        ),
                      ],
                    ),
                  ),
                  ...ref.watch(userProvider).maybeWhen(
                    data: (data) {
                      data.sort(
                        (a, b) {
                          final acount =
                              recipeList.fold(0.0, (previousValue, element) {
                            if (element.authorId == a.id) {
                              return element.rating * element.totalLikes +
                                  previousValue;
                            }
                            return previousValue;
                          });
                          final bcount =
                              recipeList.fold(0.0, (previousValue, element) {
                            if (element.authorId == b.id) {
                              return element.rating * element.totalLikes +
                                  previousValue;
                            }
                            return previousValue;
                          });

                          return bcount.compareTo(acount);
                        },
                      );
                      return [
                        for (var i = 0; i < data.length; i++)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Center(child: Text("${i + 1}")),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Center(child: Text(data[i].name)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Center(
                                        child: Builder(builder: (context) {
                                      final count = recipeList.fold(0.0,
                                          (previousValue, element) {
                                        if (element.authorId == data[i].id) {
                                          return element.rating *
                                                  element.totalLikes +
                                              previousValue;
                                        }
                                        return previousValue;
                                      });

                                      return Center(
                                          child: Text("${count.toInt()}"));
                                    })),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final currUser = ref
                                              .watch(currUserProvider)
                                              .asData
                                              ?.value;
                                          if (currUser == null) {
                                            showToast(
                                                message:
                                                    "Silahkan Login Terlebih Dahulu");
                                            return;
                                          }
                                          if (currUser.id == data[i].id) {
                                            ref
                                                .read(selectedDropdownProvider
                                                    .notifier)
                                                .restart();

                                            if (ref
                                                .read(detailActivateProvider)) {
                                              ref
                                                  .read(detailActivateProvider
                                                      .notifier)
                                                  .back();
                                            }
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation1,
                                                          animation2) =>
                                                      const HomeView(),
                                                  transitionDuration:
                                                      Duration.zero,
                                                  reverseTransitionDuration:
                                                      Duration.zero,
                                                ),
                                                (route) => false);

                                            ref
                                                .read(navLinkProviderProvider
                                                    .notifier)
                                                .changeIndex(2);
                                            return;
                                          }
                                          ref
                                              .read(selectedDropdownProvider
                                                  .notifier)
                                              .restart();

                                          if (ref
                                              .read(detailActivateProvider)) {
                                            ref
                                                .read(detailActivateProvider
                                                    .notifier)
                                                .back();
                                          }
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    ProfilePage(user: data[i]),
                                                transitionDuration:
                                                    Duration.zero,
                                                reverseTransitionDuration:
                                                    Duration.zero,
                                              ),
                                              (route) => false);
                                        },
                                        child: const Text("Lihat Profile"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                      ];
                    },
                    orElse: () {
                      return [];
                    },
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
