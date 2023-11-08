import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/colors.dart';
import 'package:colourlovers_app/functions/related-items.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/views/share-palette.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
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

  PaletteDetailsViewBloc(
    this._palette,
    this._client,
  ) : super(
          PaletteDetailsViewModel.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    final user = _palette.userName != null
        ? await fetchUser(_client, _palette.userName!)
        : null;
    final colors = _palette.colors != null
        ? await fetchColors(_client, _palette.colors!)
        : <ColourloversColor>[];
    final relatedPalettes = _palette.colors != null
        ? await fetchRelatedPalettesPreview(_client, _palette.colors!)
        : <ColourloversPalette>[];
    final relatedPatterns = _palette.colors != null
        ? await fetchRelatedPatternsPreview(_client, _palette.colors!)
        : <ColourloversPattern>[];

    emit(
      PaletteDetailsViewModel(
        isLoading: false,
        id: (_palette.id ?? 0).toString(),
        title: _palette.title ?? '',
        colors: _palette.colors ?? [],
        colorWidths: _palette.colorWidths ?? [],
        colorViewModels: colors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        numViews: (_palette.numViews ?? 0).toString(),
        numVotes: (_palette.numVotes ?? 0).toString(),
        rank: (_palette.rank ?? 0).toString(),
        user: user != null //
            ? UserTileViewModel.fromColourloverUser(user)
            : UserTileViewModel.empty(),
        relatedPalettes: relatedPalettes //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        relatedPatterns: relatedPatterns //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
      ),
    );
  }

  void showSharePaletteView(BuildContext context) {
    openRoute(context, SharePaletteViewBuilder(palette: _palette));
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
                  _HeaderView(
                    title: viewModel.title,
                    colors: viewModel.colors,
                    colorWidths: viewModel.colorWidths,
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
                  _ColorsView(
                    colorViewModels: viewModel.colorViewModels,
                  ),
                  _CreatedByView(
                    user: viewModel.user,
                  ),
                  RelatedPalettesView(
                    viewModels: viewModel.relatedPalettes,
                  ),
                  RelatedPatternsView(
                    viewModels: viewModel.relatedPatterns,
                  ),
                  _CreditsView(
                    id: viewModel.id,
                  ),
                ],
              ),
            ),
    );
  }
}

class _HeaderView extends StatelessWidget {
  final String title;
  final List<String> colors;
  final List<double> colorWidths;

  const _HeaderView({
    required this.title,
    required this.colors,
    required this.colorWidths,
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
            // ref.read(routingProvider.notifier).showScreen(context, SharePaletteView(palette: palette));
          },
          child: PaletteView(
            hexs: colors,
            widths: colorWidths,
          ),
        ),
      ],
    );
  }
}

class _ColorsView extends StatelessWidget {
  final List<ColorTileViewModel> colorViewModels;

  const _ColorsView({
    required this.colorViewModels,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      separatorBuilder: () {
        return const SizedBox(height: 16);
      },
      children: [
        const H2TextView('Colors'),
        SeparatedColumn(
          separatorBuilder: () {
            return const SizedBox(height: 8);
          },
          children: colorViewModels.map((color) {
            return ColorTileView(
              viewModel: color,
              onTap: () {
                // TODO
              },
            );
          }).toList(),
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
          },
        ),
      ],
    );
  }
}

class _CreditsView extends StatelessWidget {
  final String id;

  const _CreditsView({
    required this.id,
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
          text: 'This palette on COLOURlovers.com',
          onTap: () {
            openUrl('https://www.colourlovers.com/palette/$id');
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
