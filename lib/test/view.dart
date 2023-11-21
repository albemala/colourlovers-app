import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/common/widgets/app-top-bar.dart';
import 'package:colourlovers_app/item-details/views/item-details-test.dart';
import 'package:colourlovers_app/items/views/items-test.dart';
import 'package:colourlovers_app/share-items/views/share-items-test.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestViewBloc extends Cubit<void> {
  factory TestViewBloc.fromContext(BuildContext context) {
    return TestViewBloc();
  }

  TestViewBloc() : super(null);

  void showItemsTestView(BuildContext context) {
    openRoute(context, const ItemsTestView());
  }

  void showItemDetailsTestView(BuildContext context) {
    openRoute(context, const ItemDetailsTestViewBuilder());
  }

  void showShareItemsTestView(BuildContext context) {
    openRoute(context, const ShareItemsTestViewBuilder());
  }
}

class TestViewBuilder extends StatelessWidget {
  const TestViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: TestViewBloc.fromContext,
      child: BlocBuilder<TestViewBloc, void>(
        builder: (context, viewModel) {
          return TestView(
            // viewModel: viewModel,
            bloc: context.read<TestViewBloc>(),
          );
        },
      ),
    );
  }
}

class TestView extends StatelessWidget {
  // final void viewModel;
  final TestViewBloc bloc;

  const TestView({
    super.key,
    // required this.viewModel,
    required this.bloc,
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
                  bloc.showItemsTestView(context);
                },
                child: const Text('Items'),
              ),
              OutlinedButton(
                onPressed: () {
                  bloc.showItemDetailsTestView(context);
                },
                child: const Text('Item details'),
              ),
              OutlinedButton(
                onPressed: () {
                  bloc.showShareItemsTestView(context);
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
