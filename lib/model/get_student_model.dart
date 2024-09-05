class GetStudent {
  String? status;
  String? message;
  int? totalMale;
  int? totalFemale;
  List<Data>? data;
  List<Data>? maleStudents;
  List<Data>? femaleStudents;

  GetStudent(
      {this.status,
      this.message,
      this.totalMale,
      this.totalFemale,
      this.data,
      this.maleStudents,
      this.femaleStudents});

  GetStudent.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalMale = json['total_male'];
    totalFemale = json['total_female'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    if (json['male_students'] != null) {
      maleStudents = <Data>[];
      json['male_students'].forEach((v) {
        maleStudents!.add(Data.fromJson(v));
      });
    }
    if (json['female_students'] != null) {
      femaleStudents = <Data>[];
      json['female_students'].forEach((v) {
        femaleStudents!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_male'] = totalMale;
    data['total_female'] = totalFemale;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (maleStudents != null) {
      data['male_students'] =
          maleStudents!.map((v) => v.toJson()).toList();
    }
    if (femaleStudents != null) {
      data['female_students'] =
          femaleStudents!.map((v) => v.toJson()).toList();
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
  String? studentSession;
  String? studentLocation;

  Data(
      {this.studentId,
      this.studentName,
      this.studentProfile,
      this.studentMobile,
      this.studentGender,
      this.studentCode,
      this.studentSession,
      this.studentLocation});

  Data.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    studentName = json['student_name'];
    studentProfile = json['student_profile'];
    studentMobile = json['student_mobile'];
    studentGender = json['student_gender'];
    studentCode = json['student_code'];
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
    data['student_session'] = studentSession;
    data['student_location'] = studentLocation;
    return data;
  }
}


