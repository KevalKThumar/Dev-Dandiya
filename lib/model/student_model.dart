class Student {
  final String studentName;
  final String studentMobile;
  final String studentGender;
  final String studentCode;
  final String studentSession;
  final String studentLocation;
  final String studentProfile;
  final String? studentDate;

  Student(this.studentDate, {
    required this.studentName,
    required this.studentMobile,
    required this.studentGender,
    required this.studentCode,
    required this.studentSession,
    required this.studentLocation,
    required this.studentProfile,
    
  });

  Map<String, dynamic> toJson() {
    return {
      'student_name': studentName,
      'student_mobile': studentMobile,
      'student_gender': studentGender,
      'student_code': studentCode,
      'student_session': studentSession,
      'student_location': studentLocation,
      'student_date': studentDate,
      'student_profile': studentProfile, // file path
    };
  }

  @override
  String toString() {
    return 'Student(studentName: $studentName, studentMobile: $studentMobile, studentGender: $studentGender, studentCode: $studentCode, studentSession: $studentSession, studentLocation: $studentLocation, studentProfile: $studentProfile)';
  }
}
