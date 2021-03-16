import 'dart:convert';
import 'package:http/http.dart';
import 'package:laundro_cart/utilities/RequestType.dart';

class APIClient {

  static const String _baseUrl = "https://mobitechs.in/laundryCart/api/laundroCart.php";
  final Client _client;

  APIClient(this._client);      //constuctor

  Future<Response> request(RequestType requestType, dynamic parameter) async {
    switch (requestType) {
      case RequestType.GET:
        return _client.get("$_baseUrl");
      case RequestType.POST:
        return _client.post("$_baseUrl", body: parameter);
      case RequestType.PATCH:
        return _client.patch("$_baseUrl",
            headers: {"Content-Type": "application/json"}, body: json.encode(parameter));
      case RequestType.DELETE:
        return _client.delete("$_baseUrl");
      default:
        return throw Exception("The HTTP request method is not found");
    }
  }
}