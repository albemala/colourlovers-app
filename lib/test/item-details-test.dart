import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ItemDetailsViewModel {
  final ColourloversColor? color;
  final ColourloversPalette? palette;
  final ColourloversPattern? pattern;
  final ColourloversLover? user;

  const ItemDetailsViewModel({
    this.color,
    this.palette,
    this.pattern,
    this.user,
  });

  factory ItemDetailsViewModel.initialState() {
    return const ItemDetailsViewModel();
  }
}

class ItemDetailsBloc extends Cubit<ItemDetailsViewModel> {
  factory ItemDetailsBloc.fromContext(BuildContext context) {
    return ItemDetailsBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;

  ItemDetailsBloc(
    this._client,
  ) : super(
          ItemDetailsViewModel.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {
    final color = await _client.getColor(hex: '1693A5');
    final palette = await _client.getPalette(id: 629637);
    final pattern = await _client.getPattern(id: 1101098);
    final user = await _client.getLover(userName: 'sunmeadow');

    emit(
      ItemDetailsViewModel(
        color: color,
        palette: palette,
        pattern: pattern,
        user: user,
      ),
    );
  }
}

class ItemDetailsTestViewBuilder extends StatelessWidget {
  const ItemDetailsTestViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ItemDetailsBloc.fromContext,
      child: BlocBuilder<ItemDetailsBloc, ItemDetailsViewModel>(
        builder: (context, viewModel) {
          return ItemDetailsTestView(
            viewModel: viewModel,
            bloc: context.read<ItemDetailsBloc>(),
          );
        },
      ),
    );
  }
}

class ItemDetailsTestView extends StatelessWidget {
  final ItemDetailsViewModel viewModel;
  final ItemDetailsBloc bloc;

  const ItemDetailsTestView({
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
              ? ColorDetailsViewBuilder(color: viewModel.color!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: viewModel.palette != null
              ? PaletteDetailsViewBuilder(palette: viewModel.palette!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: viewModel.pattern != null
              ? PatternDetailsViewBuilder(pattern: viewModel.pattern!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: viewModel.user != null
              ? UserDetailsViewBuilder(user: viewModel.user!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
