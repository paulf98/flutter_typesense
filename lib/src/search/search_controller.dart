import 'package:flutter/material.dart';

import 'search_service.dart';

class TSSearchController with ChangeNotifier {
  TSSearchController(this._searchService);

  final TSSearchService _searchService;

  Future<void> init() async {
    await _searchService.init();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> searchCollection() async {
    await _searchService.searchCollection();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
