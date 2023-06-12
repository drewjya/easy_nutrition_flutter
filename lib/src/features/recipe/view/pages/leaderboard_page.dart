import 'package:easy_nutrition/src/core/core.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
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
                                    flex: 3,
                                    child: Center(
                                        child: Text("${data[i].totalPoint}")),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {},
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
