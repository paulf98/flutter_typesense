import 'package:flutter/material.dart';
import 'package:flutter_typesense/src/search/search_controller.dart';
import 'package:flutter_typesense/src/search/search_service.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());
  final searchController = TSSearchController(TSSearchService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    searchController: searchController,
  ));

  // needs to come after runApp was called
  await searchController.init();
}
