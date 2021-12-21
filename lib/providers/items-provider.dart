import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemsState<ItemType> extends Equatable {
  final List<ItemType> items;
  final bool isLoading;

  const ItemsState({
    required this.items,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [
        items,
        isLoading,
      ];

  ItemsState<ItemType> copyWith({
    List<ItemType>? items,
    bool? isLoading,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ItemsProvider<ItemType> extends StateNotifier<ItemsState<ItemType>> {
  final Future<List<ItemType>?> Function(ClClient client, int numResults, int resultOffset) callback;

  final _client = ClClient();
  int _page = 0;

  ItemsProvider(this.callback)
      : super(
          ItemsState(
            items: <ItemType>[],
            isLoading: false,
          ),
        ) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);

    const numResults = 20;
    final items = await callback(
          _client,
          numResults,
          _page * numResults,
        ) ??
        [];
    state = state.copyWith(
      items: [
        ...state.items,
        ...items,
      ],
      isLoading: false,
    );
  }

  Future<void> loadMore() async {
    _page++;
    _load();
  }
}
