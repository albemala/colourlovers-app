import 'package:colourlovers_app/test/view-controller.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestViewCreator extends StatelessWidget {
  const TestViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: TestViewController.fromContext,
      child: BlocBuilder<TestViewController, void>(
        builder: (context, state) {
          return TestView(
            // state: state,
            controller: context.read<TestViewController>(),
          );
        },
      ),
    );
  }
}

class TestView extends StatelessWidget {
  // final void state;
  final TestViewController controller;

  const TestView({
    super.key,
    // required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Test'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32,
          children: [
            Text('Screens', style: Theme.of(context).textTheme.titleMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () {
                    controller.showItemsTestView(context);
                  },
                  child: const Text('Items'),
                ),
                FilledButton(
                  onPressed: () {
                    controller.showItemDetailsTestView(context);
                  },
                  child: const Text('Item details'),
                ),
                FilledButton(
                  onPressed: () {
                    controller.showShareItemsTestView(context);
                  },
                  child: const Text('Share items'),
                ),
                FilledButton(
                  onPressed: () {
                    controller.showFiltersTestView(context);
                  },
                  child: const Text('Filters'),
                ),
              ],
            ),
            Text('Favorites', style: Theme.of(context).textTheme.titleMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () {
                    controller.removeAllFavorites(context);
                  },
                  child: const Text('Remove all favorites'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
