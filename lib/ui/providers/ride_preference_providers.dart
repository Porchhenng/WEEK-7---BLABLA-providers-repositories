import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Fetch the past preferences when the provider is initialized
    _fetchPreferences();
  }

  // Getter for current preference
  RidePreference? get currentPreference => _currentPreference;

  // Getter for past preferences (from newest to oldest)
  List<RidePreference> get preferencesHistory => _pastPreferences.reversed.toList();

  // Method to set the current preference
  void setCurrentPreferrence(RidePreference? pref) {
    if (pref == null || pref == _currentPreference) {
      return; // Only update if the preference is different from the current one
    }
    
    // Step 1: Update the current preference
    _currentPreference = pref;

    // Step 2: Add the preference to history, ensuring uniqueness
    _addPreference(pref);

    // Step 3: Save the preference using the repository
    repository.savePreference(pref);

    // Step 4: Notify listeners
    notifyListeners();
  }

  // Method to add a new preference to history, ensuring no duplicates
  void _addPreference(RidePreference preference) {
    // Check if the preference already exists in the history to ensure uniqueness
    if (!_pastPreferences.contains(preference)) {
      _pastPreferences.add(preference);
    }
  }

  // Fetch past preferences from the repository
  Future<void> _fetchPreferences() async {
    try {
      _pastPreferences = await repository.fetchPastPreferences();
      notifyListeners(); // Notify listeners once preferences are fetched
    } catch (e) {
      print(e);
    }
  }
}
