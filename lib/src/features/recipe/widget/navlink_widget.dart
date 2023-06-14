// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavLinkWidget extends HookConsumerWidget {
  final Widget body;
  const NavLinkWidget({
    super.key,
    required this.body,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navLinkProviderProvider);
    final items = <Map<String, dynamic>>[
      {
        'onTap': () {
          ref.read(selectedDropdownProvider.notifier).restart();
          if (ref.read(detailActivateProvider)) {
            ref.read(detailActivateProvider.notifier).back();
          }
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const HomeView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false);
          ref.read(navLinkProviderProvider.notifier).changeIndex(0);
        },
        'icon': Icons.home_outlined,
        'isSelected': selectedIndex == 0
      },
      {
        'onTap': () {
          ref.read(selectedDropdownProvider.notifier).restart();
          if (ref.read(detailActivateProvider)) {
            ref.read(detailActivateProvider.notifier).back();
          }
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const HomeView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false);

          ref.read(navLinkProviderProvider.notifier).changeIndex(1);
        },
        'icon': Icons.settings,
        'isSelected': selectedIndex == 1
      },
      {
        'onTap': () {
          ref.read(selectedDropdownProvider.notifier).restart();
          ref.read(selectedDropdownProvider.notifier).restart();
          if (ref.read(detailActivateProvider)) {
            ref.read(detailActivateProvider.notifier).back();
          }
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const HomeView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false);

          ref.read(navLinkProviderProvider.notifier).changeIndex(2);
        },
        'icon': Icons.person_outline,
        'isSelected': selectedIndex == 2
      },
      {
        'onTap': () {
          ref.read(selectedDropdownProvider.notifier).restart();
          if (ref.read(detailActivateProvider)) {
            ref.read(detailActivateProvider.notifier).back();
          }
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const HomeView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false);

          ref.read(navLinkProviderProvider.notifier).changeIndex(3);
        },
        'icon': Icons.bookmark_outline_outlined,
        'isSelected': selectedIndex == 3
      },
    ];

    var remainingItem = items;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColor.bodyPrimaryColor,
        body: Row(
          children: [
            Container(
              width: 80,
              color: CustomColor.primaryBackgroundColor,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ...remainingItem
                      .map((e) => [
                            ItemTile(
                              isSelected: e['isSelected'],
                              icon: e['icon'],
                              onTap: e['onTap'],
                            ),
                            if (remainingItem.last != e)
                              const SizedBox(
                                height: 10,
                              ),
                          ])
                      .expand((element) => element),
                  Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(currUserProvider).asData?.value;

                      return ItemTile(
                          onTap: () async {
                            ref
                                .read(selectedDropdownProvider.notifier)
                                .restart();
                            if (user != null) {
                              // FirebaseAuth.instance.signOut();
                              // showDialog(context: context, builder: (context) {

                              // },);
                              final value = await confirmation(
                                context: context,
                                message: "Apakah anda yakin untuk logout?",
                              );
                              if (value == OkCancelResult.ok) {
                                FirebaseAuth.instance.signOut();
                              }
                              return;
                            }
                            ref
                                .read(selectedDropdownProvider.notifier)
                                .restart();
                            if (ref.read(detailActivateProvider)) {
                              ref.read(detailActivateProvider.notifier).back();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const HomeView(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                  (route) => false);
                            }
                            ref
                                .read(navLinkProviderProvider.notifier)
                                .changeIndex(0);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginView(),
                                ));
                          },
                          isSelected: selectedIndex == 4,
                          icon: Icons.logout_outlined);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: body,
            )
          ],
        ),
      ),
    );
  }
}

Future<OkCancelResult> confirmation(
    {required BuildContext context, required String message}) {
  return showOkCancelAlertDialog(
    context: context,
    style: AdaptiveStyle.macOS,
    message: message,
    okLabel: "Ya",
  );
}
