import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navbar_provider.g.dart';

@Riverpod(keepAlive: true)
class NavLinkProvider extends _$NavLinkProvider {
  @override
  int build() {
    
    return 0;
  }

  changeIndex(int value) {
    state = value;
  }
}
