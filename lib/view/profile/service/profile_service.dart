import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/profile/model/profile_model.dart';
import 'package:http/http.dart' as http;

Future<UserProfileModel> userProfileService() async {
  try {
    //final user_id =int.parse("2");
   // String userId = await PreferenceValues.getUserId();

    Map<String, dynamic> params = {
      //'id': userId.toString(),
      'id' : 7.toString(),
    };

    final resp = await http.get(
      Uri.parse(UserUrl.profile).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    //final List<dynamic> decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = UserProfileModel.fromJson(decoded);
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
