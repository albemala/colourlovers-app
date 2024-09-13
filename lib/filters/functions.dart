import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:flutter/material.dart';

String getContentShowCriteriaName(ContentShowCriteria criteria) {
  switch (criteria) {
    case ContentShowCriteria.newest:
      return 'Newest';
    case ContentShowCriteria.top:
      return 'Top Rated';
    case ContentShowCriteria.all:
      return 'All';
  }
}

String getColourloversRequestOrderByName(ColourloversRequestOrderBy orderBy) {
  switch (orderBy) {
    case ColourloversRequestOrderBy.dateCreated:
      return 'Date Created';
    case ColourloversRequestOrderBy.score:
      return 'Score';
    case ColourloversRequestOrderBy.name:
      return 'Name';
    case ColourloversRequestOrderBy.numVotes:
      return 'Votes';
    case ColourloversRequestOrderBy.numViews:
      return 'Views';
  }
}

String getColourloversRequestSortByName(ColourloversRequestSortBy sortBy) {
  // TODO depends on ColourloversRequestOrderBy
  switch (sortBy) {
    case ColourloversRequestSortBy.ASC:
      return 'Ascending';
    case ColourloversRequestSortBy.DESC:
      return 'Descending';
  }
}

String getColorFilterName(ColorFilter filter) {
  switch (filter) {
    case ColorFilter.none:
      return 'None';
    case ColorFilter.hueRanges:
      return 'Hue Ranges';
    case ColorFilter.hex:
      return 'Color Hex';
  }
}

String getColourloversRequestHueRangeName(
    ColourloversRequestHueRange hueRange) {
  switch (hueRange) {
    case ColourloversRequestHueRange.red:
      return 'Red';
    case ColourloversRequestHueRange.orange:
      return 'Orange';
    case ColourloversRequestHueRange.yellow:
      return 'Yellow';
    case ColourloversRequestHueRange.green:
      return 'Green';
    case ColourloversRequestHueRange.aqua:
      return 'Aqua';
    case ColourloversRequestHueRange.blue:
      return 'Blue';
    case ColourloversRequestHueRange.violet:
      return 'Violet';
    case ColourloversRequestHueRange.fuchsia:
      return 'Fuchsia';
  }
}

Color getColourloversRequestHueRangeColor(
    ColourloversRequestHueRange hueRange) {
  switch (hueRange) {
    case ColourloversRequestHueRange.red:
      return Colors.red;
    case ColourloversRequestHueRange.orange:
      return Colors.orange;
    case ColourloversRequestHueRange.yellow:
      return Colors.yellow;
    case ColourloversRequestHueRange.green:
      return Colors.green;
    case ColourloversRequestHueRange.aqua:
      return Colors.cyan;
    case ColourloversRequestHueRange.blue:
      return Colors.blue;
    case ColourloversRequestHueRange.violet:
      return Colors.deepPurpleAccent;
    case ColourloversRequestHueRange.fuchsia:
      return Colors.purpleAccent;
  }
}
