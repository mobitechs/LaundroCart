//Data Model Class

import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserDetails {
  final String method;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String pinCode;
  final String password;
  final String latitude;
  final String longitude;
  final String userType;

  // Creating Constructor
  UserDetails({this.method, this.name, this.mobile, this.email, this.address, this.pinCode, this.password, this.latitude, this.longitude, this.userType});

  // factory constructors are used to prepare calculated values to forward them
  // as parameters to a normal constructor so that final fields can be initialized with them

  // factory UserDetails.fromRawJson(String str) => UserDetails.fromJson(json.decode(str));  //decode json


 // A User.fromJson() constructor, for constructing a new User instance from a map structure.
 //  factory UserDetails.fromJson(Map <String, dynamic> json) =>
 //      UserDetails(
 //        name: json["name"],
 //        mobile_number: json['mobile_number'],
 //        email: json["email"],
 //        address: json["address"],
 //        pin_code: json['pin_code'],
 //        password: json["password"],
 //      );

  //A toJson() method, which converts a User instance into a map.
  // Map<String, dynamic> toJson() =>
  //     {
  //       "name": name,
  //       "mobile_number": mobile_number,
  //       "email": email,
  //       "address": address,
  //       "pin_code": pin_code,
  //       "password": password,
  //     };
}























