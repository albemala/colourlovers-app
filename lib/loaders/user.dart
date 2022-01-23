import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ClLover? loadUser(String? userName) {
  return useFuture(
    useMemoized(() async {
      return ClClient().getLover(userName: userName ?? '');
    }),
    initialData: null,
  ).data;
}
