import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/related-items.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/views/share-color.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/color-value.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
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

  void showShareColorView(BuildContext context) {
    openRoute(context, ShareColorViewBuilder(color: _color));
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
                  _HeaderView(
                    title: viewModel.title,
                    hex: viewModel.hex,
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
                  _CreatedByView(
                    user: viewModel.user,
                  ),
                  if (viewModel.relatedColors.isNotEmpty)
                    RelatedColorsView(
                      // hsv: viewModel.hsv,
                      viewModels: viewModel.relatedColors,
                    ),
                  if (viewModel.relatedPalettes.isNotEmpty)
                    RelatedPalettesView(
                      // hexs: viewModel.hexs,
                      viewModels: viewModel.relatedPalettes,
                    ),
                  if (viewModel.relatedPatterns.isNotEmpty)
                    RelatedPatternsView(
                      // hexs: viewModel.hexs,
                      viewModels: viewModel.relatedPatterns,
                    ),
                  _CreditsView(
                    hex: viewModel.hex,
                  ),
                ],
              ),
            ),
    );
  }
}

class _HeaderView extends StatelessWidget {
  final String title;
  final String hex;

  const _HeaderView({
    required this.title,
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      separatorBuilder: () {
        return const SizedBox(height: 16);
      },
      children: [
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ItemButtonView(
          onTap: () {
            // TODO
            // ref
            //     .read(routingProvider.notifier)
            //     .showScreen(context, ShareColorView(color: color));
          },
          child: ColorView(hex: hex),
        ),
      ],
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

class _CreatedByView extends StatelessWidget {
  final UserTileViewModel user;

  const _CreatedByView({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      separatorBuilder: () {
        return const SizedBox(height: 16);
      },
      children: [
        const H2TextView('Created by'),
        UserTileView(
          viewModel: user,
          onTap: () {
            // TODO
            // ref
            //     .read(routingProvider.notifier)
            //     .showScreen(context, UserView(user: user));
          },
        ),
      ],
    );
  }
}

class _CreditsView extends StatelessWidget {
  final String hex;

  const _CreditsView({
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      separatorBuilder: () {
        return const SizedBox(height: 16);
      },
      children: [
        LinkView(
          text: 'This color on COLOURlovers.com',
          onTap: () {
            openUrl('https://www.colourlovers.com/color/$hex');
          },
        ),
        LinkView(
          text: 'Licensed under Attribution-Noncommercial-Share Alike',
          onTap: () {
            openUrl(creativeCommonsUrl);
          },
        ),
      ],
    );
  }
}
