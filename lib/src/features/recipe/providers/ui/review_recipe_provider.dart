import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'last_ui_pprovider.g.dart';

@riverpod
class ReviewRecipe extends _$ReviewRecipe {
  @override
  bool build() {
    return false;
  }

  toggle() {
    state = true;
  }
}
