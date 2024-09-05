class SearchModel {
  String? status;
  String? message;
  List<Data>? data;

  SearchModel({this.status, this.message, this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
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
  String? studentId;
  String? studentName;
  String? studentProfile;
  String? studentMobile;
  String? studentGender;
  String? studentCode;
  Null? studentCodeValue;
  String? studentSession;
  String? studentLocation;

  Data(
      {this.studentId,
      this.studentName,
      this.studentProfile,
      this.studentMobile,
      this.studentGender,
      this.studentCode,
      this.studentCodeValue,
      this.studentSession,
      this.studentLocation});

  Data.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    studentName = json['student_name'];
    studentProfile = json['student_profile'];
    studentMobile = json['student_mobile'];
    studentGender = json['student_gender'];
    studentCode = json['student_code'];
    studentCodeValue = json['student_code_value'];
    studentSession = json['student_session'];
    studentLocation = json['student_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['student_name'] = studentName;
    data['student_profile'] = studentProfile;
    data['student_mobile'] = studentMobile;
    data['student_gender'] = studentGender;
    data['student_code'] = studentCode;
    data['student_code_value'] = studentCodeValue;
    data['student_session'] = studentSession;
    data['student_location'] = studentLocation;
    return data;
  }
}
