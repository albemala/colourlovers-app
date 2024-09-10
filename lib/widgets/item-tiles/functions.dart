import 'package:fast_immutable_collections/fast_immutable_collections.dart';

IList<T> mapToTileViewState<T, U>(List<U> items, T Function(U) mapper) {
  return items.map(mapper).toIList();
}
