import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/clipboard.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class SharePatternViewModel {
  final List<String> colors;
  final String imageUrl;
  final String templateUrl;

  const SharePatternViewModel({
    required this.colors,
    required this.imageUrl,
    required this.templateUrl,
  });

  factory SharePatternViewModel.initialState() {
    return const SharePatternViewModel(
      colors: [],
      imageUrl: '',
      templateUrl: '',
    );
  }

  factory SharePatternViewModel.fromColourloversPattern(
    ColourloversPattern pattern,
  ) {
    return SharePatternViewModel(
      colors: pattern.colors ?? [],
      imageUrl: httpToHttps(pattern.imageUrl ?? ''),
      templateUrl: httpToHttps(pattern.template?.url ?? ''),
    );
  }
}

class SharePatternBloc extends Cubit<SharePatternViewModel> {
  factory SharePatternBloc.fromContext(
    BuildContext context, {
    required ColourloversPattern pattern,
  }) {
    return SharePatternBloc(
      pattern,
    );
  }

  final ColourloversPattern _pattern;

  SharePatternBloc(
    this._pattern,
  ) : super(
          SharePatternViewModel.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {
    emit(
      SharePatternViewModel.fromColourloversPattern(_pattern),
    );
  }

  Future<void> copyColorToClipboard(BuildContext context, String color) async {
    await copyToClipboard(color);
    showSnackBar(context, createCopiedToClipboardSnackBar(color));
  }

  void shareImage() {
    openUrl(state.imageUrl);
  }

  void shareTemplate() {
    openUrl(state.templateUrl);
  }
}

class SharePatternViewBuilder extends StatelessWidget {
  final ColourloversPattern pattern;

  const SharePatternViewBuilder({
    super.key,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SharePatternBloc(pattern),
      child: BlocBuilder<SharePatternBloc, SharePatternViewModel>(
        builder: (context, viewModel) {
          return SharePatternView(
            viewModel: viewModel,
            bloc: context.read<SharePatternBloc>(),
          );
        },
      ),
    );
  }
}

class SharePatternView extends StatelessWidget {
  final SharePatternViewModel viewModel;
  final SharePatternBloc bloc;

  const SharePatternView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Share Pattern',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 96,
              child: PatternView(
                imageUrl: viewModel.imageUrl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SeparatedColumn(
                separatorBuilder: () {
                  return const SizedBox(height: 32);
                },
                children: [
                  SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    separatorBuilder: () {
                      return const SizedBox(height: 16);
                    },
                    children: [
                      const H2TextView('Values'),
                      SeparatedColumn(
                        separatorBuilder: () {
                          return const SizedBox(height: 8);
                        },
                        children: viewModel.colors.map((color) {
                          return SeparatedRow(
                            separatorBuilder: () {
                              return const SizedBox(width: 8);
                            },
                            children: [
                              SizedBox(
                                width: 120,
                                child: H1TextView('#$color'),
                              ),
                              TextButton(
                                onPressed: () {
                                  bloc.copyColorToClipboard(context, color);
                                },
                                child: const Text('Copy'),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    separatorBuilder: () {
                      return const SizedBox(height: 16);
                    },
                    children: [
                      const H2TextView('Image'),
                      SeparatedRow(
                        separatorBuilder: () {
                          return const SizedBox(width: 8);
                        },
                        children: [
                          Flexible(
                            child: Image.network(viewModel.imageUrl),
                          ),
                          TextButton(
                            onPressed: bloc.shareImage,
                            child: const Text('Share'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    separatorBuilder: () {
                      return const SizedBox(height: 16);
                    },
                    children: [
                      const H2TextView('Template'),
                      LinkView(
                        text: 'This pattern template on COLOURlovers.com',
                        onTap: bloc.shareTemplate,
                      ),
                    ],
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
