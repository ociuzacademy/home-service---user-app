// To parse this JSON data, do
//
//     final userRegistrationModel = userRegistrationModelFromJson(jsonString);

import 'dart:convert';

UserRegistrationModel userRegistrationModelFromJson(String str) => UserRegistrationModel.fromJson(json.decode(str));

String userRegistrationModelToJson(UserRegistrationModel data) => json.encode(data.toJson());

class UserRegistrationModel {
    String? status;
    String? message;
    Data? data;

    UserRegistrationModel({
        this.status,
        this.message,
        this.data,
    });

    factory UserRegistrationModel.fromJson(Map<String, dynamic> json) => UserRegistrationModel(
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
    String? username;
    String? email;
    String? address;
    String? password;
    String? phone;

    Data({
        this.id,
        this.username,
        this.email,
        this.address,
        this.password,
        this.phone,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
