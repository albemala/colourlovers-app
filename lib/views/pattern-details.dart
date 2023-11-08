import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/colors.dart';
import 'package:colourlovers_app/functions/related-items.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/views/share-pattern.dart';
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

  PatternDetailsViewBloc(
    this._pattern,
    this._client,
  ) : super(
          PatternDetailsViewModel.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    final user = _pattern.userName != null
        ? await fetchUser(_client, _pattern.userName!)
        : null;
    final colors = _pattern.colors != null
        ? await fetchColors(_client, _pattern.colors!)
        : <ColourloversColor>[];
    final relatedPalettes = _pattern.colors != null
        ? await fetchRelatedPalettesPreview(_client, _pattern.colors!)
        : <ColourloversPalette>[];
    final relatedPatterns = _pattern.colors != null
        ? await fetchRelatedPatternsPreview(_client, _pattern.colors!)
        : <ColourloversPattern>[];

    emit(
      PatternDetailsViewModel(
        isLoading: false,
        id: (_pattern.id ?? 0).toString(),
        title: _pattern.title ?? '',
        colors: _pattern.colors ?? [],
        colorViewModels: colors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        imageUrl: _pattern.imageUrl ?? '',
        numViews: (_pattern.numViews ?? 0).toString(),
        numVotes: (_pattern.numVotes ?? 0).toString(),
        rank: (_pattern.rank ?? 0).toString(),
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

  void showSharePatternView(BuildContext context) {
    openRoute(context, SharePatternViewBuilder(pattern: _pattern));
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
                  _HeaderView(
                    title: viewModel.title,
                    imageUrl: viewModel.imageUrl,
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
  final String imageUrl;

  const _HeaderView({
    required this.title,
    required this.imageUrl,
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
            // TODO: Implement onTap functionality
            // ref.read(routingProvider.notifier).showScreen(context, SharePatternView(pattern: pattern));
          },
          child: PatternView(imageUrl: imageUrl),
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
            // TODO: Implement onTap functionality
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
          text: 'This pattern on COLOURlovers.com',
          onTap: () {
            openUrl('https://www.colourlovers.com/pattern/$id');
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
