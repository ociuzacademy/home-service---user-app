// To parse this JSON data, do
//
//     final bookedServiceModel = bookedServiceModelFromJson(jsonString);

import 'dart:convert';

List<BookedServiceModel> bookedServiceModelFromJson(String str) => List<BookedServiceModel>.from(json.decode(str).map((x) => BookedServiceModel.fromJson(x)));

String bookedServiceModelToJson(List<BookedServiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookedServiceModel {
    int? id;
    ServiceDetails? serviceDetails;
    String? slotStartTime;
    String? platformFee;
    String? slotEndTime;
    DateTime? bookingDate;
    String? status;

    BookedServiceModel({
        this.id,
        this.serviceDetails,
        this.slotStartTime,
        this.platformFee,
        this.slotEndTime,
        this.bookingDate,
        this.status,
    });

    factory BookedServiceModel.fromJson(Map<String, dynamic> json) => BookedServiceModel(
        id: json["id"],
        serviceDetails: json["service_details"] == null ? null : ServiceDetails.fromJson(json["service_details"]),
        slotStartTime: json["slot_start_time"],
        platformFee: json["platform_fee"],
        slotEndTime: json["slot_end_time"],
        bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_details": serviceDetails?.toJson(),
        "slot_start_time": slotStartTime,
        "platform_fee": platformFee,
        "slot_end_time": slotEndTime,
        "booking_date": bookingDate?.toIso8601String(),
        "status": status,
    };
}

class ServiceDetails {
    int? id;
    int? serviceId;
    String? serviceName;
    String? price;

    ServiceDetails({
        this.id,
        this.serviceId,
        this.serviceName,
        this.price,
    });

    factory ServiceDetails.fromJson(Map<String, dynamic> json) => ServiceDetails(
        id: json["id"],
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "service_name": serviceName,
        "price": price,
    };
}
