import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class ItemListViewState<ItemType> extends Equatable {
  final bool isLoading;
  final IList<ItemType> items;
  final bool hasMoreItems;

  const ItemListViewState({
    required this.isLoading,
    required this.items,
    required this.hasMoreItems,
  });

  factory ItemListViewState.initial() {
    return ItemListViewState<ItemType>(
      isLoading: false,
      items: const IList.empty(),
      hasMoreItems: true,
    );
  }

  @override
  List<Object> get props => [isLoading, items, hasMoreItems];

  ItemListViewState<ItemType> copyWith({
    bool? isLoading,
    IList<ItemType>? items,
    bool? hasMoreItems,
  }) {
    return ItemListViewState<ItemType>(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
    );
  }
}
