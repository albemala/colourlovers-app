import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/pattern-details/view-controller.dart';
import 'package:colourlovers_app/pattern-details/view-state.dart';
import 'package:colourlovers_app/urls/defines.dart';
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

class PatternDetailsViewCreator extends StatelessWidget {
  final ColourloversPattern pattern;

  const PatternDetailsViewCreator({
    super.key,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatternDetailsViewController>(
      create: (context) {
        return PatternDetailsViewController.fromContext(
          context,
          pattern: pattern,
        );
      },
      child: BlocBuilder<PatternDetailsViewController, PatternDetailsViewState>(
        builder: (context, state) {
          return PatternDetailsView(
            state: state,
            controller: context.read<PatternDetailsViewController>(),
          );
        },
      ),
    );
  }
}

class PatternDetailsView extends StatelessWidget {
  final PatternDetailsViewState state;
  final PatternDetailsViewController controller;

  const PatternDetailsView({
    super.key,
    required this.state,
    required this.controller,
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
              controller.showSharePatternView(context);
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SeparatedColumn(
                separatorBuilder: () {
                  return const SizedBox(height: 32);
                },
                children: [
                  HeaderView(
                    title: state.title,
                    item: PatternView(imageUrl: state.imageUrl),
                    onItemTap: () {
                      controller.showSharePatternView(context);
                    },
                  ),
                  Column(
                    children: [
                      LabelValueView(
                        label: 'Views',
                        value: state.numViews,
                      ),
                      LabelValueView(
                        label: 'Votes',
                        value: state.numVotes,
                      ),
                      LabelValueView(
                        label: 'Rank',
                        value: state.rank,
                      ),
                    ],
                  ),
                  // StatsView(
                  //   stats: [
                  //     StatsItemViewState(
                  //       label: 'Views',
                  //       value: state.numViews,
                  //     ),
                  //     StatsItemViewState(
                  //       label: 'Votes',
                  //       value: state.numVotes,
                  //     ),
                  //     StatsItemViewState(
                  //       label: 'Rank',
                  //       value: state.rank,
                  //     ),
                  //   ],
                  // ),
                  ItemColorsView(
                    colorViewStates: state.colorViewStates.toList(),
                    onColorTap: (state) {
                      controller.showColorDetailsView(context, state);
                    },
                  ),
                  CreatedByView(
                    user: state.user,
                    onUserTap: () {
                      controller.showUserDetailsView(context);
                    },
                  ),
                  if (state.relatedPalettes.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Related palettes',
                      items: state.relatedPalettes.toList(),
                      itemBuilder: (state) {
                        return PaletteTileView(
                          state: state,
                          onTap: () {
                            controller.showPaletteDetailsView(context, state);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        controller.showRelatedPalettesView(context);
                      },
                    ),
                  if (state.relatedPatterns.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Related patterns',
                      items: state.relatedPatterns.toList(),
                      itemBuilder: (state) {
                        return PatternTileView(
                          state: state,
                          onTap: () {
                            controller.showPatternDetailsView(context, state);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        controller.showRelatedPatternsView(context);
                      },
                    ),
                  CreditsView(
                    itemName: 'pattern',
                    itemUrl: '$colourLoversUrl/pattern/${state.id}',
                  ),
                ],
              ),
            ),
    );
  }
}
