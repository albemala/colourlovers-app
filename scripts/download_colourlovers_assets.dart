// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:colourlovers_api/colourlovers_api.dart';

void _deleteDirectorySync(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }
}

Future<void> main() async {
  // Delete existing download folder
  _deleteDirectorySync('assets/items');

  // Create necessary directories
  _createDirectorySync('assets/items');
  _createDirectorySync('assets/items/colors');
  _createDirectorySync('assets/items/palettes');
  _createDirectorySync('assets/items/patterns');
  _createDirectorySync('assets/items/lovers');

  final client = ColourloversApiClient();

  // Download and save top colors
  print('Fetching top colors...');
  final topColors = await client.getTopColors();
  if (topColors != null) {
    _saveJsonToFile(
      topColors.map((c) => c.toJson()).toList(),
      'assets/items/colors.json',
    );
    print('Saved ${topColors.length} top colors.');

    // Download color images
    final itemsToDownload =
        topColors
            .map(
              (c) => (id: c.id.toString(), imageUrl: httpToHttps(c.imageUrl!)),
            )
            .toList();
    await _downloadImages(itemsToDownload, 'assets/items/colors');
  }

  // Download and save top palettes
  print('Fetching top palettes...');
  final topPalettes = await client.getTopPalettes();
  if (topPalettes != null) {
    _saveJsonToFile(
      topPalettes.map((p) => p.toJson()).toList(),
      'assets/items/palettes.json',
    );
    print('Saved ${topPalettes.length} top palettes.');

    // Download palette images
    final itemsToDownload =
        topPalettes
            .map(
              (p) => (id: p.id.toString(), imageUrl: httpToHttps(p.imageUrl!)),
            )
            .toList();
    await _downloadImages(itemsToDownload, 'assets/items/palettes');
  }

  // Download and save top patterns
  print('Fetching top patterns...');
  final topPatterns = await client.getTopPatterns();
  if (topPatterns != null) {
    _saveJsonToFile(
      topPatterns.map((p) => p.toJson()).toList(),
      'assets/items/patterns.json',
    );
    print('Saved ${topPatterns.length} top patterns.');

    // Download pattern images
    final itemsToDownload =
        topPatterns
            .map(
              (p) => (id: p.id.toString(), imageUrl: httpToHttps(p.imageUrl!)),
            )
            .toList();
    await _downloadImages(itemsToDownload, 'assets/items/patterns');
  }

  // Download and save top lovers
  print('Fetching top lovers...');
  final topLovers = await client.getTopLovers();
  if (topLovers != null) {
    _saveJsonToFile(
      topLovers.map((l) => l.toJson()).toList(),
      'assets/items/lovers.json',
    );
    print('Saved ${topLovers.length} top lovers.');
  }
}

void _saveJsonToFile(List<dynamic> data, String filePath) {
  File(filePath).writeAsStringSync(jsonEncode(data));
}

Future<void> _downloadImages(
  List<({String id, String imageUrl})> items,
  String destinationFolder,
) async {
  // Create destination directory if it doesn't exist
  final destDir = Directory(destinationFolder);
  if (!destDir.existsSync()) {
    destDir.createSync(recursive: true);
  }

  final downloadFutures =
      items.map((item) async {
        final id = item.id;
        final imageUrl = item.imageUrl;
        final filename = '$id.png'; // Use id as filename

        final httpClient = HttpClient();
        try {
          final request = await httpClient.getUrl(Uri.parse(imageUrl));
          final response = await request.close();

          if (response.statusCode == 200) {
            final file = File('$destinationFolder/$filename')
              ..createSync(recursive: true);
            await response.pipe(file.openWrite());
            print('Downloaded: $filename to $destinationFolder');
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
    print('Finished downloading images to $destinationFolder.');
  }
}

void _createDirectorySync(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}

String httpToHttps(String url) {
  return url.replaceFirst('http://', 'https://');
}
