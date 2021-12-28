import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ClLover? getUser(String? userName) {
  return useFuture(
    useMemoized(() async {
      return await ClClient().getLover(userName: userName ?? "");
    }),
    initialData: null,
  ).data;
}
