// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:easy_nutrition/src/src.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreateRecipe extends HookWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final namaController = useTextEditingController();
    final tabController = useTabController(initialLength: 2);
    final numberStep = useState(1);
    return NavLinkWidget(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: CustomColor.primaryBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        child: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Informasi Resep yang akan ditambahkan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Kembali")),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          tabController.animateTo(1);
                        },
                        child: const Text("Detail Resep")),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        child: RecipeTextField(
                      label: "Nama Masakan",
                      controller: namaController,
                    )),
                    const SizedBox(
                      width: 15,
                    ),
                    const Expanded(
                        child: RecipeTextField(
                      label: "Jumlah Kalori",
                    )),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Kategori"),
                        SizedBox(
                          height: 4,
                        ),
                        CustomDropdownButton(
                          label: "Semua Kategori",
                          backgroundColor: CustomColor.fillTextField,
                        ),
                      ],
                    )),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: const [
                    Text(
                      "Bahan Makanan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(
                      flex: 12,
                    ),
                    Expanded(
                      flex: 6,
                      child: SearchTextField(
                        hintText: "Cari Bahan Makanan",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 600,
                  child: Center(
                    child: Row(
                      children: const [
                        Expanded(
                          child: Center(child: Text("Nama Bahan Makanan")),
                        ),
                        Expanded(
                          child: Center(child: Text("Kuantitas")),
                        ),
                        Expanded(
                          child: Center(child: Text("Aksi")),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: Center(
                  child: SizedBox(
                    width: 600,
                    child: ListView(
                      children: List.generate(
                        100,
                        (index) => [
                          Row(
                            children: [
                              Expanded(
                                child: Center(child: Text("NBahan $index")),
                              ),
                              Expanded(
                                child:
                                    Center(child: Text("${(index % 10) + 1}")),
                              ),
                              Expanded(
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          )),
                                      child: const Icon(Icons.remove),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          )),
                                      child: const Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ).expand((element) => element).toList(),
                    ),
                  ),
                )),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Langkah Resep",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          tabController.animateTo(0);
                        },
                        child: const Text("Kembali")),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Selamat! Resep Sudah Dibuat",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text("Simpan")),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: ListView(
                        children: List.generate(
                            numberStep.value,
                            (index) => [
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: CustomColor.backgroundDetail,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Langkah ${index + 1}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              const Expanded(
                                                child: TextField(
                                                  maxLines: 5,
                                                  cursorColor: Colors.white,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Penjelasan Langkah 1 ...",
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 8),
                                                    isDense: true,
                                                    hintStyle: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                CustomColor.primaryButtonColor,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          height: 80,
                                          width: 120,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ]).expand((element) => element).toList())),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        numberStep.value++;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Tambah Langkah"),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(Icons.add)
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  const RecipeTextField({
    Key? key,
    this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(
          height: 4,
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            fillColor: CustomColor.fillTextField,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.3)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.3)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomColor.orangeForeground, width: 0.3)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.3)),
          ),
        ),
      ],
    );
  }
}
