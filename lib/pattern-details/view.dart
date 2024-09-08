import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/colors.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/related-palettes/view.dart';
import 'package:colourlovers_app/related-patterns/view.dart';
import 'package:colourlovers_app/share-pattern/view.dart';
import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-details.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/label-value.dart';
import 'package:colourlovers_app/widgets/related-items-preview.dart';
import 'package:colourlovers_app/widgets/share-item-button.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class PatternDetailsViewModel {
  final bool isLoading;
  final String id;
  final String title;
  final List<String> colors;
  final List<ColorTileViewModel> colorViewModels;
  final String imageUrl;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewModel user;
  final List<PaletteTileViewModel> relatedPalettes;
  final List<PatternTileViewModel> relatedPatterns;

  const PatternDetailsViewModel({
    required this.isLoading,
    required this.id,
    required this.title,
    required this.colors,
    required this.colorViewModels,
    required this.imageUrl,
    required this.numViews,
    required this.numVotes,
    required this.rank,
    required this.user,
    required this.relatedPalettes,
    required this.relatedPatterns,
  });

  factory PatternDetailsViewModel.empty() {
    return PatternDetailsViewModel(
      isLoading: true,
      id: '',
      title: '',
      colors: const [],
      colorViewModels: const [],
      imageUrl: '',
      numViews: '',
      numVotes: '',
      rank: '',
      user: UserTileViewModel.empty(),
      relatedPalettes: const [],
      relatedPatterns: const [],
    );
  }
}

class PatternDetailsViewBloc extends Cubit<PatternDetailsViewModel> {
  factory PatternDetailsViewBloc.fromContext(
    BuildContext context, {
    required ColourloversPattern pattern,
  }) {
    return PatternDetailsViewBloc(
      pattern,
      ColourloversApiClient(),
    );
  }

  final ColourloversPattern _pattern;
  final ColourloversApiClient _client;
  ColourloversLover? _user;
  List<ColourloversColor> _colors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  PatternDetailsViewBloc(
    this._pattern,
    this._client,
  ) : super(
          PatternDetailsViewModel.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    _user = _pattern.userName != null
        ? await fetchUser(_client, _pattern.userName!)
        : null;
    _colors = _pattern.colors != null
        ? await fetchColors(_client, _pattern.colors!)
        : <ColourloversColor>[];
    _relatedPalettes = _pattern.colors != null
        ? await fetchRelatedPalettesPreview(_client, _pattern.colors!)
        : <ColourloversPalette>[];
    _relatedPatterns = _pattern.colors != null
        ? await fetchRelatedPatternsPreview(_client, _pattern.colors!)
        : <ColourloversPattern>[];

    _updateState();
  }

  void _updateState() {
    emit(
      PatternDetailsViewModel(
        isLoading: false,
        id: (_pattern.id ?? 0).toString(),
        title: _pattern.title ?? '',
        colors: _pattern.colors ?? [],
        colorViewModels: _colors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        imageUrl: _pattern.imageUrl ?? '',
        numViews: (_pattern.numViews ?? 0).toString(),
        numVotes: (_pattern.numVotes ?? 0).toString(),
        rank: (_pattern.rank ?? 0).toString(),
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

  void showSharePatternView(BuildContext context) {
    openRoute(context, SharePatternViewBuilder(pattern: _pattern));
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
    if (_pattern.colors == null) return;
    openRoute(
      context,
      RelatedPalettesViewBuilder(hex: _pattern.colors!),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    if (_pattern.colors == null) return;
    openRoute(
      context,
      RelatedPatternsViewBuilder(hex: _pattern.colors!),
    );
  }
}

class PatternDetailsViewBuilder extends StatelessWidget {
  final ColourloversPattern pattern;

  const PatternDetailsViewBuilder({
    super.key,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatternDetailsViewBloc.fromContext(
        context,
        pattern: pattern,
      ),
      child: BlocBuilder<PatternDetailsViewBloc, PatternDetailsViewModel>(
        builder: (context, viewModel) {
          return PatternDetailsView(
            viewModel: viewModel,
            bloc: context.read<PatternDetailsViewBloc>(),
          );
        },
      ),
    );
  }
}

class PatternDetailsView extends StatelessWidget {
  final PatternDetailsViewModel viewModel;
  final PatternDetailsViewBloc bloc;

  const PatternDetailsView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Pattern',
        actions: [
          ShareItemButton(
            onPressed: () {
              bloc.showSharePatternView(context);
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
                    item: PatternView(imageUrl: viewModel.imageUrl),
                    onItemTap: () {
                      bloc.showSharePatternView(context);
                    },
                  ),
                  Column(
                    children: [
                      LabelValueView(
                        label: 'Views',
                        value: viewModel.numViews,
                      ),
                      LabelValueView(
                        label: 'Votes',
                        value: viewModel.numVotes,
                      ),
                      LabelValueView(
                        label: 'Rank',
                        value: viewModel.rank,
                      ),
                    ],
                  ),
                  // StatsView(
                  //   stats: [
                  //     StatsItemViewModel(
                  //       label: 'Views',
                  //       value: viewModel.numViews,
                  //     ),
                  //     StatsItemViewModel(
                  //       label: 'Votes',
                  //       value: viewModel.numVotes,
                  //     ),
                  //     StatsItemViewModel(
                  //       label: 'Rank',
                  //       value: viewModel.rank,
                  //     ),
                  //   ],
                  // ),
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
                    itemName: 'pattern',
                    itemUrl: '$colourLoversUrl/pattern/${viewModel.id}',
                  ),
                ],
              ),
            ),
    );
  }
}
