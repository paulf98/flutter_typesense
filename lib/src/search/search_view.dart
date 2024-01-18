import 'package:flutter/material.dart';

import 'search_controller.dart';

class TSSearchView extends StatefulWidget {
  const TSSearchView({super.key, required this.controller});

  @override
  _TSSearchViewState createState() => _TSSearchViewState();

  static const routeName = '/search';

  final TSSearchController controller;
}

class _TSSearchViewState extends State<TSSearchView> {
  final TextEditingController _searchController = TextEditingController();

  // store the result of the search
  List<dynamic>? _searchResults;

  void _handleSearch(String query) async {
    // access the controller of the stateful widget
    var res = await widget.controller.searchCollection(_searchController.text);
    print(res);

    var hits = res['hits'];

    // map the documents inside the hits array to the list
    hits = hits
        .map((e) => {
              'company_name': e['document']['company_name'],
              'num_employees': e['document']['num_employees'],
              'country': e['document']['country'],
              'score': e['text_match_info']['score'],
              'distance': e['geo_distance_meters']['location']
            })
        .toList();
    setState(() {
      _searchResults = hits;
    });

    print(_searchResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              onSubmitted: _handleSearch,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleSearch(_searchController.text),
              child: Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults![index]['company_name']),
                    subtitle: Text("Score: " + _searchResults![index]['score']),
                    trailing: Text(
                        _searchResults![index]['distance'].toString() + "m"),
                  );
                },
              ),
            ),
          ],
          // show the result of the search
        ),
      ),
    );
  }
}
