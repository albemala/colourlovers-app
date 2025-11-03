import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/filters/user/view-controller.dart';
import 'package:colourlovers_app/filters/user/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/text-field.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFiltersViewCreator extends StatelessWidget {
  const UserFiltersViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserFiltersViewController>(
      create: (context) {
        return UserFiltersViewController.fromContext(context);
      },
      child: BlocBuilder<UserFiltersViewController, UserFiltersViewState>(
        builder: (context, state) {
          return UserFiltersView(
            state: state,
            controller: context.read<UserFiltersViewController>(),
          );
        },
      ),
    );
  }
}

class UserFiltersView extends StatelessWidget {
  final UserFiltersViewState state;
  final UserFiltersViewController controller;

  const UserFiltersView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Filter Users'),
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
                    if (state.showCriteria == ContentShowCriteria.all)
                      _SortByView(state: state, controller: controller),
                    // It looks like there is no API parameter to filter by user name
                    // So I'm going to leave it this here for now
                    // _UserNameView(state: state, controller: controller),
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
  final UserFiltersViewState state;
  final UserFiltersViewController controller;

  const _ShowView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Show'),
        Row(
          spacing: 8,
          children: ContentShowCriteria.values.map((showCriteria) {
            return ChoiceChip(
              label: Text(getContentShowCriteriaName(showCriteria)),
              selected: state.showCriteria == showCriteria,
              onSelected: (bool value) {
                controller.setShowCriteria(showCriteria);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SortByView extends StatelessWidget {
  final UserFiltersViewState state;
  final UserFiltersViewController controller;

  const _SortByView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Sort By'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: ColourloversRequestOrderBy.values.map((sortBy) {
              return ChoiceChip(
                label: Text(getColourloversRequestOrderByName(sortBy)),
                selected: state.sortBy == sortBy,
                onSelected: (bool value) {
                  controller.setSortBy(sortBy);
                },
              );
            }).toList(),
          ),
        ),
        Row(
          spacing: 8,
          children: ColourloversRequestSortBy.values.map((sortOrder) {
            return ChoiceChip(
              label: Text(getColourloversRequestSortByName(sortOrder)),
              selected: state.sortOrder == sortOrder,
              onSelected: (bool value) {
                controller.setOrder(sortOrder);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _UserNameView extends StatelessWidget {
  final UserFiltersViewState state;
  final UserFiltersViewController controller;

  const _UserNameView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('User name'),
        TextFieldView(
          text: state.userName,
          onTextChanged: controller.setUserName,
        ),
      ],
    );
  }
}
