import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

@immutable
class ColorTileViewState extends Equatable {
  final String title;
  final int numViews;
  final int numVotes;
  final String hex;

  const ColorTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hex,
  });

  @override
  List<Object?> get props => [title, numViews, numVotes, hex];

  ColorTileViewState copyWith({
    String? title,
    int? numViews,
    int? numVotes,
    String? hex,
  }) {
    return ColorTileViewState(
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      hex: hex ?? this.hex,
    );
  }

  factory ColorTileViewState.fromColourloverColor(
    ColourloversColor color,
  ) {
    return ColorTileViewState(
      title: color.title ?? '',
      numViews: color.numViews ?? 0,
      numVotes: color.numVotes ?? 0,
      hex: color.hex ?? '',
    );
  }
}

class ColorTileView extends StatelessWidget {
  final void Function() onTap;
  final ColorTileViewState state;

  const ColorTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: ColorView(hex: state.hex),
    );
  }
}

@immutable
class PaletteTileViewState extends Equatable {
  final String title;
  final int numViews;
  final int numVotes;
  final IList<String> hexs;
  final IList<double> widths;

  const PaletteTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hexs,
    required this.widths,
  });

  @override
  List<Object?> get props => [title, numViews, numVotes, hexs, widths];

  PaletteTileViewState copyWith({
    String? title,
    int? numViews,
    int? numVotes,
    IList<String>? hexs,
    IList<double>? widths,
  }) {
    return PaletteTileViewState(
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      hexs: hexs ?? this.hexs,
      widths: widths ?? this.widths,
    );
  }

  factory PaletteTileViewState.fromColourloverPalette(
    ColourloversPalette palette,
  ) {
    return PaletteTileViewState(
      title: palette.title ?? '',
      numViews: palette.numViews ?? 0,
      numVotes: palette.numVotes ?? 0,
      hexs: IList(palette.colors ?? []),
      widths: IList(palette.colorWidths ?? []),
    );
  }
}

class PaletteTileView extends StatelessWidget {
  final void Function() onTap;
  final PaletteTileViewState state;

  const PaletteTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: PaletteView(
        hexs: state.hexs.toList(),
        widths: state.widths.toList(),
      ),
    );
  }
}

@immutable
class PatternTileViewState extends Equatable {
  final String title;
  final int numViews;
  final int numVotes;
  final String imageUrl;

  const PatternTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [title, numViews, numVotes, imageUrl];

  PatternTileViewState copyWith({
    String? title,
    int? numViews,
    int? numVotes,
    String? imageUrl,
  }) {
    return PatternTileViewState(
      title: title ?? this.title,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory PatternTileViewState.fromColourloverPattern(
    ColourloversPattern pattern,
  ) {
    return PatternTileViewState(
      title: pattern.title ?? '',
      numViews: pattern.numViews ?? 0,
      numVotes: pattern.numVotes ?? 0,
      imageUrl: pattern.imageUrl ?? '',
    );
  }
}

class PatternTileView extends StatelessWidget {
  final void Function() onTap;
  final PatternTileViewState state;

  const PatternTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: PatternView(imageUrl: state.imageUrl),
    );
  }
}

class _ItemTileView extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final int numViews;
  final int numVotes;
  final Widget child;

  const _ItemTileView({
    required this.onTap,
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox.expand(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: child,
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
            ),
          ),
          Positioned(
            top: 8,
            left: -4,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SkewedContainerView(
                    padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                    color: Theme.of(context).colorScheme.inverseSurface,
                    elevation: 4,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                          ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    PillView(
                      text: numViews.toString(),
                      icon: LucideIcons.glasses,
                    ),
                    const SizedBox(width: 8),
                    PillView(
                      text: numVotes.toString(),
                      icon: LucideIcons.heart,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class UserTileViewState extends Equatable {
  final String userName;
  final int numColors;
  final int numPalettes;
  final int numPatterns;

  const UserTileViewState({
    required this.userName,
    required this.numColors,
    required this.numPalettes,
    required this.numPatterns,
  });

  @override
  List<Object?> get props => [userName, numColors, numPalettes, numPatterns];

  UserTileViewState copyWith({
    String? userName,
    int? numColors,
    int? numPalettes,
    int? numPatterns,
  }) {
    return UserTileViewState(
      userName: userName ?? this.userName,
      numColors: numColors ?? this.numColors,
      numPalettes: numPalettes ?? this.numPalettes,
      numPatterns: numPatterns ?? this.numPatterns,
    );
  }

  factory UserTileViewState.fromColourloverUser(
    ColourloversLover user,
  ) {
    return UserTileViewState(
      userName: user.userName ?? '',
      numColors: user.numColors ?? 0,
      numPalettes: user.numPalettes ?? 0,
      numPatterns: user.numPatterns ?? 0,
    );
  }
}

class UserTileView extends StatelessWidget {
  final void Function() onTap;
  final UserTileViewState state;

  const UserTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const UserView(),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                onTap();
                // TODO
                // ref.read(routingProvider.notifier).showScreen(context, UserDetailsView(lover: lover));
              },
            ),
          ),
          Positioned(
            top: 8,
            left: -4,
            // right: 8,
            child: SkewedContainerView(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
              color: Theme.of(context).colorScheme.inverseSurface,
              elevation: 4,
              child: Text(
                state.userName,
                // maxLines: 1,
                // overflow: TextOverflow.fade,
                // softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            // right: 8,
            child: Row(
              children: [
                PillView(
                  text: state.numColors.toString(),
                  icon: LucideIcons.square,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: state.numPalettes.toString(),
                  icon: LucideIcons.columns,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: state.numPatterns.toString(),
                  icon: LucideIcons.grid,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const defaultColorTileViewState = ColorTileViewState(
  title: '',
  numViews: 0,
  numVotes: 0,
  hex: '',
);

const defaultPaletteTileViewState = PaletteTileViewState(
  title: '',
  numViews: 0,
  numVotes: 0,
  hexs: IList.empty(),
  widths: IList.empty(),
);

const defaultPatternTileViewState = PatternTileViewState(
  title: '',
  numViews: 0,
  numVotes: 0,
  imageUrl: '',
);

const defaultUserTileViewState = UserTileViewState(
  userName: '',
  numColors: 0,
  numPalettes: 0,
  numPatterns: 0,
);
