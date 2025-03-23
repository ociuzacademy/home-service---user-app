// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) => UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
    String? status;
    String? message;
    String? userId;
    Data? data;

    UserLoginModel({
        this.status,
        this.message,
        this.userId,
        this.data,
    });

    factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        status: json["status"],
        message: json["message"],
        userId: json["user_id"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user_id": userId,
        "data": data?.toJson(),
    };
}

class Data {
    String? email;
    String? password;

    Data({
        this.email,
        this.password,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
