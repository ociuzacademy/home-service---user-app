// To parse this JSON data, do
//
//     final completedServiceModel = completedServiceModelFromJson(jsonString);

import 'dart:convert';

CompletedServiceModel completedServiceModelFromJson(String str) => CompletedServiceModel.fromJson(json.decode(str));

String completedServiceModelToJson(CompletedServiceModel data) => json.encode(data.toJson());

class CompletedServiceModel {
    String? status;
    String? message;
    Booking? booking;

    CompletedServiceModel({
        this.status,
        this.message,
        this.booking,
    });

    factory CompletedServiceModel.fromJson(Map<String, dynamic> json) => CompletedServiceModel(
        status: json["status"],
        message: json["message"],
        booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "booking": booking?.toJson(),
    };
}

class Booking {
    int? id;
    int? user;
    int? service;
    int? serviceProvider;
    int? slot;
    DateTime? bookingDate;
    String? status;

    Booking({
        this.id,
        this.user,
        this.service,
        this.serviceProvider,
        this.slot,
        this.bookingDate,
        this.status,
    });

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        user: json["user"],
        service: json["service"],
        serviceProvider: json["service_provider"],
        slot: json["slot"],
        bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "service": service,
        "service_provider": serviceProvider,
        "slot": slot,
        "booking_date": bookingDate?.toIso8601String(),
        "status": status,
    };
}
