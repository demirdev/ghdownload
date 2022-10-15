library ghdownload;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

main(List<dynamic> args) async {
  final url = args.first;

  // String downloadURL =
  //     'https://api.github.com/repos/deeja/bing-maps-loader/git/trees/master?recursive=1';

  String downloadURL = url;
  downloadURL = downloadURL.replaceAll('github.com/', 'api.github.com/repos/');

  String path = '';
  String urlFirstPart = '';
  if (downloadURL.contains('/tree/')) {
    final parts = downloadURL.split('/');
    final indexOfTree = parts.indexOf('tree');
    path = '/' + parts.sublist(indexOfTree + 2).join('/');

    urlFirstPart = parts.sublist(0, indexOfTree).join('/');
  }

  downloadURL = urlFirstPart + '/contents' + path;

  final response = await http.get(Uri.parse(downloadURL));

  final json = jsonDecode(response.body) as List<dynamic>;

  for (final d in json) {
    final fileURL = d['download_url'];
    final fileName = basename(fileURL);

    final fileContent = await http.get(Uri.parse(fileURL));
    File(fileName).writeAsBytes(fileContent.bodyBytes);

    print('$fileName downloaded.');
  }
}
