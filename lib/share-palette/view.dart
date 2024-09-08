import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/clipboard.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class SharePaletteViewModel {
  final List<String> colors;
  final List<double> colorWidths;
  final String imageUrl;

  const SharePaletteViewModel({
    required this.colors,
    required this.colorWidths,
    required this.imageUrl,
  });

  factory SharePaletteViewModel.initialState() {
    return const SharePaletteViewModel(
      colors: [],
      colorWidths: [],
      imageUrl: '',
    );
  }

  factory SharePaletteViewModel.fromColourloversPalette(
    ColourloversPalette palette,
  ) {
    return SharePaletteViewModel(
      colors: palette.colors ?? [],
      colorWidths: palette.colorWidths ?? [],
      imageUrl: httpToHttps(palette.imageUrl ?? ''),
    );
  }
}

class SharePaletteBloc extends Cubit<SharePaletteViewModel> {
  factory SharePaletteBloc.fromContext(
    BuildContext context, {
    required ColourloversPalette palette,
  }) {
    return SharePaletteBloc(
      palette,
    );
  }

  final ColourloversPalette _palette;

  SharePaletteBloc(
    this._palette,
  ) : super(
          SharePaletteViewModel.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {
    emit(
      SharePaletteViewModel.fromColourloversPalette(_palette),
    );
  }

  Future<void> copyColorToClipboard(BuildContext context, String color) async {
    await copyToClipboard(color);
    showSnackBar(context, createCopiedToClipboardSnackBar(color));
  }

  void shareImage() {
    openUrl(state.imageUrl);
  }
}

class SharePaletteViewBuilder extends StatelessWidget {
  final ColourloversPalette palette;

  const SharePaletteViewBuilder({
    super.key,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SharePaletteBloc(palette),
      child: BlocBuilder<SharePaletteBloc, SharePaletteViewModel>(
        builder: (context, viewModel) {
          return SharePaletteView(
            viewModel: viewModel,
            bloc: context.read<SharePaletteBloc>(),
          );
        },
      ),
    );
  }
}

class SharePaletteView extends StatelessWidget {
  final SharePaletteViewModel viewModel;
  final SharePaletteBloc bloc;

  const SharePaletteView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Share Palette',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 96,
              child: PaletteView(
                hexs: viewModel.colors,
                widths: viewModel.colorWidths,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
