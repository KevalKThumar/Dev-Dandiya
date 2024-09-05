import 'package:dev_dandiya/const/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/location_model.dart';
import '../provider/location_provider.dart';
import 'text_style.dart';

Widget locationDropDown() {
  return Consumer<LocationProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColor.whiteColor,
          ),
        );
      }

      if (provider.locations.isEmpty) {
        return Center(
          child: Text(
            'No locations available.',
            style: myTextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColor.whiteColor,
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: DropdownButton<Location>(
          iconEnabledColor: const Color(0xff5f259e),
          iconDisabledColor: const Color(0xff5f259e),
          isExpanded: true,
          value: provider.selectedLocation ?? provider.locations.first,
          onChanged: (Location? newValue) {
            if (newValue != null) {
              provider.setSelectedLocation(newValue);
              initializeData(context);
            }
          },
          items: provider.locations.map((Location location) {
            return DropdownMenuItem<Location>(
              value: location,
              child: Text(
                location.locationName,
                style: myTextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff5F259E), // Menu item color
                ),
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return provider.locations.map((Location location) {
              return Text(
                location.locationName,
                style: myTextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColor.whiteColor, // Displayed value color
                ),
              );
            }).toList();
          },
        ),
      );
    },
  );
}
