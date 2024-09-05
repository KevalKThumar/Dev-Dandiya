class PaymentListModel {
  String? status;
  String? message;
  List<Data>? data;

  PaymentListModel({this.status, this.message, this.data});

  PaymentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
  String? studentPaymentId;
  String? studentId;
  String? locationId;
  String? studentSession;
  String? studentType;
  String? paymentType;
  String? paymentMethod;
  String? paymentAmount;
  String? paymentDate;

  Data(
      {this.studentPaymentId,
      this.studentId,
      this.locationId,
      this.studentSession,
      this.studentType,
      this.paymentType,
      this.paymentMethod,
      this.paymentAmount,
      this.paymentDate});

  Data.fromJson(Map<String, dynamic> json) {
    studentPaymentId = json['student_payment_id'];
    studentId = json['student_id'];
    locationId = json['location_id'];
    studentSession = json['student_session'];
    studentType = json['student_type'];
    paymentType = json['payment_type'];
    paymentMethod = json['payment_method'];
    paymentAmount = json['payment_amount'];
    paymentDate = json['payment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_payment_id'] = studentPaymentId;
    data['student_id'] = studentId;
    data['location_id'] = locationId;
    data['student_session'] = studentSession;
    data['student_type'] = studentType;
    data['payment_type'] = paymentType;
    data['payment_method'] = paymentMethod;
    data['payment_amount'] = paymentAmount;
    data['payment_date'] = paymentDate;
    return data;
  }
}
