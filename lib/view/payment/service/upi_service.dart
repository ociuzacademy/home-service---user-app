import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/payment/model/upi_model.dart';
import 'package:http/http.dart' as http;

Future<UpidPaymentModel> gpayService({
  required String upi_id,
  required String booking_id,
}) async {
  try {
    //String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> param = {
      "upi_id": upi_id,
      "booking_id": booking_id,
    };

    final resp = await http.post(
      Uri.parse(UserUrl.upipayment),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = UpidPaymentModel.fromJson(decoded);

      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(resp.body);
      throw Exception(
        '${errorResponse['message'] ?? 'Unknown error'}',
      );
    }
  } on SocketException {
    throw Exception('No Internet connection');
  } on HttpException {
    throw Exception('Server error');
  } on FormatException {
    throw Exception('Bad response format');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
}
