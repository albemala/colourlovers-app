import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/test/item-details-test.dart';
import 'package:colourlovers_app/test/items-test.dart';
import 'package:colourlovers_app/test/share-items-test.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestViewController extends Cubit<void> {
  factory TestViewController.fromContext(BuildContext context) {
    return TestViewController();
  }

  TestViewController() : super(null);

  void showItemsTestView(BuildContext context) {
    openScreen(context, const ItemsTestView());
  }

  void showItemDetailsTestView(BuildContext context) {
    openScreen(context, const ItemDetailsTestViewCreator());
  }

  void showShareItemsTestView(BuildContext context) {
    openScreen(context, const ShareItemsTestViewCreator());
  }
}

class TestViewCreator extends StatelessWidget {
  const TestViewCreator({
    super.key,
  });

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
      appBar: AppTopBarView(
        context,
        title: 'Test',
        actions: const [
          // ThemeModeToggleButton(),
          // TODO add padding to the left
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SeparatedColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            separatorBuilder: () {
              return const SizedBox(height: 8);
            },
            children: [
              OutlinedButton(
                onPressed: () {
                  controller.showItemsTestView(context);
                },
                child: const Text('Items'),
              ),
              OutlinedButton(
                onPressed: () {
                  controller.showItemDetailsTestView(context);
                },
                child: const Text('Item details'),
              ),
              OutlinedButton(
                onPressed: () {
                  controller.showShareItemsTestView(context);
                },
                child: const Text('Share items'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
