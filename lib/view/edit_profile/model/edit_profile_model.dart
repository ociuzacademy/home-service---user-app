// To parse this JSON data, do
//
//     final editProfileService = editProfileServiceFromJson(jsonString);

import 'dart:convert';

EditProfileService editProfileServiceFromJson(String str) => EditProfileService.fromJson(json.decode(str));

String editProfileServiceToJson(EditProfileService data) => json.encode(data.toJson());

class EditProfileService {
    String detail;
    Service service;

    EditProfileService({
        required this.detail,
        required this.service,
    });

    factory EditProfileService.fromJson(Map<String, dynamic> json) => EditProfileService(
        detail: json["detail"],
        service: Service.fromJson(json["service"]),
    );

    Map<String, dynamic> toJson() => {
        "detail": detail,
        "service": service.toJson(),
    };
}

class Service {
    int id;
    String username;
    String email;
    String address;
    String password;
    String phone;

    Service({
        required this.id,
        required this.username,
        required this.email,
        required this.address,
        required this.password,
        required this.phone,
    });

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        address: json["address"],
        password: json["password"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "address": address,
        "password": password,
        "phone": phone,
    };
}
