import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/label-value.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
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
    final userColors = await fetchUserColorsPreview(_client, userName);
    final userPalettes = await fetchUserPalettesPreview(_client, userName);
    final userPatterns = await fetchUserPatternsPreview(_client, userName);

    emit(
      UserDetailsViewModel(
        isLoading: false,
        userName: userName,
        numColors: (_user.numColors ?? 0).toString(),
        numPalettes: (_user.numPalettes ?? 0).toString(),
        numPatterns: (_user.numPatterns ?? 0).toString(),
        rating: (_user.rating ?? 0).toString(),
        numLovers: (_user.numLovers ?? 0).toString(),
        location: _user.location ?? '',
        dateRegistered: _formatDate(_user.dateRegistered),
        dateLastActive: _formatDate(_user.dateLastActive),
        userColors: userColors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        userPalettes: userPalettes //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        userPatterns: userPatterns //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
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
                  // TODO the original implementation used UserColorsWidgets, ...
                  RelatedColorsView(viewModels: viewModel.userColors),
                  RelatedPalettesView(viewModels: viewModel.userPalettes),
                  RelatedPatternsView(viewModels: viewModel.userPatterns),
                  _CreditsView(userName: userName),
                ],
              ),
            ),
    );
  }
}

class _CreditsView extends StatelessWidget {
  final String userName;

  const _CreditsView({
    super.key,
    required this.userName,
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
          text: 'This user on COLOURlovers.com',
          onTap: () {
            openUrl('https://www.colourlovers.com/lover/$userName');
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
