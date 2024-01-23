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

    // print(res);
    var hits = res['results'][0]['hits'];
    print(hits);

    // // map the documents inside the hits array to the list
    hits = hits
        .map((e) => {
              'company_name': e['document']['company_name'],
              'vector_distance': e['vector_distance'],
            })
        .toList();
    setState(() {
      _searchResults = hits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Demo'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Container(
              alignment: Alignment.topCenter,
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _searchController,
                    onSubmitted: _handleSearch,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleSearch(_searchController.text),
                    child: const Text('Search'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_searchResults![index]['company_name']),
                          subtitle: Text("Vec Dist: " +
                              _searchResults![index]['vector_distance']
                                  .toString()),
                          // trailing: Text(
                          //     _searchResults![index]['distance'].toString() + "m"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ))));
  }
}
