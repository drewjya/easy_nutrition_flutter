// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/core/core.dart';
import 'package:easy_nutrition/src/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const SearchAppBar({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(child: child),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 64);
}

class SearchPage extends HookWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final search = useState("");

    final controller = useTextEditingController(); // final recipes =

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: CustomColor.primaryBackgroundColor,
        appBar: SearchAppBar(
          child: TextField(
            controller: controller,
            cursorColor: Colors.white,
            onChanged: (value) {
              search.value = value;
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              filled: true,
              isDense: true,
              fillColor: CustomColor.backgroundTextField,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              hintText: "Search for food, coffee, etc..",
              hintStyle: TextStyle(
                color: CustomColor.borderTextField,
              ),
              prefixIconConstraints: BoxConstraints(),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.borderGreyTextField,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.borderGreyTextField,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColor.borderGreyTextField,
                ),
              ),
            ),
          ),
        ),
        // extendBodyBehindAppBar: true,
        body: Consumer(builder: (context, ref, chil) {
          var recipe = ref.watch(recipeProvider).asData?.value ?? [];

          if (search.value.isNotEmpty) {
            recipe = recipe
                .where((e) => e.recipeName
                    .toLowerCase()
                    .startsWith(search.value.toLowerCase()))
                .toList();
          }
          return ListView(
            children: [
              const SizedBox(
                height: 15,
              ),
              ...recipe
                  .map((e) => [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 0),
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentRecipeProvider.notifier)
                                  .update((state) => e);
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
                              color: Colors.transparent,
                              height: 60,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(e.fileUrl),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0)
                                            .copyWith(bottom: 2),
                                        child: Text(
                                          e.recipeName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0)
                                            .copyWith(top: 2),
                                        child: Text(
                                          "${e.calories} kal",
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
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ])
                  .expand((element) => element),
            ],
          );
        }),
      ),
    );
  }
}
