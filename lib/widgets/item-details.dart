import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  final String title;
  final Widget item;
  final void Function() onItemTap;

  const HeaderView({
    super.key,
    required this.title,
    required this.item,
    required this.onItemTap,
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
          onTap: onItemTap,
          child: item,
        ),
      ],
    );
  }
}

class CreatedByView extends StatelessWidget {
  final UserTileViewState user;
  final void Function() onUserTap;

  const CreatedByView({
    super.key,
    required this.user,
    required this.onUserTap,
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
          state: user,
          onTap: onUserTap,
        ),
      ],
    );
  }
}

class CreditsView extends StatelessWidget {
  final String itemName;
  final String itemUrl;

  const CreditsView({
    super.key,
    required this.itemName,
    required this.itemUrl,
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
          text: 'This $itemName on COLOURlovers.com',
          onTap: () {
            openUrl(itemUrl);
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

class ItemColorsView extends StatelessWidget {
  final List<ColorTileViewState> colorViewStates;
  final void Function(ColorTileViewState) onColorTap;

  const ItemColorsView({
    super.key,
    required this.colorViewStates,
    required this.onColorTap,
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
          children: colorViewStates.map((state) {
            return ColorTileView(
              state: state,
              onTap: () {
                onColorTap(state);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
