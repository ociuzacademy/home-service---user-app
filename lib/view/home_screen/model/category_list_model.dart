// To parse this JSON data, do
//
//     final categoryListModel = categoryListModelFromJson(jsonString);

import 'dart:convert';

List<CategoryListModel> categoryListModelFromJson(String str) => List<CategoryListModel>.from(json.decode(str).map((x) => CategoryListModel.fromJson(x)));

String categoryListModelToJson(List<CategoryListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryListModel {
    int? id;
    String? category;

    CategoryListModel({
        this.id,
        this.category,
    });

    factory CategoryListModel.fromJson(Map<String, dynamic> json) => CategoryListModel(
        id: json["id"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
    };
}
