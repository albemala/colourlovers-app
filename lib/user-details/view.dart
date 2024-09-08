import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/user-colors/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/user-palettes/view.dart';
import 'package:colourlovers_app/user-patterns/view.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-details.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/label-value.dart';
import 'package:colourlovers_app/widgets/related-items-preview.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class UserDetailsViewModel {
  final bool isLoading;
  final String userName;
  final String numColors;
  final String numPalettes;
  final String numPatterns;
  final String rating;
  final String numLovers;
  final String location;
  final String dateRegistered;
  final String dateLastActive;
  final List<ColorTileViewModel> userColors;
  final List<PaletteTileViewModel> userPalettes;
  final List<PatternTileViewModel> userPatterns;

  const UserDetailsViewModel({
    required this.isLoading,
    required this.userName,
    required this.numColors,
    required this.numPalettes,
    required this.numPatterns,
    required this.rating,
    required this.numLovers,
    required this.location,
    required this.dateRegistered,
    required this.dateLastActive,
    required this.userColors,
    required this.userPalettes,
    required this.userPatterns,
  });

  factory UserDetailsViewModel.empty() {
    return const UserDetailsViewModel(
      isLoading: true,
      userName: '',
      numColors: '',
      numPalettes: '',
      numPatterns: '',
      rating: '',
      numLovers: '',
      location: '',
      dateRegistered: '',
      dateLastActive: '',
      userColors: [],
      userPalettes: [],
      userPatterns: [],
    );
  }
}

class UserDetailsViewBloc extends Cubit<UserDetailsViewModel> {
  factory UserDetailsViewBloc.fromContext(
    BuildContext context, {
    required ColourloversLover user,
  }) {
    return UserDetailsViewBloc(
      user,
      ColourloversApiClient(),
    );
  }

  final ColourloversLover _user;
  final ColourloversApiClient _client;
  List<ColourloversColor> _userColors = [];
  List<ColourloversPalette> _userPalettes = [];
  List<ColourloversPattern> _userPatterns = [];

  UserDetailsViewBloc(
    this._user,
    this._client,
  ) : super(
          UserDetailsViewModel.empty(),
        ) {
    _init();
  }

  Future<void> _init() async {
    final userName = _user.userName ?? '';
    _userColors = await fetchUserColorsPreview(_client, userName);
    _userPalettes = await fetchUserPalettesPreview(_client, userName);
    _userPatterns = await fetchUserPatternsPreview(_client, userName);

    _updateState();
  }

  void _updateState() {
    emit(
      UserDetailsViewModel(
        isLoading: false,
        userName: _user.userName ?? '',
        numColors: (_user.numColors ?? 0).toString(),
        numPalettes: (_user.numPalettes ?? 0).toString(),
        numPatterns: (_user.numPatterns ?? 0).toString(),
        rating: (_user.rating ?? 0).toString(),
        numLovers: (_user.numLovers ?? 0).toString(),
        location: _user.location ?? '',
        dateRegistered: _formatDate(_user.dateRegistered),
        dateLastActive: _formatDate(_user.dateLastActive),
        userColors: _userColors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        userPalettes: _userPalettes //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        userPatterns: _userPatterns //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  void showColorDetailsView(
    BuildContext context,
    ColorTileViewModel viewModel,
  ) {
    final index = state.userColors.indexOf(viewModel);
    openRoute(
      context,
      ColorDetailsViewBuilder(color: _userColors[index]),
    );
  }

  void showPaletteDetailsView(
    BuildContext context,
    PaletteTileViewModel viewModel,
  ) {
    final index = state.userPalettes.indexOf(viewModel);
    openRoute(
      context,
      PaletteDetailsViewBuilder(palette: _userPalettes[index]),
    );
  }

  void showPatternDetailsView(
    BuildContext context,
    PatternTileViewModel viewModel,
  ) {
    final index = state.userPatterns.indexOf(viewModel);
    openRoute(
      context,
      PatternDetailsViewBuilder(pattern: _userPatterns[index]),
    );
  }

  void showUserColorsView(BuildContext context) {
    if (_user.userName == null) return;
    openRoute(
      context,
      UserColorsViewBuilder(userName: _user.userName!),
    );
  }

  void showUserPalettesView(BuildContext context) {
    if (_user.userName == null) return;
    openRoute(
      context,
      UserPalettesViewBuilder(userName: _user.userName!),
    );
  }

  void showUserPatternsView(BuildContext context) {
    if (_user.userName == null) return;
    openRoute(
      context,
      UserPatternsViewBuilder(userName: _user.userName!),
    );
  }
}

class UserDetailsViewBuilder extends StatelessWidget {
  final ColourloversLover user;

  const UserDetailsViewBuilder({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsViewBloc.fromContext(
        context,
        user: user,
      ),
      child: BlocBuilder<UserDetailsViewBloc, UserDetailsViewModel>(
        builder: (context, viewModel) {
          return UserDetailsView(
            viewModel: viewModel,
            bloc: context.read<UserDetailsViewBloc>(),
          );
        },
      ),
    );
  }
}

class UserDetailsView extends StatelessWidget {
  final UserDetailsViewModel viewModel;
  final UserDetailsViewBloc bloc;

  const UserDetailsView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final userName = viewModel.userName;
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User',
        actions: const [
          // TODO: Implement action buttons if needed
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
                  Center(
                    child: Text(
                      viewModel.userName,
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
                            value: viewModel.numColors,
                          ),
                          LabelValueView(
                            label: 'Palettes',
                            value: viewModel.numPalettes,
                          ),
                          LabelValueView(
                            label: 'Patterns',
                            value: viewModel.numPatterns,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          LabelValueView(
                            label: 'Rating',
                            value: viewModel.rating,
                          ),
                          LabelValueView(
                            label: 'Lovers',
                            value: viewModel.numLovers,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          LabelValueView(
                            label: 'Location',
                            value: viewModel.location,
                          ),
                          LabelValueView(
                            label: 'Registered',
                            value: viewModel.dateRegistered,
                          ),
                          LabelValueView(
                            label: 'Last Active',
                            value: viewModel.dateLastActive,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (viewModel.userColors.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Colors',
                      items: viewModel.userColors,
                      itemBuilder: (viewModel) {
                        return ColorTileView(
                          viewModel: viewModel,
                          onTap: () {
                            bloc.showColorDetailsView(context, viewModel);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        bloc.showUserColorsView(context);
                      },
                    ),
                  if (viewModel.userPalettes.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Palettes',
                      items: viewModel.userPalettes,
                      itemBuilder: (viewModel) {
                        return PaletteTileView(
                          viewModel: viewModel,
                          onTap: () {
                            bloc.showPaletteDetailsView(context, viewModel);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        bloc.showUserPalettesView(context);
                      },
                    ),
                  if (viewModel.userPatterns.isNotEmpty)
                    RelatedItemsPreviewView(
                      title: 'Patterns',
                      items: viewModel.userPatterns,
                      itemBuilder: (viewModel) {
                        return PatternTileView(
                          viewModel: viewModel,
                          onTap: () {
                            bloc.showPatternDetailsView(context, viewModel);
                          },
                        );
                      },
                      onShowMorePressed: () {
                        bloc.showUserPatternsView(context);
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
