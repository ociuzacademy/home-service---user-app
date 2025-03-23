// To parse this JSON data, do
//
//     final feedbackModel = feedbackModelFromJson(jsonString);

import 'dart:convert';

FeedbackModel feedbackModelFromJson(String str) => FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

class FeedbackModel {
    String? status;
    String? message;
    Data? data;

    FeedbackModel({
        this.status,
        this.message,
        this.data,
    });

    factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? user;
    String? booking;
    String? reviewText;
    int? rating;
    DateTime? createdAt;

    Data({
        this.id,
        this.user,
        this.booking,
        this.reviewText,
        this.rating,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        user: json["user"],
        booking: json["booking"],
        reviewText: json["review_text"],
        rating: json["rating"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "booking": booking,
        "review_text": reviewText,
        "rating": rating,
        "created_at": createdAt?.toIso8601String(),
    };
}
