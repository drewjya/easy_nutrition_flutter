// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_nutrition/src/features/recipe/providers/ingredients_provider.dart';
import 'package:easy_nutrition/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class EditRecipePage extends HookConsumerWidget {
  final RecipeModel recipeModel;
  const EditRecipePage({
    super.key,
    required this.recipeModel,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final kaloriController = useTextEditingController();
    final cookTime = useTextEditingController();

    final currIngredients = ref.watch(currRecipeIngredientProvider);
    final currSteps = ref.watch(currentStepProvider);
    final unitTime = useTextEditingController();
    final file = useState<Uint8List?>(null);

    useEffect(() {
      nameController.text = recipeModel.recipeName;
      kaloriController.text = recipeModel.calories.toString();
      cookTime.text = "${recipeModel.timeNeeded}";
      unitTime.text = recipeModel.timeFormat;
      Future.microtask(() {
        ref
            .read(selectedDropdownProvider.notifier)
            .onList(recipeModel.categoriesList);
        ref
            .read(currRecipeIngredientProvider.notifier)
            .addList(recipeModel.ingredientList);
        ref.read(currentStepProvider.notifier).listSteps(recipeModel.steps);
        ref.read(currentStepProvider.notifier).addStepPlaceHolder();
        return null;
      });
      return;
    }, []);
    log("${unitTime.value}");

    return Scaffold(
      backgroundColor: CustomColor.bodyPrimaryColor,
      body: NavLinkWidget(
          body: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20)
                  .copyWith(bottom: 6),
              child: Row(
                children: [
                  const Text(
                    "Edit Recipe",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                      onPressed: () async {
                        final confirm = await confirmation(
                            context: context,
                            message:
                                "Apakah anda yakin untuk menghapus resep ini?");

                        if (confirm == OkCancelResult.ok) {
                          await ref
                              .read(recipeProvider.notifier)
                              .deleteRecipe(recipeModel: recipeModel);

                          if (context.mounted) {
                            showOkAlertDialog(
                                    context: context,
                                    style: AdaptiveStyle.macOS,
                                    message: "Berhasil Menghapus Resep",
                                    title: "Pesan")
                                .then((value) {
                              if (ref.read(detailActivateProvider)) {
                                ref
                                    .read(detailActivateProvider.notifier)
                                    .back();
                              }
                              ref
                                  .read(selectedDropdownProvider.notifier)
                                  .restart();
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
                            });
                          }
                        }
                      },
                      child: const Icon(Icons.delete)),
                  const SizedBox(
                    width: 15,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty) {
                          showToast(message: "Nama resep tidak boleh kosong");
                          return;
                        }
                        if (kaloriController.text.isEmpty) {
                          showToast(message: "Kalori resep tidak boleh kosong");
                          return;
                        }
                        if (ref.read(selectedDropdownProvider).isEmpty) {
                          showToast(
                              message: "Kategori resep tidak boleh kosong");
                          return;
                        }

                        if (currIngredients.isEmpty) {
                          showToast(message: "Bahan resep tidak boleh kosong");
                          return;
                        }

                        if (currSteps.isEmpty) {
                          showToast(message: "Steps tidak boleh kosong");
                          return;
                        }
                        for (var i = 0; i < currSteps.length; i++) {
                          if (currSteps[i].desc.isEmpty) {
                            showToast(message: "Steps tidak boleh kosong");
                            return;
                          }
                          if (currSteps[i].file == null &&
                              currSteps[i].fileUrl.isEmpty) {
                            showToast(
                                message: "Gambar Steps Tidak Boleh Kosong");
                            return;
                          }
                        }

                        final confirm = await confirmation(
                            context: context,
                            message:
                                "Apakah anda yakin untuk mengubah resep ini?");

                        if (confirm == OkCancelResult.ok) {
                          // final id = const Uuid().v4();
                          await ref.read(recipeProvider.notifier).updateRecipe(
                                file: file.value,
                                recipeModel: recipeModel.copyWith(
                                    recipeName: nameController.text,
                                    calories: num.parse(kaloriController.text),
                                    categoriesList:
                                        ref.read(selectedDropdownProvider),
                                    steps: currSteps,
                                    ingredientList: currIngredients,
                                    timeFormat: unitTime.text,
                                    timeNeeded: num.parse(cookTime.text)),
                              );

                          if (context.mounted) {
                            showOkAlertDialog(
                                    context: context,
                                    style: AdaptiveStyle.macOS,
                                    message: "Selamat Berhasil Mengubah Resep",
                                    title: "Pesan")
                                .then((value) {
                              if (ref.read(detailActivateProvider)) {
                                ref
                                    .read(detailActivateProvider.notifier)
                                    .back();
                              }
                              ref
                                  .read(selectedDropdownProvider.notifier)
                                  .restart();
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
                            });
                          }
                        }
                      },
                      child: const Text("Save")),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: CustomColor.borderGreyTextField,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: ImagePickerWidget(
                            url: recipeModel.fileUrl,
                            onPicked: (onFile) {
                              file.value = onFile;
                            },
                            radius: 40,
                            file: file.value),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      EditRecipeField(
                        controller: nameController,
                        labelText: "Nama Resep",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      EditRecipeField(
                        controller: kaloriController,
                        labelText: "Kalori Resep",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kalori resep tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomDropdownButton(label: () {
                        final selectedDropdown =
                            ref.watch(selectedDropdownProvider);

                        String label;
                        if (selectedDropdown.isEmpty) {
                          label = "Semua Kategori";
                        } else {
                          final count = ((selectedDropdown.length - 1) == 0)
                              ? ""
                              : "+${selectedDropdown.length - 1}";

                          label = "${selectedDropdown.first}$count";
                        }
                        return label;
                      }()),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                          controller: cookTime,
                          hintText: "",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2)
                          ],
                          labelText: "Cook Time"),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                          values: const [
                            "minute",
                            "hour",
                            "day",
                          ],
                          controller: unitTime,
                          hintText: "",
                          onTap: (value) {
                            unitTime.text = value;
                          },
                          labelText: "Time Format"),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Ingredients",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: SizedBox(
                          width: 600,
                          child: Center(
                            child: Row(
                              children: const [
                                Expanded(
                                  child:
                                      Center(child: Text("Nama Bahan Makanan")),
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
                      ),
                      if (currIngredients.isEmpty) ...[
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: const Text(
                            "Mohon Tambahkan Bahan Makanan",
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                      ...(currIngredients.map((e) => [
                            Center(
                              child: SizedBox(
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
                                                            id: e.ingredientId,
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
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ])).expand((element) => element),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(child: TambahBahanButton()),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Langkah Resep",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ...currSteps
                          .mapIndexed((e, index) => [
                                StepsWidget(step: e, index: index),
                                const SizedBox(
                                  height: 15,
                                )
                              ])
                          .expand((element) => element),
                      const SizedBox(
                        height: 20,
                      ),
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
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const AddNewIngredient(),
        const AddIngredientToAll(),
      ][ref.watch(indexCreateProvider)]),
    );
  }
}

class EditRecipeField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  const EditRecipeField({
    Key? key,
    this.controller,
    required this.labelText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        filled: true,
        isDense: true,
        fillColor: CustomColor.backgroundTextField,
        labelText: labelText,
        hintStyle: const TextStyle(
          color: CustomColor.borderTextField,
        ),
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
    );
  }
}

class ImagePickerWidget extends HookConsumerWidget {
  final Uint8List? file;
  final String url;
  final Function(Uint8List? onFile) onPicked;
  final double? radius;
  final Widget? child;
  const ImagePickerWidget({
    super.key,
    this.file,
    this.child,
    required this.url,
    this.radius,
    required this.onPicked,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ImageProvider<Object>? b;
    b = (file != null) ? MemoryImage(file!) : null;
    b ??= (url.isNotEmpty ? NetworkImage(url) : null);
    return GestureDetector(
      onTap: () async {
        if(!kIsWeb){
        final choose = await showConfirmationDialog<ImageSource>(
          style: AdaptiveStyle.macOS,
          context: context,
          actions: [
            const AlertDialogAction(key: ImageSource.camera, label: "Camera"),
            const AlertDialogAction(key: ImageSource.gallery, label: "Gallery"),
          ],
          title: "Pilih Gambar",
          okLabel: "Pilih",
          cancelLabel: "Cancel",
        );

       
        if (choose != null) {
          final filePicked = await pickImage(source: choose);
          log("$filePicked");
          onPicked(filePicked);
        }

        }else{
             final filePicked = await pickImageWeb();
          log("$filePicked");
          onPicked(filePicked);

        }
      },
      child: CircleAvatar(
        radius: radius ?? 30,
        backgroundColor: Colors.grey.shade600,
        backgroundImage: b,
        child: b == null ? child : null,
      ),
    );
  }
}
