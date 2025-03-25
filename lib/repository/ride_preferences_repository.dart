import '../model/ride/ride_pref.dart';

abstract class RidePreferencesRepository {
  List<RidePreference> fetchPastPreferences();

  void addPreference(RidePreference preference);

  Future<void> savePreference(RidePreference preference) async {
    //add save logic
  }
}
