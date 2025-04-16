import 'dart:convert';

List<ServiceHistoryModel> serviceHistoryModelFromJson(String str) =>
    List<ServiceHistoryModel>.from(
        json.decode(str).map((x) => ServiceHistoryModel.fromJson(x)));

String serviceHistoryModelToJson(List<ServiceHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceHistoryModel {
  int id;
  ServiceDetails serviceDetails;
  String slotStartTime;
  String slotEndTime;
  String platformFee;
  DateTime bookingDate;
  String status;

  ServiceHistoryModel({
    this.id = 0,
    ServiceDetails? serviceDetails,
    this.slotStartTime = '',
    this.slotEndTime = '',
    this.platformFee = '0.00',
    DateTime? bookingDate,
    this.status = '',
  })  : serviceDetails = serviceDetails ?? ServiceDetails(),
        bookingDate = bookingDate ?? DateTime.now();

  factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) =>
      ServiceHistoryModel(
        id: json["id"] ?? 0,
        serviceDetails: json["service_details"] == null
            ? ServiceDetails()
            : ServiceDetails.fromJson(json["service_details"]),
        slotStartTime: json["slot_start_time"] ?? '',
        slotEndTime: json["slot_end_time"] ?? '',
        platformFee: json["platform_fee"] ?? '0.00',
        bookingDate: json["booking_date"] == null
            ? DateTime.now()
            : DateTime.parse(json["booking_date"]),
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_details": serviceDetails.toJson(),
        "slot_start_time": slotStartTime,
        "slot_end_time": slotEndTime,
        "platform_fee": platformFee,
        "booking_date": bookingDate.toIso8601String(),
        "status": status,
      };
}

class ServiceDetails {
  int id;
  int serviceId;
  String serviceName;
  double price;

  ServiceDetails({
    this.id = 0,
    this.serviceId = 0,
    this.serviceName = '',
    this.price = 0.0,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) => ServiceDetails(
        id: json["id"] ?? 0,
        serviceId: json["service_id"] ?? 0,
        serviceName: json["service_name"] ?? '',
        price: (json["price"] is int)
            ? (json["price"] as int).toDouble()
            : json["price"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "service_name": serviceName,
        "price": price,
      };
}