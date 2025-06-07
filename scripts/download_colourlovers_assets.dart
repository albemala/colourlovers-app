import 'dart:convert';
import 'dart:io';

import 'package:colourlovers_api/colourlovers_api.dart';

Future<void> main() async {
  await _downloadAndSaveItems();
  await _downloadPatternImages();
}

Future<void> _downloadAndSaveItems() async {
  // Create assets/items directory if it doesn't exist
  final itemsDir = Directory('assets/items');
  if (!await itemsDir.exists()) {
    await itemsDir.create(recursive: true);
  }

  final client = ColourloversApiClient();

  // Download and save top colors
  print('Fetching top colors...');
  final topColors = await client.getTopColors();
  if (topColors != null) {
    await _saveJsonToFile(
      topColors.map((c) => c.toJson()).toList(),
      'assets/items/colors.json',
    );
    print('Saved ${topColors.length} top colors.');
  }

  // Download and save top palettes
  print('Fetching top palettes...');
  final topPalettes = await client.getTopPalettes();
  if (topPalettes != null) {
    await _saveJsonToFile(
      topPalettes.map((p) => p.toJson()).toList(),
      'assets/items/palettes.json',
    );
    print('Saved ${topPalettes.length} top palettes.');
  }

  // Download and save top patterns
  print('Fetching top patterns...');
  final topPatterns = await client.getTopPatterns();
  if (topPatterns != null) {
    await _saveJsonToFile(
      topPatterns.map((p) => p.toJson()).toList(),
      'assets/items/patterns.json',
    );
    print('Saved ${topPatterns.length} top patterns.');
  }

  // Download and save top lovers
  print('Fetching top lovers...');
  final topLovers = await client.getTopLovers();
  if (topLovers != null) {
    await _saveJsonToFile(
      topLovers.map((l) => l.toJson()).toList(),
      'assets/items/lovers.json',
    );
    print('Saved ${topLovers.length} top lovers.');
  }
}

Future<void> _saveJsonToFile(List<dynamic> data, String filePath) async {
  final file = File(filePath);
  await file.writeAsString(jsonEncode(data));
}

Future<void> _downloadPatternImages() async {
  final client = ColourloversApiClient();
  final patterns = await client.getTopPatterns();

  if (patterns == null) {
    print('No patterns to download images for.');
    return;
  }

  final downloadFutures =
      patterns.map((pattern) => pattern.imageUrl).whereType<String>().map((
        imageUrl,
      ) async {
        final uri = Uri.parse(imageUrl);
        final filename = uri.pathSegments.last;

        final httpClient = HttpClient();
        try {
          final request = await httpClient.getUrl(uri);
          final response = await request.close();

          if (response.statusCode == 200) {
            final file = File('assets/patterns/$filename')
              ..createSync(recursive: true);
            await response.pipe(file.openWrite());
            print('Downloaded: $filename');
          } else {
            print('Failed to download: $imageUrl (${response.statusCode})');
          }
        } catch (e) {
          print('Error downloading: $imageUrl - $e');
        } finally {
          httpClient.close();
        }
      }).toList();

  if (downloadFutures.isNotEmpty) {
    await Future.wait(downloadFutures);
    print('Finished downloading pattern images.');
  }
}
