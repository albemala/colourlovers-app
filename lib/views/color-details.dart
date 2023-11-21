import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/related-items.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/views/palette-details.dart';
import 'package:colourlovers_app/views/pattern-details.dart';
import 'package:colourlovers_app/views/related-colors.dart';
import 'package:colourlovers_app/views/related-palettes.dart';
import 'package:colourlovers_app/views/related-patterns.dart';
import 'package:colourlovers_app/views/share-color.dart';
import 'package:colourlovers_app/views/user-details.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/color-value.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
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
class ColorRgbViewModel {
  final double red;
  final double green;
  final double blue;

  const ColorRgbViewModel({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory ColorRgbViewModel.empty() {
    return const ColorRgbViewModel(
      red: 0,
      green: 0,
      blue: 0,
    );
  }

  factory ColorRgbViewModel.fromColourloverRgb(Rgb rgb) {
    return ColorRgbViewModel(
      red: rgb.red?.toDouble() ?? 0,
      green: rgb.green?.toDouble() ?? 0,
      blue: rgb.blue?.toDouble() ?? 0,
    );
  }
}

@immutable
class ColorHsvViewModel {
  final double hue;
  final double saturation;
  final double value;

  const ColorHsvViewModel({
    required this.hue,
    required this.saturation,
    required this.value,
  });

  factory ColorHsvViewModel.empty() {
    return const ColorHsvViewModel(
      hue: 0,
      saturation: 0,
      value: 0,
    );
  }

  factory ColorHsvViewModel.fromColourloverHsv(Hsv hsv) {
    return ColorHsvViewModel(
      hue: hsv.hue?.toDouble() ?? 0,
      saturation: hsv.saturation?.toDouble() ?? 0,
      value: hsv.value?.toDouble() ?? 0,
    );
  }
}

@immutable
class ColorDetailsViewModel {
  final bool isLoading;
  final String title;
  final String hex;
  final ColorRgbViewModel rgb;
  final ColorHsvViewModel hsv;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewModel user;
  final List<ColorTileViewModel> relatedColors;
  final List<PaletteTileViewModel> relatedPalettes;
  final List<PatternTileViewModel> relatedPatterns;

  const ColorDetailsViewModel({
    required this.isLoading,
    required this.title,
    required this.hex,
    required this.rgb,
    required this.hsv,
    required this.numViews,
    required this.numVotes,
    required this.rank,
    required this.user,
    required this.relatedColors,
    required this.relatedPalettes,
    required this.relatedPatterns,
  });

  factory ColorDetailsViewModel.empty() {
    return ColorDetailsViewModel(
      isLoading: true,
      title: '',
      hex: '',
      rgb: ColorRgbViewModel.empty(),
      hsv: ColorHsvViewModel.empty(),
      numViews: '',
      numVotes: '',
      rank: '',
      user: UserTileViewModel.empty(),
      relatedColors: const [],
      relatedPalettes: const [],
      relatedPatterns: const [],
    );
  }
}

class ColorDetailsViewBloc extends Cubit<ColorDetailsViewModel> {
  factory ColorDetailsViewBloc.fromContext(
    BuildContext context, {
    required ColourloversColor color,
  }) {
    return ColorDetailsViewBloc(
      color,
      ColourloversApiClient(),
    );
  }

  final ColourloversColor _color;
  final ColourloversApiClient _client;
  ColourloversLover? _user;
  List<ColourloversColor> _relatedColors = [];
  List<ColourloversPalette> _relatedPalettes = [];
  List<ColourloversPattern> _relatedPatterns = [];

  ColorDetailsViewBloc(
    this._color,
    this._client,
  ) : super(
          ColorDetailsViewModel.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    _user = _color.userName != null
        ? await fetchUser(_client, _color.userName!)
        : null;
    _relatedColors = _color.hsv != null
        ? await fetchRelatedColorsPreview(_client, _color.hsv!)
        : <ColourloversColor>[];
    _relatedPalettes = _color.hex != null
        ? await fetchRelatedPalettesPreview(_client, [_color.hex!])
        : <ColourloversPalette>[];
    _relatedPatterns = _color.hex != null
        ? await fetchRelatedPatternsPreview(_client, [_color.hex!])
        : <ColourloversPattern>[];

    _updateState();
  }

  void _updateState() {
    emit(
      ColorDetailsViewModel(
        isLoading: false,
        title: _color.title ?? '',
        hex: _color.hex ?? '',
        rgb: _color.rgb != null
            ? ColorRgbViewModel.fromColourloverRgb(_color.rgb!)
            : ColorRgbViewModel.empty(),
        hsv: _color.hsv != null
            ? ColorHsvViewModel.fromColourloverHsv(_color.hsv!)
            : ColorHsvViewModel.empty(),
        numViews: (_color.numViews ?? 0).toString(),
        numVotes: (_color.numVotes ?? 0).toString(),
        rank: (_color.rank ?? 0).toString(),
        user: _user != null
            ? UserTileViewModel.fromColourloverUser(_user!)
            : UserTileViewModel.empty(),
        relatedColors: _relatedColors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        relatedPalettes: _relatedPalettes //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        relatedPatterns: _relatedPatterns //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
      ),
    );
  }

  void showShareColorView(BuildContext context) {
    openRoute(context, ShareColorViewBuilder(color: _color));
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewModel viewModel,
  ) {
    final index = state.relatedColors.indexOf(viewModel);
    openRoute(
      context,
      ColorDetailsViewBuilder(color: _relatedColors[index]),
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

  void showRelatedColorsView(BuildContext context) {
    if (_color.hsv == null) return;
    openRoute(
      context,
      RelatedColorsViewBuilder(hsv: _color.hsv!),
    );
  }

  void showRelatedPalettesView(BuildContext context) {
    if (_color.hex == null) return;
    openRoute(
      context,
      RelatedPalettesViewBuilder(hex: [_color.hex!]),
    );
  }

  void showRelatedPatternsView(BuildContext context) {
    if (_color.hex == null) return;
    openRoute(
      context,
      RelatedPatternsViewBuilder(hex: [_color.hex!]),
    );
  }
}

class ColorDetailsViewBuilder extends StatelessWidget {
  final ColourloversColor color;

  const ColorDetailsViewBuilder({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ColorDetailsViewBloc.fromContext(
          context,
          color: color,
        );
      },
      child: BlocBuilder<ColorDetailsViewBloc, ColorDetailsViewModel>(
        builder: (context, viewModel) {
          return ColorDetailsView(
            viewModel: viewModel,
            bloc: context.read<ColorDetailsViewBloc>(),
          );
        },
      ),
    );
  }
}

class ColorDetailsView extends StatelessWidget {
  final ColorDetailsViewModel viewModel;
  final ColorDetailsViewBloc bloc;

  const ColorDetailsView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Color',
        actions: [
          ShareItemButton(
            onPressed: () {
              bloc.showShareColorView(context);
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
                  return const SizedBox(height: 32); // TODO try 48
                },
                children: [
                  HeaderView(
                    title: viewModel.title,
                    item: ColorView(hex: viewModel.hex),
                    onItemTap: () {
                      bloc.showShareColorView(context);
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
                  _ColorValuesView(
                    rgb: viewModel.rgb,
                    hsv: viewModel.hsv,
                  ),
                  CreatedByView(
                    user: viewModel.user,
                    onUserTap: () {
                      bloc.showUserDetailsView(context);
                    },
                  ),
                  if (viewModel.relatedColors.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Related colors',
                      items: viewModel.relatedColors,
                      itemBuilder: (viewModel) {
                        return ColorTileView(
                          viewModel: viewModel,
                          onTap: () {
                            bloc.showColorDetailsView(context, viewModel);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        bloc.showRelatedColorsView(context);
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
                    itemName: 'color',
                    itemUrl: '$colourLoversUrl/color/${viewModel.hex}',
                  ),
                ],
              ),
            ),
    );
  }
}

class _ColorValuesView extends StatelessWidget {
  final ColorRgbViewModel rgb;
  final ColorHsvViewModel hsv;

  const _ColorValuesView({
    required this.rgb,
    required this.hsv,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      separatorBuilder: () {
        return const SizedBox(height: 16);
      },
      children: [
        const H2TextView('Values'),
        Column(
          children: [
            ColorValueView(
              label: 'R',
              value: rgb.red,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFFFF0000)],
            ),
            ColorValueView(
              label: 'G',
              value: rgb.green,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFF00FF00)],
            ),
            ColorValueView(
              label: 'B',
              value: rgb.blue,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFF0000FF)],
            ),
          ],
        ),
        Column(
          children: [
            ColorValueView(
              label: 'H',
              value: hsv.hue,
              minValue: 0,
              maxValue: 360,
              trackColors: const [
                Color(0xFFFF0000),
                Color(0xFFFFFF00),
                Color(0xFF00FF00),
                Color(0xFF00FFFF),
                Color(0xFF0000FF),
                Color(0xFFFF00FF),
                Color(0xFFFF0000),
              ],
            ),
            ColorValueView(
              label: 'S',
              value: hsv.saturation,
              minValue: 0,
              maxValue: 100,
              trackColors: [
                const Color(0xFF000000),
                HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor()
              ],
            ),
            ColorValueView(
              label: 'V',
              value: hsv.value,
              minValue: 0,
              maxValue: 100,
              trackColors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
            ),
          ],
        ),
      ],
    );
  }
}
