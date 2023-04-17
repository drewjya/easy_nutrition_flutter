import 'package:easy_nutrition/src/core/core.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> datas = ["Ayam", "Sapi", "Ikan"];

  String search = "";
  @override
  Widget build(BuildContext context) {
    var data = datas;
    if (search.isNotEmpty) {
      data = datas
          .where((e) => e.toLowerCase().startsWith(search.toLowerCase()))
          .toList();
    }
    return Scaffold(
      backgroundColor: CustomColor.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      // extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: ListView(
          children: [
            TextField(
              cursorColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
            const SizedBox(
              height: 15,
            ),
            ...data
                .map((e) => [
                      SizedBox(
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
                                  padding: const EdgeInsets.all(6.0)
                                      .copyWith(bottom: 2),
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0)
                                      .copyWith(top: 2),
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
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ])
                .expand((element) => element),
          ],
        ),
      ),
    );
  }
}
