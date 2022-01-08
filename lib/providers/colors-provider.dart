import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

List<ClColor?> getColors(List<String>? colors) {
  return useFuture(
        useMemoized(() async {
          return Future.wait<ClColor?>(
            (colors ?? []).map((color) => ClClient().getColor(hex: color)),
          );
        }),
        initialData: <ClColor?>[],
      ).data ??
      <ClColor?>[];
}
