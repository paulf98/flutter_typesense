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

  void _handleSearch() {
    // Implement what should happen when the search button is pressed
    print('Searching for: ${_searchController.text}');

    // access the controller of the stateful widget
    widget.controller.searchCollection(_searchController.text);
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
              onPressed: _handleSearch,
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
