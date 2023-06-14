import 'dart:developer';
import 'dart:math' as math;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_nutrition/main.dart';
import 'package:easy_nutrition/src/features/recipe/providers/ingredients_provider.dart';
import 'package:easy_nutrition/src/features/recipe/providers/user_provider.dart';
import 'package:easy_nutrition/src/features/recipe/view/pages/edit_recipe.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final indexCreateProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(",") || value.contains(", ")) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value.split("").where((element) => element == ".").length > 1) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class CreateRecipe extends HookWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final namaController = useTextEditingController();
    final kaloriController = useTextEditingController();
    final tabController = useTabController(initialLength: 2);
    final cookTimeController = useTextEditingController();
    final cookTimeUnit = useTextEditingController();

    final file = useState<Uint8List?>(null);

    return NavLinkWidget(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: CustomColor.primaryBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        child: Consumer(builder: (context, ref, child) {
          final currRecipe = ref.watch(currRecipeIngredientProvider);
          final currentSteps = ref.watch(currentStepProvider);
          return [
            TabBarView(
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
                            onPressed: () {
                              ref
                                  .read(selectedDropdownProvider.notifier)
                                  .restart();
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

                              ref
                                  .read(navLinkProviderProvider.notifier)
                                  .changeIndex(1);
                            },
                            child: const Text("Kembali")),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (namaController.text.isEmpty) {
                                showToast(message: "Nama Tidak Boleh Kosong");
                                return;
                              } else if (kaloriController.text.isEmpty) {
                                showToast(message: "Kalori Tidak Boleh Kosong");
                                return;
                              } else if (cookTimeController.text.isEmpty) {
                                showToast(
                                    message: "Waktu Masak Tidak Boleh Kosong");
                                return;
                              } else if (cookTimeUnit.text.isEmpty) {
                                showToast(
                                    message: "Format Waktu Tidak Boleh Kosong");
                                return;
                              } else if (ref
                                  .read(selectedDropdownProvider)
                                  .isEmpty) {
                                showToast(
                                    message: "Kategori Tidak Boleh Kosong");
                                return;
                              } else if (ref
                                  .read(currRecipeIngredientProvider)
                                  .isEmpty) {
                                showToast(
                                    message:
                                        "Bahan Masakan Tidak Boleh Kosong");
                                return;
                              } else if (file.value == null) {
                                showToast(
                                    message: "Gambar Resep Tidak Boleh Kosong");
                                return;
                              }
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
                        ImagePickerWidget(
                          url: "",
                          file: file.value,
                          onPicked: (onFile) {
                            file.value = onFile;
                          },
                          child: const Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: RecipeTextField(
                          label: "Nama Masakan",
                          controller: namaController,
                        )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: RecipeTextField(
                          label: "Jumlah Kalori",
                          controller: kaloriController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2)
                          ],
                        )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Kategori"),
                            const SizedBox(
                              height: 4,
                            ),
                            Consumer(builder: (context, ref, child) {
                              final selectedDropdown =
                                  ref.watch(selectedDropdownProvider);

                              String label;
                              if (selectedDropdown.isEmpty) {
                                label = "Semua Kategori";
                              } else {
                                final count =
                                    ((selectedDropdown.length - 1) == 0)
                                        ? ""
                                        : "+${selectedDropdown.length - 1}";

                                label = "${selectedDropdown.first}$count";
                              }

                              return CustomDropdownButton(
                                label: label,
                                backgroundColor: CustomColor.fillTextField,
                              );
                            }),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bahan Makanan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Format Waktu"),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomTextField(
                                  margin: 0,
                                  values: const [
                                    "minute",
                                    "hour",
                                    "day",
                                  ],
                                  controller: cookTimeUnit,
                                  hintText: "",
                                  onTap: (value) {
                                    cookTimeUnit.text = value;
                                  },
                                  labelText: ""),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: RecipeTextField(
                            label: "Waktu Masak",
                            controller: cookTimeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2)
                            ],
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
                    Expanded(child: Consumer(builder: (context, ref, child) {
                      if (currRecipe.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Mohon Tambahkan Bahan Makanan",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TambahBahanButton(),
                          ],
                        );
                      }
                      return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            ...currRecipe.map(
                              (e) => Column(
                                children: [
                                  SizedBox(
                                    width: 600,
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(child: Text(e.name)),
                                          ),
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                    "${e.quantity} ${e.unit}${e.quantity.addS}")),
                                          ),
                                          Expanded(
                                            child: Center(
                                                child: OutlinedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .backgroundDialog,
                                                            content: QuantityDialog(
                                                                id: e
                                                                    .ingredientId,
                                                                name: e.name,
                                                                description: "",
                                                                unit: e.unit,
                                                                quantity:
                                                                    e.quantity),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                        Icons.more_horiz))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                            const TambahBahanButton(),
                          ]);
                    })),
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
                            onPressed: () async {
                              if (currentSteps.isEmpty) {
                                showToast(message: "Steps tidak boleh kosong");
                                return;
                              }
                              for (var i = 0; i < currentSteps.length; i++) {
                                if (currentSteps[i].desc.isEmpty) {
                                  showToast(
                                      message: "Steps tidak boleh kosong");
                                  return;
                                }
                                if (currentSteps[i].file == null) {
                                  showToast(
                                      message:
                                          "Gambar Steps Tidak Boleh Kosong");
                                  return;
                                }
                              }

                              final confirm = await confirmation(
                                  context: context,
                                  message:
                                      "Apakah anda yakin untuk membuat resep ini?");
                              log("${confirm == OkCancelAlertDefaultType.ok}");
                              if (confirm == OkCancelResult.ok) {
                                final id = const Uuid().v4();
                                showLoadingDialog(context: context);
                                await ref
                                    .read(recipeProvider.notifier)
                                    .createRecipe(
                                      recipeId: id,
                                      name: namaController.text,
                                      calories:
                                          num.parse(kaloriController.text),
                                      categories:
                                          ref.read(selectedDropdownProvider),
                                      steps: currentSteps,
                                      recipeFile:
                                          file.value ?? currentSteps[0].file!,
                                      ingredientRecipe: ref
                                          .read(currRecipeIngredientProvider),
                                      timeNeeded:
                                          num.parse(cookTimeController.text),
                                      timeFormat: cookTimeUnit.text,
                                    );

                                await ref
                                    .read(currUserProvider.notifier)
                                    .createRecipe(recipeId: id);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  showOkAlertDialog(
                                          context: context,
                                          style: AdaptiveStyle.macOS,
                                          message:
                                              "Selamat Berhasil Membuat Resep",
                                          title: "Pesan")
                                      .then((value) {
                                    if (ref.read(detailActivateProvider)) {
                                      ref
                                          .read(detailActivateProvider.notifier)
                                          .back();
                                      ref
                                          .read(
                                              selectedDropdownProvider.notifier)
                                          .restart();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                const HomeView(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                          (route) => false);
                                    }
                                  });
                                }
                              }
                            },
                            child: const Text("Simpan")),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                        child: ListView(
                            children: currentSteps
                                .mapIndexed((e, index) => [
                                      StepsWidget(step: e, index: index),
                                      const SizedBox(
                                        height: 15,
                                      )
                                    ])
                                .expand((element) => element)
                                .toList())),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(currentStepProvider.notifier)
                                .addStepPlaceHolder();
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
            const AddNewIngredient(),
            const AddIngredientToAll(),
          ][ref.watch(indexCreateProvider)];
        }),
      ),
    );
  }
}

class StepsWidget extends HookConsumerWidget {
  final Steps step;
  final int index;
  const StepsWidget({
    super.key,
    required this.step,
    required this.index,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = useTextEditingController();
    useEffect(() {
      controller.text = step.desc;
      return;
    }, []);
    log("$step");
    log("${controller.text}");
    return InkWell(
      onTap: () {
        ref.read(currentStepProvider.notifier).removeStep(id: step.id);
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: CustomColor.backgroundDetail,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: TextField(
                      controller: controller,
                      maxLines: 5,
                      onChanged: (value) => ref
                          .read(currentStepProvider.notifier)
                          .updateStep(
                              content: value,
                              picture: step.fileUrl,
                              id: step.id,
                              file: step.file),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Penjelasan Langkah ${index + 1} ...",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        isDense: true,
                        hintStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
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
            AnimatedButton(
              onTap: () async {
                final file = await pickImage(source: ImageSource.camera);
                ref.read(currentStepProvider.notifier).updateStep(
                    content: step.desc,
                    picture: step.fileUrl,
                    id: step.id,
                    file: file);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColor.primaryButtonColor,
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                height: 80,
                width: 120,
                child: step.file != null
                    ? Image.memory(
                        step.file!,
                        fit: BoxFit.cover,
                      )
                    : step.fileUrl.isNotEmpty
                        ? Image.network(
                            step.fileUrl,
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Uint8List?> pickImageWeb() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final fileBytes = result.files.first.bytes;

    return fileBytes;
  }
  return null;
}

Future<Uint8List?> pickImage({required ImageSource source}) async {
  // final picker = ImagePicker();
  // if (kIsWeb) {
  //   XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       var f = await image.readAsBytes();
  //       setState(() {
  //         _file = File("a");
  //         webImage = f;
  //       });
  //   return webPicker == null ? null : File.fromRawPath(webPicker);
  // }
  final picker = ImagePicker();

  final image = await picker.pickImage(source: source);
  if (image == null) {
    return null;
  }

  return image.readAsBytes();
}

class AddIngredientToAll extends HookConsumerWidget {
  const AddIngredientToAll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final shelfTimeController = useTextEditingController();
    final shelfUnitController = useTextEditingController(text: "hour");
    final unitController = useTextEditingController(text: "gr");
    final tipsController = useTextEditingController();

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Tambah Ingredients",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  ref.read(indexCreateProvider.notifier).update((state) => 1);
                },
                child: const Text("Kembali")),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    snackbarKey.currentState?.showSnackBar(
                        const SnackBar(content: Text("Nama harus diisi")));
                    return;
                  }
                  if (shelfTimeController.text.isEmpty ||
                      num.parse(shelfTimeController.text) <= 0) {
                    snackbarKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("Shelf Time harus diisi")));
                    return;
                  }
                  if (shelfUnitController.text.isEmpty) {
                    snackbarKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("Shelf Unit harus diisi")));
                    return;
                  }
                  if (unitController.text.isEmpty) {
                    snackbarKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("Ingredients Unti harus diisi")));
                    return;
                  }
                  if (tipsController.text.isEmpty) {
                    snackbarKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("Tips penyimpanan harus diisi")));
                    return;
                  }

                  ref.read(ingredientsProvider.notifier).createIngredients(
                      ingredientModel: Ingredients(
                          id: const Uuid().v4(),
                          ingredientName: nameController.text,
                          shelfTime: num.parse(shelfTimeController.text),
                          shelftUnit: shelfUnitController.text,
                          unit: unitController.text,
                          description: tipsController.text));
                  ref.read(indexCreateProvider.notifier).update((state) => 1);
                },
                child: const Text("Submit")),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(
                      controller: nameController,
                      hintText: "",
                      labelText: "Name"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: shelfTimeController,
                      hintText: "",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      labelText: "Shelf Time (num)"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      values: const [
                        "minute",
                        "hour",
                        "day",
                        "week",
                        "month",
                        "year",
                      ],
                      controller: shelfUnitController,
                      hintText: "",
                      onTap: (value) {
                        shelfUnitController.text = value;
                      },
                      labelText: "Shelf Unit"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      values: const [
                        "gr",
                        "kg",
                        "litre",
                        "cc/ml",
                        "cup",
                        "tbsp",
                        "tsp",
                        "pc"
                      ],
                      onTap: (value) => unitController.text = value,
                      controller: unitController,
                      hintText: "",
                      labelText: "Unit Saved"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: tipsController,
                    maxLines: 5,
                    hintText: "",
                    labelText: "Tips for Storing Food/Beverages",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddNewIngredient extends HookConsumerWidget {
  const AddNewIngredient({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = useTextEditingController();
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Tambah Bahan Makanan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  ref.read(indexCreateProvider.notifier).update((state) => 0);
                },
                child: const Text("Kembali")),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: SearchTextField(
                hintText: "Search for food, coffee, etc..",
                controller: controller,
                onChanged: (change) {
                  ref
                      .read(searchIngredientsProvider.notifier)
                      .update((state) => change);
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(indexCreateProvider.notifier).update((state) => 2);
                },
                child: const Text("Tambah Bahan Baru"))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
            child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            ref.watch(ingredientsProvider).maybeWhen(
              orElse: () {
                return const SizedBox();
              },
              data: (data) {
                final searchIngredient = ref.watch(searchIngredientsProvider);
                if (searchIngredient.isNotEmpty) {
                  data = data
                      .where((element) =>
                          element.ingredientName.contains(searchIngredient))
                      .toList();
                }
                return Column(
                  children: [
                    ...data.map((e) => IngredientCard(
                        ingredients: e,
                        onTap: (e) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: CustomColor.backgroundDialog,
                                content: QuantityDialog(
                                    id: e.id,
                                    name: e.ingredientName,
                                    description: e.description,
                                    unit: e.unit),
                              );
                            },
                          );
                        }))
                  ],
                );
              },
            ),
          ],
        )),
      ],
    );
  }
}

class QuantityDialog extends HookConsumerWidget {
  final String id;
  final String name;
  final num? quantity;
  final String description;
  final String unit;

  const QuantityDialog({
    Key? key,
    required this.id,
    required this.name,
    this.quantity,
    required this.description,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final focusNode = useFocusNode();
    final controller = useTextEditingController(text: "0");
    useEffect(() {
      final list = ref.read(currRecipeIngredientProvider);
      if (quantity != null) {
        controller.text = quantity.toString();
      } else {
        for (var i = 0; i < list.length; i++) {
          if (list[i].ingredientId == id) {
            controller.text = list[i].quantity.toString();
          }
        }
      }
      return;
    }, []);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Bahan Makanan: $name"),
          ),
          Row(
            children: [
              const Text("Quantity"),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    controller.changeOne(false);
                  },
                  icon: const Icon(Icons.remove)),
              SizedBox(
                width: 50,
                child: EditableText(
                    textAlign: TextAlign.center,
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(),
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    cursorColor: Colors.white,
                    backgroundCursorColor: Colors.white),
              ),
              IconButton(
                  onPressed: () {
                    controller.changeOne(true);
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
          Text("TIPS: $description"),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"))),
                const SizedBox(
                  width: 20,
                ),
                if (ref
                    .watch(currRecipeIngredientProvider)
                    .map((e) => e.ingredientId)
                    .contains(id))
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            ref
                                .read(currRecipeIngredientProvider.notifier)
                                .removeIngredients(ingredientId: id);
                            Navigator.pop(context);
                          },
                          child: const Text("Hapus"))),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          final data = num.parse(controller.text);
                          log("$data");
                          if (controller.text.isEmpty ||
                              num.parse(controller.text) <= 0) {
                            showToast(message: "Kuantitas Tidak Boleh Kosong");
                            return;
                          }
                          ref
                              .read(currRecipeIngredientProvider.notifier)
                              .addIngredients(
                                  ingredients: IngredientRecipe(
                                      ingredientId: id,
                                      name: name,
                                      quantity: num.parse(controller.text),
                                      unit: unit));

                          Navigator.pop(context);
                        },
                        child: const Text("Tambah"))),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension TextEditingConX on TextEditingController {
  changeOne(bool isIncrement) {
    final value = num.tryParse(text) ?? 0;
    final res = isIncrement ? value + 1 : value - 1;
    if (res < 0) {
      text = "0";
      return;
    } else {
      text = "$res";
      return;
    }
  }
}

final searchIngredientsProvider = StateProvider.autoDispose<String>((ref) {
  return "";
});

class IngredientCard extends ConsumerWidget {
  final Ingredients ingredients;
  final void Function(Ingredients ingredients) onTap;
  const IngredientCard({
    super.key,
    required this.ingredients,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedButton(
        onTap: () => onTap(ingredients),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColor.borderGreyTextField,
          ),
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0).copyWith(bottom: 2),
                      child: Text(
                        ingredients.ingredientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0).copyWith(top: 2),
                      child: Text(
                        ingredients.description,
                        style: const TextStyle(
                          color: CustomColor.borderTextField,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                  "${ingredients.shelfTime} ${ingredients.shelftUnit}${ingredients.shelfTime.addS}")
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends HookWidget {
  const AnimatedButton({
    super.key,
    required this.child,
    this.onTap,
  });
  final Widget child;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final scale = useState(1.0);
    return GestureDetector(
      onTap: () async {
        scale.value = 0.95;
        await Future.delayed(const Duration(milliseconds: 100));
        onTap?.call();
        scale.value = 1;
      },
      child: AnimatedScale(
          scale: scale.value,
          duration: const Duration(milliseconds: 75),
          child: child),
    );
  }
}

extension NumExtension on num {
  String get addS {
    if (this > 1) {
      return "s";
    } else {
      return "";
    }
  }
}

class TambahBahanButton extends ConsumerWidget {
  const TambahBahanButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return ElevatedButton(
        onPressed: () {
          ref.read(indexCreateProvider.notifier).update((state) => 1);
        },
        child: const Text("Tambah Bahan Makanan"));
  }
}

class RecipeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  const RecipeTextField({
    Key? key,
    this.controller,
    required this.label,
    this.keyboardType,
    this.inputFormatters = const [],
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
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
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

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String change)? onChanged;
  final String hintText;
  final String labelText;
  final Function(String value)? onTap;
  final List<String> values;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int? maxLines;
  final double? margin;
  const CustomTextField({
    Key? key,
    this.controller,
    this.margin,
    this.onChanged,
    required this.hintText,
    required this.labelText,
    this.onTap,
    this.values = const [],
    this.keyboardType,
    this.inputFormatters = const [],
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return OnTapField(
        values: values,
        onTap: onTap!,
        margin: margin,
        controller: controller,
        labelText: labelText,
      );
    }

    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      cursorColor: Colors.white,
      autofocus: false,
      enabled: true,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        filled: true,
        isDense: true,
        fillColor: CustomColor.bodyPrimaryColor,
        labelText: labelText,
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
      maxLines: maxLines,
    );
  }
}

class OnTapField extends HookWidget {
  final TextEditingController? controller;
  final String labelText;
  final Function(String value) onTap;
  final List<String> values;
  final double? margin;
  const OnTapField({
    Key? key,
    this.controller,
    required this.labelText,
    required this.onTap,
    required this.values,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = useState("");
    useEffect(() {
      text.value = controller?.text ?? "";
      void func() {
        text.value = controller?.text ?? "";
      }

      controller?.addListener(func);
      if (controller != null) {
        return () => controller!.removeListener(func);
      }
      return null;
    }, []);
    return Container(
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: const Border.fromBorderSide(BorderSide(
                  color: CustomColor.borderGreyTextField,
                )),
                color: CustomColor.bodyPrimaryColor,
              ),
              padding: margin != null
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(2),
              margin: EdgeInsets.only(top: margin ?? 10),
              child: Row(
                  children: values
                      .map((e) => Expanded(
                            child: OnTapChild(
                              label: e,
                              isActive: text.value == e,
                              onTap: onTap,
                            ),
                          ))
                      .toList())),
          Positioned(
            child: Text(
              labelText,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
              ),
            ),
            left: 2,
            top: -2,
          )
        ],
      ),
    );
  }
}

class OnTapChild extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function(String value) onTap;

  const OnTapChild({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(label),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColor.borderTextField,
          ),
          color: isActive ? Colors.white : null,
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(2),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? CustomColor.fillTextField : null,
            ),
          ),
        ),
      ),
    );
  }
}

showToast({required String message}) {
  snackbarKey.currentState?.removeCurrentSnackBar();
  snackbarKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
