import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/colors.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related-palettes/view.dart';
import 'package:colourlovers_app/related-patterns/view.dart';
import 'package:colourlovers_app/share-palette/view.dart';
import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-details.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/related-items-preview.dart';
import 'package:colourlovers_app/widgets/share-item-button.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class PaletteDetailsViewModel {
  final bool isLoading;
  final String id;
  final String title;
  final List<String> colors;
  final List<double> colorWidths;
  final List<ColorTileViewModel> colorViewModels;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewModel user;
  final List<PaletteTileViewModel> relatedPalettes;
  final List<PatternTileViewModel> relatedPatterns;

  const PaletteDetailsViewModel({
    required this.isLoading,
    required this.id,
    required this.title,
    required this.colors,
    required this.colorWidths,
    required this.colorViewModels,
    required this.numViews,
    required this.numVotes,
    required this.rank,
    required this.user,
    required this.relatedPalettes,
    required this.relatedPatterns,
  });

  factory PaletteDetailsViewModel.empty() {
    return PaletteDetailsViewModel(
      isLoading: true,
      id: '',
      title: '',
      colors: const [],
      colorWidths: const [],
      colorViewModels: const [],
      numViews: '',
      numVotes: '',
      rank: '',
      user: UserTileViewModel.empty(),
      relatedPalettes: const [],
      relatedPatterns: const [],
    );
  }
}

class PaletteDetailsViewBloc extends Cubit<PaletteDetailsViewModel> {
  factory PaletteDetailsViewBloc.fromContext(
    BuildContext context, {
    required ColourloversPalette palette,
  }) {
    return PaletteDetailsViewBloc(
      palette,
      ColourloversApiClient(),
    );
  }

  final ColourloversPalette _palette;
  final ColourloversApiClient _client;
  ColourloversLover? _user;
  List<ColourloversColor> _colors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  PaletteDetailsViewBloc(
    this._palette,
    this._client,
  ) : super(
          PaletteDetailsViewModel.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    _user = _palette.userName != null
        ? await fetchUser(_client, _palette.userName!)
        : null;
    _colors = _palette.colors != null
        ? await fetchColors(_client, _palette.colors!)
        : <ColourloversColor>[];
    _relatedPalettes = _palette.colors != null
        ? await fetchRelatedPalettesPreview(_client, _palette.colors!)
        : <ColourloversPalette>[];
    _relatedPatterns = _palette.colors != null
        ? await fetchRelatedPatternsPreview(_client, _palette.colors!)
        : <ColourloversPattern>[];

    _updateState();
  }

  void _updateState() {
    emit(
      PaletteDetailsViewModel(
        isLoading: false,
        id: (_palette.id ?? 0).toString(),
        title: _palette.title ?? '',
        colors: _palette.colors ?? [],
        colorWidths: _palette.colorWidths ?? [],
        colorViewModels: _colors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        numViews: (_palette.numViews ?? 0).toString(),
        numVotes: (_palette.numVotes ?? 0).toString(),
        rank: (_palette.rank ?? 0).toString(),
        user: _user != null //
            ? UserTileViewModel.fromColourloverUser(_user!)
            : UserTileViewModel.empty(),
        relatedPalettes: _relatedPalettes //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        relatedPatterns: _relatedPatterns //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
      ),
    );
  }

  void showSharePaletteView(BuildContext context) {
    openRoute(context, SharePaletteViewBuilder(palette: _palette));
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewModel viewModel,
  ) {
    final index = state.colorViewModels.indexOf(viewModel);
    openRoute(
      context,
      ColorDetailsViewBuilder(color: _colors[index]),
    );
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewModel viewModel,
  ) {
    final index = state.relatedPalettes.indexOf(viewModel);
    openRoute(
      context,
      PaletteDetailsViewBuilder(palette: _relatedPalettes[index]),
    );
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewModel viewModel,
  ) {
    final index = state.relatedPatterns.indexOf(viewModel);
    openRoute(
      context,
      PatternDetailsViewBuilder(pattern: _relatedPatterns[index]),
    );
  }

  void showUserDetailsView(BuildContext context) {
    if (_user == null) return;
    openRoute(
      context,
      UserDetailsViewBuilder(user: _user!),
    );
  }

  void showRelatedPalettesView(BuildContext context) {
    if (_palette.colors == null) return;
    openRoute(
      context,
      RelatedPalettesViewBuilder(hex: _palette.colors!),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    if (_palette.colors == null) return;
    openRoute(
      context,
      RelatedPatternsViewBuilder(hex: _palette.colors!),
    );
  }
}

class PaletteDetailsViewBuilder extends StatelessWidget {
  final ColourloversPalette palette;

  const PaletteDetailsViewBuilder({
    super.key,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaletteDetailsViewBloc.fromContext(
        context,
        palette: palette,
      ),
      child: BlocBuilder<PaletteDetailsViewBloc, PaletteDetailsViewModel>(
        builder: (context, viewModel) {
          return PaletteDetailsView(
            viewModel: viewModel,
            bloc: context.read<PaletteDetailsViewBloc>(),
          );
        },
      ),
    );
  }
}

class PaletteDetailsView extends StatelessWidget {
  final PaletteDetailsViewModel viewModel;
  final PaletteDetailsViewBloc bloc;

  const PaletteDetailsView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Palette',
        actions: [
          ShareItemButton(
            onPressed: () {
              bloc.showSharePaletteView(context);
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SeparatedColumn(
                separatorBuilder: () {
                  return const SizedBox(height: 32);
                },
                children: [
                  HeaderView(
                    title: viewModel.title,
                    item: PaletteView(
                      hexs: viewModel.colors,
                      widths: viewModel.colorWidths,
                    ),
                    onItemTap: () {
                      bloc.showSharePaletteView(context);
                    },
                  ),
                  StatsView(
                    stats: [
                      StatsItemViewModel(
                        label: 'Views',
                        value: viewModel.numViews,
                      ),
                      StatsItemViewModel(
                        label: 'Votes',
                        value: viewModel.numVotes,
                      ),
                      StatsItemViewModel(
                        label: 'Rank',
                        value: viewModel.rank,
                      ),
                    ],
                  ),
                  ItemColorsView(
                    colorViewModels: viewModel.colorViewModels,
                    onColorTap: (viewModel) {
                      bloc.showColorDetailsView(context, viewModel);
                    },
                  ),
                  CreatedByView(
                    user: viewModel.user,
                    onUserTap: () {
                      bloc.showUserDetailsView(context);
                    },
                  ),
                  if (viewModel.relatedPalettes.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Related palettes',
                      items: viewModel.relatedPalettes,
                      itemBuilder: (viewModel) {
                        return PaletteTileView(
                          viewModel: viewModel,
                          onTap: () {
                            bloc.showPaletteDetailsView(context, viewModel);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        bloc.showRelatedPalettesView(context);
                      },
                    ),
                  if (viewModel.relatedPatterns.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Related patterns',
                      items: viewModel.relatedPatterns,
                      itemBuilder: (viewModel) {
                        return PatternTileView(
                          viewModel: viewModel,
                          onTap: () {
                            bloc.showPatternDetailsView(context, viewModel);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        bloc.showRelatedPatternsView(context);
                      },
                    ),
                  CreditsView(
                    itemName: 'palette',
                    itemUrl: '$colourLoversUrl/palette/${viewModel.id}',
                  ),
                ],
              ),
            ),
    );
  }
}
