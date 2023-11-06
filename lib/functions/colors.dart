import 'package:colourlovers_api/colourlovers_api.dart';

Future<List<ColourloversColor>> fetchColors(
  ColourloversApiClient client,
  List<String> colors,
) async {
  final futureResults = colors.map((color) => client.getColor(hex: color));
  final results = await Future.wait(futureResults);
  return results.whereType<ColourloversColor>().toList();
}
