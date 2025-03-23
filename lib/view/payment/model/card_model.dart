// To parse this JSON data, do
//
//     final cardPaymentModel = cardPaymentModelFromJson(jsonString);

import 'dart:convert';

CardPaymentModel cardPaymentModelFromJson(String str) => CardPaymentModel.fromJson(json.decode(str));

String cardPaymentModelToJson(CardPaymentModel data) => json.encode(data.toJson());

class CardPaymentModel {
    String? message;
    String? totalAmount;
    Data? data;

    CardPaymentModel({
        this.message,
        this.totalAmount,
        this.data,
    });

    factory CardPaymentModel.fromJson(Map<String, dynamic> json) => CardPaymentModel(
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
    String? cardHolderName;
    String? cardNumber;
    String? expiryDate;
    String? cvv;
    String? amount;
    int? booking;

    Data({
        this.id,
        this.status,
        this.cardHolderName,
        this.cardNumber,
        this.expiryDate,
        this.cvv,
        this.amount,
        this.booking,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        cardHolderName: json["card_holder_name"],
        cardNumber: json["card_number"],
        expiryDate: json["expiry_date"],
        cvv: json["cvv"],
        amount: json["amount"],
        booking: json["booking"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "card_holder_name": cardHolderName,
        "card_number": cardNumber,
        "expiry_date": expiryDate,
        "cvv": cvv,
        "amount": amount,
        "booking": booking,
    };
}
