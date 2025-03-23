import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/service_provider_list/model/provider_list_model.dart';
import 'package:http/http.dart' as http;

Future<ServiceProviderList> providerService({
    required String latitude,
  required String longitude,
  required String service_id,
}
  
) async {
  try {
     Map<String, dynamic> params = {
      "latitude": latitude,
      "longitude": longitude,
      "service": service_id,
     };

    final resp = await http.get(
      Uri.parse(UserUrl.providers).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (resp.statusCode == 200) {

      final dynamic decoded = jsonDecode(resp.body);
      final response = ServiceProviderList.fromJson(decoded);
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