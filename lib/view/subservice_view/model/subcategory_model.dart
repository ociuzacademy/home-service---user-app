// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

List<SubCategoryModel> subCategoryModelFromJson(String str) => List<SubCategoryModel>.from(json.decode(str).map((x) => SubCategoryModel.fromJson(x)));

String subCategoryModelToJson(List<SubCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategoryModel {
    int? id;
    String? serviceName;

    SubCategoryModel({
        this.id,
        this.serviceName,
    });

    factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
        id: json["id"],
        serviceName: json["service_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_name": serviceName,
    };
}
