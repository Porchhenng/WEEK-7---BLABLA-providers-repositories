import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:week_3_blabla_project/service/rides_service.dart';
import 'package:week_3_blabla_project/ui/providers/ride_preference_providers.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';


import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';

import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
/// The Ride Selection screen allows the user to select a ride once ride preferences have been defined.
/// The screen also allows the user to re-define the ride preferences and activate filters.
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

 
  RidePreference getCurrentPreference(BuildContext context) =>
      Provider.of<RidesPreferencesProvider>(context).currentPreference!;


  RideFilter currentFilter = RideFilter();

  List<Ride> getMatchingRides(BuildContext context) =>
      RidesService.instance.getRidesFor(getCurrentPreference(context), currentFilter);

  void onBackPressed(BuildContext context) {
   
    Navigator.of(context).pop();
  }

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
   
    Provider.of<RidesPreferencesProvider>(context, listen: false)
        .setCurrentPreferrence(newPreference);

   
  }

  void onPreferencePressed(BuildContext context) async {
  
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
         RidePrefModal(initialPreference: getCurrentPreference(context)),
      ),
    );

    if (newPreference != null) {

      Provider.of<RidesPreferencesProvider>(context, listen: false)
          .setCurrentPreferrence(newPreference);
    }
  }

  void onFilterPressed() {
    // Implement filter functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: getCurrentPreference(context),
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: getMatchingRides(context).length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: getMatchingRides(context)[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
