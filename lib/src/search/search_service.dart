import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

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
    final searchParameters = {
      'q': q,
      'query_by': 'company_name',
      'filter_by': 'location: (49.1996961,7.6087847, 10 km)',
      'sort_by': 'location(49.1996961, 7.6087847):asc'
    };
    var res =
        await client.collection('companies').documents.search(searchParameters);

    return res;
  }
}
