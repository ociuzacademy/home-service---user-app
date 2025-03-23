// To parse this JSON data, do
//
//     final upidPaymentModel = upidPaymentModelFromJson(jsonString);

import 'dart:convert';

UpidPaymentModel upidPaymentModelFromJson(String str) => UpidPaymentModel.fromJson(json.decode(str));

String upidPaymentModelToJson(UpidPaymentModel data) => json.encode(data.toJson());

class UpidPaymentModel {
    String? message;
    String? totalAmount;
    Data? data;

    UpidPaymentModel({
        this.message,
        this.totalAmount,
        this.data,
    });

    factory UpidPaymentModel.fromJson(Map<String, dynamic> json) => UpidPaymentModel(
        message: json["message"],
        totalAmount: json["total_amount"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "total_amount": totalAmount,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? status;
    String? upiId;
    String? amount;
    int? booking;

    Data({
        this.id,
        this.status,
        this.upiId,
        this.amount,
        this.booking,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        upiId: json["upi_id"],
        amount: json["amount"],
        booking: json["booking"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "upi_id": upiId,
        "amount": amount,
        "booking": booking,
    };
}
