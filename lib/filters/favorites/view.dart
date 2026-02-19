import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/filters/favorites/view-controller.dart';
import 'package:colourlovers_app/filters/favorites/view-state.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesFiltersViewCreator extends StatelessWidget {
  const FavoritesFiltersViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesFiltersViewController>(
      create: FavoritesFiltersViewController.fromContext,
      child:
          BlocBuilder<
            FavoritesFiltersViewController,
            FavoritesFiltersViewState
          >(
            builder: (context, state) {
              return FavoritesFiltersView(
                state: state,
                controller: context.read<FavoritesFiltersViewController>(),
              );
            },
          ),
    );
  }
}

class FavoritesFiltersView extends StatelessWidget {
  final FavoritesFiltersViewState state;
  final FavoritesFiltersViewController controller;

  const FavoritesFiltersView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Favorites Filters'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 32,
                  children: [
                    _ShowView(state: state, controller: controller),
                    _SortView(state: state, controller: controller),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  OutlinedButton(
                    onPressed: controller.resetFilters,
                    child: const Text('Reset filters'),
                  ),
                  FilledButton(
                    onPressed: () {
                      controller.applyFilters();
                      closeCurrentView<void>(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowView extends StatelessWidget {
  final FavoritesFiltersViewState state;
  final FavoritesFiltersViewController controller;

  const _ShowView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Show'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 8,
            children: FavoriteItemTypeFilter.values.map((type) {
              return ChoiceChip(
                label: Text(getFavoriteItemTypeFilterName(type)),
                selected: state.typeFilter == type,
                onSelected: (value) {
                  controller.setTypeFilter(type);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SortView extends StatelessWidget {
  final FavoritesFiltersViewState state;
  final FavoritesFiltersViewController controller;

  const _SortView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Sort by'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 8,
            children: FavoriteSortBy.values.map((sortBy) {
              return ChoiceChip(
                label: Text(getFavoriteSortByName(sortBy)),
                selected: state.sortBy == sortBy,
                onSelected: (value) {
                  controller.setSortBy(sortBy);
                },
              );
            }).toList(),
          ),
        ),
        Wrap(
          spacing: 8,
          children: FavoriteSortOrder.values.map((sortOrder) {
            return ChoiceChip(
              label: Text(getFavoriteSortOrderName(sortOrder)),
              selected: state.sortOrder == sortOrder,
              onSelected: (value) {
                controller.setSortOrder(sortOrder);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
