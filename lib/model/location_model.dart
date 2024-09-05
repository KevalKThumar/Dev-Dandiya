class Location {
  final String locationId;
  final String locationName;

  Location({required this.locationId, required this.locationName});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['location_id'],
      locationName: json['location_name'],
    );
  }
}
