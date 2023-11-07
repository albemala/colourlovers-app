import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/related-items.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/color-value.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:colourlovers_app/widgets/stats.dart';
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

  ColorDetailsViewBloc(
    this._color,
    this._client,
  ) : super(
          ColorDetailsViewModel.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    final user = _color.userName != null
        ? await fetchUser(_client, _color.userName!)
        : null;
    final relatedColors = _color.hsv != null
        ? await fetchRelatedColorsPreview(_client, _color.hsv!)
        : <ColourloversColor>[];
    final relatedPalettes = _color.hex != null
        ? await fetchRelatedPalettesPreview(_client, [_color.hex!])
        : <ColourloversPalette>[];
    final relatedPatterns = _color.hex != null
        ? await fetchRelatedPatternsPreview(_client, [_color.hex!])
        : <ColourloversPattern>[];

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
        user: user != null
            ? UserTileViewModel.fromColourloverUser(user)
            : UserTileViewModel.empty(),
        relatedColors: relatedColors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        relatedPalettes: relatedPalettes //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        relatedPatterns: relatedPatterns //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
      ),
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
        actions: const [
/* TODO
          IconButton(
            onPressed: () async {
              ref
                  .read(routingProvider.notifier)
                  .showScreen(context, ShareColorView(color: color));
            },
            icon: const Icon(
              BoxIcons.bx_export_regular,
            ),
          ),
*/
        ],
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      viewModel.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ItemButtonView(
                    onTap: () {
                      // TODO
                      // ref
                      //     .read(routingProvider.notifier)
                      //     .showScreen(context, ShareColorView(color: color));
                    },
                    child: ColorView(hex: viewModel.hex),
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 32),
                  const H2TextView('Values'),
                  const SizedBox(height: 16),
                  ColorValueView(
                    label: 'R',
                    value: viewModel.rgb.red,
                    minValue: 0,
                    maxValue: 256,
                    trackColors: const [Color(0xFF000000), Color(0xFFFF0000)],
                  ),
                  ColorValueView(
                    label: 'G',
                    value: viewModel.rgb.green,
                    minValue: 0,
                    maxValue: 256,
                    trackColors: const [Color(0xFF000000), Color(0xFF00FF00)],
                  ),
                  ColorValueView(
                    label: 'B',
                    value: viewModel.rgb.blue,
                    minValue: 0,
                    maxValue: 256,
                    trackColors: const [Color(0xFF000000), Color(0xFF0000FF)],
                  ),
                  const SizedBox(height: 16),
                  ColorValueView(
                    label: 'H',
                    value: viewModel.hsv.hue,
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
                    value: viewModel.hsv.saturation,
                    minValue: 0,
                    maxValue: 100,
                    trackColors: [
                      const Color(0xFF000000),
                      HSVColor.fromAHSV(1, viewModel.hsv.hue, 1, 1).toColor()
                    ],
                  ),
                  ColorValueView(
                    label: 'V',
                    value: viewModel.hsv.value,
                    minValue: 0,
                    maxValue: 100,
                    trackColors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
                  ),
                  const SizedBox(height: 32),
                  const H2TextView('Created by'),
                  const SizedBox(height: 16),
                  UserTileView(
                    viewModel: viewModel.user,
                    onTap: () {
                      // TODO
                      // ref
                      //     .read(routingProvider.notifier)
                      //     .showScreen(context, UserView(user: user));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: RelatedColorsView(
                      // hsv: viewModel.hsv,
                      viewModels: viewModel.relatedColors,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: RelatedPalettesView(
                      // hexs: viewModel.hexs,
                      viewModels: viewModel.relatedPalettes,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: RelatedPatternsView(
                      // hexs: viewModel.hexs,
                      viewModels: viewModel.relatedPatterns,
                    ),
                  ),
                  const SizedBox(height: 32),
                  LinkView(
                    text: 'This color on COLOURlovers.com',
                    onTap: () {
                      openUrl(
                          'https://www.colourlovers.com/color/${viewModel.hex}');
                    },
                  ),
                  const SizedBox(height: 16),
                  LinkView(
                    text:
                        'Licensed under Attribution-Noncommercial-Share Alike',
                    onTap: () {
                      openUrl(creativeCommonsUrl);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
