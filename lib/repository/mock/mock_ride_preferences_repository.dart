import '../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

import '../../dummy_data/dummy_data.dart';


class MockRidePreferencesRepository implements RidePreferencesRepository {
  final List<RidePreference> _pastPreferences = [];

  @override
  Future<List<RidePreference>> fetchPastPreferences() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating delay
    return _pastPreferences;
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating delay
    _pastPreferences.add(preference);
  }
  
  

  
}
