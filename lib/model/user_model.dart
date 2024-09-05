class UserModel {
  String? status;
  String? message;
  Data? data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? adminId;
  String? adminUsername;
  String? adminPassword;
  String? adminStatus;

  Data(
      {this.adminId, this.adminUsername, this.adminPassword, this.adminStatus});

  Data.fromJson(Map<String, dynamic> json) {
    adminId = json['admin_id'];
    adminUsername = json['admin_username'];
    adminPassword = json['admin_password'];
    adminStatus = json['admin_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin_id'] = adminId;
    data['admin_username'] = adminUsername;
    data['admin_password'] = adminPassword;
    data['admin_status'] = adminStatus;
    return data;
  }
}
