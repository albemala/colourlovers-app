import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/functions/clipboard.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ShareColorViewModel {
  final String hex;
  final String imageUrl;

  const ShareColorViewModel({
    required this.hex,
    required this.imageUrl,
  });

  factory ShareColorViewModel.initialState() {
    return const ShareColorViewModel(
      hex: '',
      imageUrl: '',
    );
  }

  factory ShareColorViewModel.fromColourloversColor(ColourloversColor color) {
    return ShareColorViewModel(
      hex: color.hex ?? '',
      imageUrl: httpToHttps(color.imageUrl ?? ''),
    );
  }
}

class ShareColorBloc extends Cubit<ShareColorViewModel> {
  factory ShareColorBloc.fromContext(
    BuildContext context, {
    required ColourloversColor color,
  }) {
    return ShareColorBloc(
      color,
    );
  }

  final ColourloversColor _color;
  ShareColorBloc(
    this._color,
  ) : super(
          ShareColorViewModel.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {
    emit(
      ShareColorViewModel.fromColourloversColor(_color),
    );
  }

  Future<void> copyHexToClipboard(BuildContext context) async {
    await copyToClipboard(state.hex);
    showSnackBar(context, createCopiedToClipboardSnackBar(state.hex));
  }

  void shareImage() {
    openUrl(state.imageUrl);
  }
}

class ShareColorViewBuilder extends StatelessWidget {
  final ColourloversColor color;

  const ShareColorViewBuilder({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShareColorBloc.fromContext(
        context,
        color: color,
      ),
      child: BlocBuilder<ShareColorBloc, ShareColorViewModel>(
        builder: (context, viewModel) {
          return ShareColorView(
            viewModel: viewModel,
            bloc: context.read<ShareColorBloc>(),
          );
        },
      ),
    );
  }
}

class ShareColorView extends StatelessWidget {
  final ShareColorViewModel viewModel;
  final ShareColorBloc bloc;

  const ShareColorView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Share Color',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 96,
              child: ColorView(hex: viewModel.hex),
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
                      SeparatedRow(
                        separatorBuilder: () {
                          return const SizedBox(width: 8);
                        },
                        children: [
                          SizedBox(
                            // width: 120,
                            child: H1TextView('#${viewModel.hex}'),
                          ),
                          TextButton(
                            onPressed: () {
                              bloc.copyHexToClipboard(context);
                            },
                            child: const Text('Copy'),
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
