import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/subservice_view/model/subcategory_model.dart';
import 'package:http/http.dart' as http;

Future<List<SubCategoryModel>> subServiceList({
  required String category_id,
}) async {
  try {
    Map<String, dynamic> params = {
      'category_id': category_id,
    };
    final resp = await http.get(
      Uri.parse(UserUrl.subCategory).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    final List<dynamic> decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final response =
          decoded.map((item) => SubCategoryModel.fromJson(item)).toList();
      return response;
    } else {
      throw Exception('Failed to load response');
    }
  } on SocketException {
    throw Exception('Server error');
  } on HttpException {
    throw Exception('Something went wrong');
  } on FormatException {
    throw Exception('Bad request');
  } catch (e) {
    throw Exception(e.toString());
  }
}
