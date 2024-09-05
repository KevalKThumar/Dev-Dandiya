class Message {
  String? status;
  String? message;
  List<Data>? data;

  Message({this.status, this.message, this.data});

  Message.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? whatsappId;
  String? whatsappType;
  String? whatsapp;

  Data({this.whatsappId, this.whatsappType, this.whatsapp});

  Data.fromJson(Map<String, dynamic> json) {
    whatsappId = json['whatsapp_id'];
    whatsappType = json['whatsapp_type'];
    whatsapp = json['whatsapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['whatsapp_id'] = whatsappId;
    data['whatsapp_type'] = whatsappType;
    data['whatsapp'] = whatsapp;
    return data;
  }
}
