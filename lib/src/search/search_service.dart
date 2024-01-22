import 'dart:convert';

import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'collections.dart' as collections;

class TSSearchService {
  // set the client as a private variable
  late Client client;

  Future<void> init() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.message}');
    });

    // Replace with your configuration
    final host = 'localhost';
    final config = Configuration(
      // Api key
      'xyz',
      nodes: {
        Node.withUri(
          Uri(
            scheme: 'http',
            host: host,
            port: 8108,
          ),
        ),
      },
      numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
      connectionTimeout: const Duration(seconds: 2),
    );

    client = Client(config);

    await collections.create(client);
    await collections.importDocs(client);
  }

  Future<Map<String, dynamic>> searchCollection(String q) async {
    print('Searching collection for: $q');

    Uri url = Uri.parse('http://127.0.0.1:5000/get-embedding');
    var body = json.encode({
      'text': q,
    });

    print('Body: $body');

    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    final embedding = json.decode(response.body)[0];

    final searchRequests = {
      'searches': [
        {
          "collection": "companies",
          "q": '*',
          'vector_query':
              'company_name_embedding:(' + embedding.toString() + ', k:100)',
        }
      ]
    };

    var res = await client.multiSearch.perform(searchRequests);
    return res;
  }
}
