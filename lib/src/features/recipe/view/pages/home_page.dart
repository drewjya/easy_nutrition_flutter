// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:easy_nutrition/src/core/core.dart';
import 'package:easy_nutrition/src/core/util/string_util.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey =
        useMemoized(() => GlobalKey<ScaffoldState>());
    return Scaffold(
      backgroundColor: CustomColor.bodyPrimaryColor,
      endDrawerEnableOpenDragGesture: false,
      key: scaffoldKey,
      endDrawer: Drawer(
        backgroundColor: CustomColor.primaryBackgroundColor,
        child: ListView(
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
                  const Text(
                    'Java',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Java',
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
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(),
              title: Text(
                "ss",
              ),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(),
              title: Text(
                "ss",
              ),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(),
              title: Text(
                "ss",
              ),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(),
              title: Text(
                "ss",
              ),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(),
              title: Text(
                "ss",
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Masak Sekarang"),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: HeaderHome(),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SubheaderWidget(),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    const Text(
                      "Choose Dishes",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Semua Kategori")),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: List.generate(
                    10,
                    (index) => RecipeCard(onTap: () {
                          print(scaffoldKey.currentState);
                          scaffoldKey.currentState?.openEndDrawer();
                        })),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final VoidCallback? onTap;
  const RecipeCard({
    Key? key,
    this.onTap,
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
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Salted Pasta with mushroom sauce",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                      child: Center(
                        child: Text("data"),
                      ),
                    ),
                    const Text("data"),
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
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(100)),
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
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.white,
      ),
      child: Row(
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
          const Expanded(
              child: TextField(
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
          )),
        ],
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
        child: Container(
          padding: const EdgeInsets.only(bottom: 6, left: 6, right: 6),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
