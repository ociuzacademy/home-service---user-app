// To parse this JSON data, do
//
//     final serviceProviderList = serviceProviderListFromJson(jsonString);

import 'dart:convert';

ServiceProviderList serviceProviderListFromJson(String str) => ServiceProviderList.fromJson(json.decode(str));

String serviceProviderListToJson(ServiceProviderList data) => json.encode(data.toJson());

class ServiceProviderList {
    String? status;
    List<ServiceProvider>? serviceProviders;

    ServiceProviderList({
        this.status,
        this.serviceProviders,
    });

    factory ServiceProviderList.fromJson(Map<String, dynamic> json) => ServiceProviderList(
        status: json["status"],
        serviceProviders: json["service_providers"] == null ? [] : List<ServiceProvider>.from(json["service_providers"]!.map((x) => ServiceProvider.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "service_providers": serviceProviders == null ? [] : List<dynamic>.from(serviceProviders!.map((x) => x.toJson())),
    };
}

class ServiceProvider {
    int? id;
    String? username;
    String? email;
    String? phone;
    double? latitude;
    double? longitude;
    double? distanceKm;
    int? price;
    String? image;

    ServiceProvider({
        this.id,
        this.username,
        this.email,
        this.phone,
        this.latitude,
        this.longitude,
        this.distanceKm,
        this.price,
        this.image,
    });

    factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        distanceKm: json["distance_km"]?.toDouble(),
        price: json["price"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude,
        "distance_km": distanceKm,
        "price": price,
        "image": image,
    };
}
