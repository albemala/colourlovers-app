import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/user-details/view-controller.dart';
import 'package:colourlovers_app/user-details/view-state.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-details.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/label-value.dart';
import 'package:colourlovers_app/widgets/related-items-preview.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsViewCreator extends StatelessWidget {
  final ColourloversLover user;

  const UserDetailsViewCreator({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UserDetailsViewController.fromContext(
          context,
          user: user,
        );
      },
      child: BlocBuilder<UserDetailsViewController, UserDetailsViewState>(
        builder: (context, state) {
          return UserDetailsView(
            state: state,
            controller: context.read<UserDetailsViewController>(),
          );
        },
      ),
    );
  }
}

class UserDetailsView extends StatelessWidget {
  final UserDetailsViewState state;
  final UserDetailsViewController controller;

  const UserDetailsView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final userName = state.userName;
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User',
        actions: const [
          // TODO: Implement action buttons if needed
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
                  Center(
                    child: Text(
                      state.userName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SeparatedColumn(
                    separatorBuilder: () {
                      return const SizedBox(height: 8);
                    },
                    children: [
                      Column(
                        children: [
                          LabelValueView(
                            label: 'Colors',
                            value: state.numColors,
                          ),
                          LabelValueView(
                            label: 'Palettes',
                            value: state.numPalettes,
                          ),
                          LabelValueView(
                            label: 'Patterns',
                            value: state.numPatterns,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          LabelValueView(
                            label: 'Rating',
                            value: state.rating,
                          ),
                          LabelValueView(
                            label: 'Lovers',
                            value: state.numLovers,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          LabelValueView(
                            label: 'Location',
                            value: state.location,
                          ),
                          LabelValueView(
                            label: 'Registered',
                            value: state.dateRegistered,
                          ),
                          LabelValueView(
                            label: 'Last Active',
                            value: state.dateLastActive,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (state.userColors.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Colors',
                      items: state.userColors.toList(),
                      itemBuilder: (state) {
                        return ColorTileView(
                          state: state,
                          onTap: () {
                            controller.showColorDetailsView(context, state);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        controller.showUserColorsView(context);
                      },
                    ),
                  if (state.userPalettes.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Palettes',
                      items: state.userPalettes.toList(),
                      itemBuilder: (state) {
                        return PaletteTileView(
                          state: state,
                          onTap: () {
                            controller.showPaletteDetailsView(context, state);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        controller.showUserPalettesView(context);
                      },
                    ),
                  if (state.userPatterns.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Patterns',
                      items: state.userPatterns.toList(),
                      itemBuilder: (state) {
                        return PatternTileView(
                          state: state,
                          onTap: () {
                            controller.showPatternDetailsView(context, state);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        controller.showUserPatternsView(context);
                      },
                    ),
                  CreditsView(
                    itemName: 'user',
                    itemUrl: '$colourLoversUrl/lover/$userName',
                  ),
                ],
              ),
            ),
    );
  }
}
