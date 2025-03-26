import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:week_3_blabla_project/service/locations_service.dart';
import 'package:week_3_blabla_project/service/rides_service.dart';
import 'package:week_3_blabla_project/ui/providers/ride_preference_providers.dart';
import 'data/repository/mock/mock_locations_repository.dart';
import 'data/repository/mock/mock_rides_repository.dart';

import 'data/repository/mock/mock_ride_preferences_repository.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';

import 'ui/theme/theme.dart';

void main() {

    LocationsService.initialize(MockLocationsRepository());
  RidesService.initialize(MockRidesRepository());

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider<RidesPreferencesProvider>(
          create: (_) => RidesPreferencesProvider(repository: MockRidePreferencesRepository()),
        ),
       
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Scaffold(body: RidePrefScreen()), 
      ),
    );
  }
}
