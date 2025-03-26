import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';
import 'package:week_3_blabla_project/ui/providers/ride_preference_providers.dart';
import 'package:week_3_blabla_project/ui/screens/rides/widgets/bla_error_screen%20(2).dart';

import '../../../model/ride/ride_pref.dart';

import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(BuildContext context, RidePreference? newPreference) async {
    // 1 - Call the RidesPreferencesProvider to set the current preference
    Provider.of<RidesPreferencesProvider>(context, listen: false)
        .setCurrentPreferrence(newPreference);

    // 2 - Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  @override
  Widget _buildPastPrefsList(BuildContext context) {
    RidesPreferencesProvider ridePrefsProvider =
        context.read<RidesPreferencesProvider>();
    AsyncValue<List<RidePreference>> value = ridePrefsProvider.preferencesHistory;

    // Check the state of the AsyncValue object
    switch (value.state) {
      case AsyncValueState.loading:
        return Text(' fetching data');
      case AsyncValueState.error:
        Navigator.push(context, MaterialPageRoute(builder: (context) => BlaError(message: 'error')));
        return Text('error no fetch');
      case AsyncValueState.success:
        return SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: value.data!.length,
            itemBuilder: (ctx, index) => RidePrefHistoryTile(
              ridePref: value.data![index],
              onPressed: () => onRidePrefSelected(context, value.data![index]),
            ),
          ),
        );
      case AsyncValueState.empty:
        return Text('empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RidesPreferencesProvider>(context);

 
    return Stack(
      children: [
        // 1 - Background Image
        const BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            // Ensure the container uses available space
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2.1 Display the Form to input the ride preferences
                    RidePrefForm(
                      initialPreference: provider.currentPreference,
                      onSubmit: (newPreference) =>
                          provider.setCurrentPreferrence(newPreference),
                    ),
                    SizedBox(height: BlaSpacings.m),

                    // Display the past preferences list
                    _buildPastPrefsList(context),
                    
                   
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
