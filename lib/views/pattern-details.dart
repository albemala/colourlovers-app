import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/related-items.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
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
class PatternDetailsViewModel {
  final bool isLoading;
  final String title;
  final List<String> colors;
  final String imageUrl;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewModel user;
  final List<PaletteTileViewModel> relatedPalettes;
  final List<PatternTileViewModel> relatedPatterns;

  const PatternDetailsViewModel({
    required this.isLoading,
    required this.title,
    required this.colors,
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
      title: '',
      colors: const [],
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
    final relatedPalettes = _pattern.colors != null
        ? await fetchRelatedPalettesPreview(_client, _pattern.colors!)
        : <ColourloversPalette>[];
    final relatedPatterns = _pattern.colors != null
        ? await fetchRelatedPatternsPreview(_client, _pattern.colors!)
        : <ColourloversPattern>[];

    emit(
      PatternDetailsViewModel(
        isLoading: false,
        title: _pattern.title ?? '',
        colors: _pattern.colors ?? [],
        imageUrl: _pattern.imageUrl ?? '',
        numViews: (_pattern.numViews ?? 0).toString(),
        numVotes: (_pattern.numVotes ?? 0).toString(),
        rank: (_pattern.rank ?? 0).toString(),
        user: user != null
            ? UserTileViewModel.fromColourloverUser(user)
            : UserTileViewModel.empty(),
        relatedPalettes: relatedPalettes
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        relatedPatterns: relatedPatterns
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
      ),
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
        actions: const [
          // TODO:
/*
          IconButton(
            onPressed: () async {
              ref.read(routingProvider.notifier).showScreen(context, SharePatternView(pattern: pattern));
            },
            icon: const Icon(
              BoxIcons.bx_export_regular,
            ),
          ),
*/
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
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
                      // TODO: Implement onTap functionality
                      // ref.read(routingProvider.notifier).showScreen(context, SharePatternView(pattern: pattern));
                    },
                    child: PatternView(imageUrl: viewModel.imageUrl),
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
/* TODO
                  const H2TextWidget('Colors'),
                  const SizedBox(height: 16),
                      ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final color = colors.elementAt(index);
                      return color != null ? ColorTileWidget(color: color) : Container();
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  )
                  const SizedBox(height: 32),
*/
                  const SizedBox(height: 32),
                  const H2TextView('Created by'),
                  const SizedBox(height: 16),
                  UserTileView(
                    viewModel: viewModel.user,
                    onTap: () {
                      // TODO: Implement onTap functionality
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: RelatedPalettesView(
                      viewModels: viewModel.relatedPalettes,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: RelatedPatternsView(
                      viewModels: viewModel.relatedPatterns,
                    ),
                  ),
                  const SizedBox(height: 32),
                  LinkView(
                    text: 'This pattern on COLOURlovers.com',
                    onTap: () {
                      openUrl(
                          'https://www.colourlovers.com/pattern/${viewModel.title}');
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
