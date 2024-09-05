class EventModel {
  String? status;
  String? message;
  List<Data>? eventData;

  EventModel({this.status, this.message, this.eventData});

  EventModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      eventData = <Data>[];
      json['data'].forEach((v) {
        eventData!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (eventData != null) {
      data['data'] = eventData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? eventId;
  String? eventDescription;
  String? eventImage;

  Data({this.eventId, this.eventDescription, this.eventImage});

  Data.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventDescription = json['event_description'];
    eventImage = json['event_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event_id'] = eventId;
    data['event_description'] = eventDescription;
    data['event_image'] = eventImage;
    return data;
  }
}
