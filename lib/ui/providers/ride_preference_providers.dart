import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/mock/mock_locations_repository.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> _pastPreferences;
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
  // Initially loading
    fetchPastPreferences();
  }


  // Getter for current preference
  RidePreference? get currentPreference => _currentPreference;

  // Getter for past preferences (from newest to oldest)
  AsyncValue<List<RidePreference>> get preferencesHistory => _pastPreferences;

  // Method to set the current preference
  void setCurrentPreferrence(RidePreference? pref) {
    if (pref == null || pref == _currentPreference) {
      return; // Only update if the preference is different from the current one
    }
    
    // Step 1: Update the current preference
    _currentPreference = pref;

    // Step 2: Add the preference to history, ensuring uniqueness
    addPreference(pref);

    // Step 3: Save the preference using the repository
    repository.addPreference(pref);

    // Step 4: Notify listeners
    notifyListeners();
  }

  // Method to add a new preference to history, ensuring no duplicates
  Future<void> addPreference(RidePreference pref) async {
    try {
      await repository.addPreference(pref);

      // Choose one of the approaches below:

      // Approach 1: Fetch the data again
      await fetchPastPreferences();
      notifyListeners();

      // Approach 2: Update the cache directly
      // pastPreferences.data?.add(pref);
      // notifyListeners();

    } catch (error) {
      _pastPreferences = AsyncValue.error(error);
      notifyListeners();
    }
  }

  // Fetch past preferences from the repository
  
 Future<void> fetchPastPreferences() async {
  _pastPreferences = AsyncValue.loading();
  notifyListeners();
    try {
      final prefs = await repository.fetchPastPreferences();
      if (prefs.isEmpty){
        _pastPreferences = AsyncValue.empty();
      }
      else{
        _pastPreferences = AsyncValue.success(prefs);
      }
      notifyListeners();
       // Notify listeners that the data has changed
    } catch (e) {
      _pastPreferences = AsyncValue.error(e);
    }
  }

  
}
