import 'dart:async';

import 'package:http/http.dart';
import 'package:laundro_cart/model/user_details.dart';
import 'package:laundro_cart/network/api_client.dart';
import 'package:laundro_cart/utilities/RequestType.dart';

class RemoteDataSource {
  APIClient client;

  void init() {
    client = APIClient(Client());
  }

  Future<String> register(dynamic data) async {
    try {
      final response = await client.request(RequestType.POST, data);
      if (response.statusCode == 200) {
        return "Registered";
      } else {
        return "Not Registered";
      }
    } catch (error) {
      return throw Exception(error);
    }
  }
}