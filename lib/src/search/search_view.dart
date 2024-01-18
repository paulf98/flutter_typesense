import 'package:flutter/material.dart';

import 'search_controller.dart';

class TSSearchView extends StatelessWidget {
  const TSSearchView({super.key, required this.controller});

  static const routeName = '/search';

  final TSSearchController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:
            // add a button that calls the search controller's search method
            ButtonBar(
          children: [
            ElevatedButton(
              onPressed: () {
                controller.searchCollection();
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
