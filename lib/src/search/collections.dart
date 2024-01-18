import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';

final log = Logger('Collections');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Collections example--');
  await create(client);
  await retrieve(client);
  await update(client);
  await retrieveAll(client);
  await delete(client);
}

final _demoDocs = [
  {
    'id': '124',
    'company_name': 'Stark Industries',
    'num_employees': 5215,
    'country': 'USA',
    'location': [49.1996961, 7.6087847] // PS
  },
  {
    'id': '125',
    'company_name': 'Acme Corp',
    'num_employees': 1002,
    'country': 'France',
    'location': [49.1996961, 7.6087847] // PS
  },
  {
    'id': '127',
    'company_name': 'Stark Corp',
    'num_employees': 1031,
    'country': 'USA',
    'location': [49.1711784, 7.6545316] // Lemberg
  },
  {
    'id': '126',
    'company_name': 'Doofenshmirtz Inc',
    'num_employees': 2,
    'country': 'Tri-State Area',
    'location': [49.1711784, 7.6545316] // Lemberg
  }
];

Future<void> importDocs(Client client) async {
  try {
    logInfoln(log, 'Importing documents into "companies" collection.');
    log.fine(
      await client.collection('companies').documents.importDocuments(_demoDocs),
    );
    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> create(Client client, [Schema? schema]) async {
  final _schema = Schema(
        'companies',
        {
          Field('company_name', type: Type.string),
          Field('num_employees', type: Type.int32),
          Field('location', type: Type.geopoint),
          Field('country', type: Type.string, isFacetable: true),
        },
        defaultSortingField: Field('num_employees', type: Type.int32),
      ),
      collectionName = schema == null ? 'companies' : schema.name;

  try {
    logInfoln(log, 'Creating "$collectionName" collection.');
    log.fine(await client.collections.create(schema ?? _schema));

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);

    if (e.runtimeType == ObjectAlreadyExists) {
      log.info('Collection "$collectionName" already exists, recreating it.');
      await delete(client, collectionName);
      await create(client, schema);
    }
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> delete(Client client,
    [String collectionName = 'companies']) async {
  try {
    logInfoln(log, 'Deleting "$collectionName" collection.');
    log.fine(await client.collection(collectionName).delete());

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving "companies" collection.');
    log.fine(await client.collection('companies').retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all collections.');
    log.fine(await client.collections.retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> update(Client client) async {
  try {
    logInfoln(log, 'Updating "companies" collection.');
    log.fine(
      await client.collection('companies').update(
            UpdateSchema(
              {
                UpdateField('company_category', type: Type.string),
                UpdateField('num_employees', shouldDrop: true)
              },
            ),
          ),
    );
    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
