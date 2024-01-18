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
    // Implement what should happen when the search button is pressed
    print('Searching for: ${_searchController.text}');

    // access the controller of the stateful widget
    var res = await widget.controller.searchCollection(_searchController.text);
    var hits = res['hits'];

    // map the documents inside the hits array to the list
    hits = hits.map((e) => e['document']).toList();
    setState(() {
      _searchResults = hits;
    });

    print('Search results: $_searchResults');
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
