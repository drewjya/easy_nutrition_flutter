import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_providers.g.dart';

@Riverpod(keepAlive: true)
class DetailActivate extends _$DetailActivate {
  @override
  bool build() {
    return false;
  }

  active() {
    state = true;
  }

  back() {
    state = false;
  }
}

final dropdownProvider = Provider<List<String>>((ref) {
  return ["Hot Dishes", "Grill", "Cold Dishes", "Appetizer", "Dessert", "Soup"];
});

@Riverpod(keepAlive: true)
class SelectedDropdown extends _$SelectedDropdown {
  @override
  List<String> build() {
    return [];
  }

  onSelect(String value) {
    final prevState = state;
    if (state.contains(value)) {
      prevState.remove(value);
      print(prevState);
      state = [];
      state = prevState;
    } else {
      state = [];
      state = {...prevState, value}.toList();
    }
  }
}
