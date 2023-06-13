// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentRecipeProvider = StateProvider.autoDispose<RecipeModel?>((ref) {
  return null;
});

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey =
        useMemoized(() => GlobalKey<ScaffoldState>());
    final recipe = ref.watch(currentRecipeProvider);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColor.bodyPrimaryColor,
        endDrawerEnableOpenDragGesture: false,
        key: scaffoldKey,
        endDrawer: Drawer(
          backgroundColor: CustomColor.primaryBackgroundColor,
          child: Consumer(builder: (context, ref, child) {
            if (recipe == null) {
              return SizedBox();
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.white,
                          )),
                      const Spacer(),
                      Text(
                        recipe.recipeName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'By ${recipe.authorName}',
                        style: TextStyle(
                          color: CustomColor.borderTextField,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          color: CustomColor.borderGreyTextField,
                        ),
                      ),
                    ],
                  ),
                ),
                ...recipe.ingredientList
                    .map((e) => [
                          const CardIngredientsDrawer(
                            ingredients: "2 pcs",
                            name: 'Ayam',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ])
                    .expand((element) => element),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    scaffoldKey.currentState?.closeEndDrawer();
                    ref.read(detailActivateProvider.notifier).active();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const DetailRecipeView(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Masak Sekarang"),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            );
          }),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: HeaderHome(),
                  ),
                  const Divider(
                    color: CustomColor.backgroundTextField,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Choose Dishes",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      CustomDropdownButton(
                        label: "Semua Kategori",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Expanded(
              child: HomeRecipeContent(scaffoldKey: scaffoldKey),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeRecipeContent extends ConsumerWidget {
  const HomeRecipeContent({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(recipeProvider).when(
          data: (data) {
            return ListView(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Center(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: data
                          .map((current) => RecipeCard(
                              recipe: current,
                              onTap: () {
                                ref
                                    .read(currentRecipeProvider.notifier)
                                    .update((state) => current);
                                scaffoldKey.currentState?.openEndDrawer();
                              }))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text("$error"),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}

class CardIngredientsDrawer extends StatelessWidget {
  final String name;
  final String ingredients;

  const CardIngredientsDrawer({
    Key? key,
    required this.name,
    required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 6,
        ),
        Text(
          name,
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
              color: CustomColor.backgroundTextField,
              border: Border.all(
                color: CustomColor.borderTextField,
                width: 0.1,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Center(
              child: Text(
                ingredients,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  final VoidCallback? onTap;
  final RecipeModel recipe;
  const RecipeCard({
    Key? key,
    this.onTap,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      width: 198,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 275,
              width: 190,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: CustomColor.primaryBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 75,
                  ),
                  SizedBox(
                    height: 50,
                    width: 170,
                    child: Center(
                      child: Text(
                        recipe.recipeName,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text("${recipe.timeNeeded} ${recipe.timeFormat}"),
                  const SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...recipe.ingredientList.take(2).map(
                            (e) => Text("${e.name} ${e.quantity} ${e.unit}")),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: onTap,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: Text("Cook Now")),
                      )),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(recipe.fileUrl),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HeaderHome extends StatelessWidget {
  const HeaderHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pemilihan Resep",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(StringUtil.formatDate(DateTime.now())),
          ],
        ),
        const Spacer(),
        Expanded(
            child: SearchTextField(
          hintText: "Search for food, coffee, etc..",
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ));
          },
        )),
      ],
    );
  }
}

class SearchTextField extends HookWidget {
  final VoidCallback? onTap;
  final String? hintText;
  final TextEditingController? controller;
  final Function(String change)? onChanged;

  const SearchTextField({
    super.key,
    this.onTap,
    this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = useState(false);

    return GestureDetector(
      onTap: () {
        isEnabled.value = true;
      },
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: Colors.white,
        onTap: onTap,
        autofocus: false,
        enabled: isEnabled.value,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          filled: true,
          isDense: true,
          fillColor: CustomColor.backgroundTextField,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: CustomColor.borderTextField,
            fontSize: 12,
          ),
          prefixIconConstraints: const BoxConstraints(),
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
      ),
    );
  }
}

class SubheaderWidget extends HookWidget {
  const SubheaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColor.borderGreyTextField,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          "Hot Dishes",
          "Cold Dishes",
          "Soup",
          "Grill",
          "Appetizer",
          "Dessert"
        ]
            .asMap()
            .entries
            .map(
              (e) => SubheaderItem(
                index: e.key,
                selectedIndex: selectedIndex.value,
                value: e.value,
                onTap: () {
                  selectedIndex.value = e.key;
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class SubheaderItem extends StatelessWidget {
  final int index;
  final String value;
  final int selectedIndex;
  final VoidCallback? onTap;
  const SubheaderItem({
    Key? key,
    required this.index,
    required this.value,
    this.onTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: index != 6 ? const EdgeInsets.only(right: 16.0) : EdgeInsets.zero,
      decoration: BoxDecoration(
        border: selectedIndex == index
            ? const Border(
                bottom: BorderSide(
                  color: CustomColor.primaryButtonColor,
                  width: 2,
                ),
              )
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        hoverColor: CustomColor.primaryBackgroundColor,
        child: Container(
          padding: const EdgeInsets.only(bottom: 6, left: 6, right: 6, top: 6),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
