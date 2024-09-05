class Session {
  String? status;
  String? message;
  List<Data>? data;

  Session({this.status, this.message, this.data});

  Session.fromJson(Map<String, dynamic> json) {
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
  String? sessionId;
  String? session;

  Data({this.sessionId, this.session});

  Data.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_id'] = sessionId;
    data['session'] = session;
    return data;
  }
}
