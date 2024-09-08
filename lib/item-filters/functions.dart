import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/item-filters/defines.dart';

String getItemFilterName(ItemsFilter filter) {
  switch (filter) {
    case ItemsFilter.newest:
      return 'Newest';
    case ItemsFilter.top:
      return 'Top';
    case ItemsFilter.all:
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
  switch (sortBy) {
    case ColourloversRequestSortBy.ASC:
      return 'Ascending';
    case ColourloversRequestSortBy.DESC:
      return 'Descending';
  }
}
