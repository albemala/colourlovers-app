import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share-color/view.dart';
import 'package:colourlovers_app/share-palette/view.dart';
import 'package:colourlovers_app/share-pattern/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ShareItemsViewModel {
  final ColourloversColor? color;
  final ColourloversPalette? palette;
  final ColourloversPattern? pattern;
  final ColourloversLover? user;

  const ShareItemsViewModel({
    this.color,
    this.palette,
    this.pattern,
    this.user,
  });

  factory ShareItemsViewModel.initialState() {
    return const ShareItemsViewModel();
  }
}

class ShareItemsBloc extends Cubit<ShareItemsViewModel> {
  factory ShareItemsBloc.fromContext(BuildContext context) {
    return ShareItemsBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;

  ShareItemsBloc(
    this._client,
  ) : super(
          ShareItemsViewModel.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {
    final color = await _client.getColor(hex: '1693A5');
    final palette = await _client.getPalette(id: 629637);
    final pattern = await _client.getPattern(id: 1101098);
    final user = await _client.getLover(userName: 'sunmeadow');

    emit(
      ShareItemsViewModel(
        color: color,
        palette: palette,
        pattern: pattern,
        user: user,
      ),
    );
  }
}

class ShareItemsTestViewBuilder extends StatelessWidget {
  const ShareItemsTestViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ShareItemsBloc.fromContext,
      child: BlocBuilder<ShareItemsBloc, ShareItemsViewModel>(
        builder: (context, viewModel) {
          return ShareItemsTestView(
            viewModel: viewModel,
            bloc: context.read<ShareItemsBloc>(),
          );
        },
      ),
    );
  }
}

class ShareItemsTestView extends StatelessWidget {
  final ShareItemsViewModel viewModel;
  final ShareItemsBloc bloc;

  const ShareItemsTestView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: viewModel.color != null
              ? ShareColorViewBuilder(color: viewModel.color!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: viewModel.palette != null
              ? SharePaletteViewBuilder(palette: viewModel.palette!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: viewModel.pattern != null
              ? SharePatternViewBuilder(pattern: viewModel.pattern!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
