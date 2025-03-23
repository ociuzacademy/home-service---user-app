// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    int? id;
    String? username;
    String? email;
    String? address;
    String? password;
    String? phone;

    UserProfileModel({
        this.id,
        this.username,
        this.email,
        this.address,
        this.password,
        this.phone,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
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
