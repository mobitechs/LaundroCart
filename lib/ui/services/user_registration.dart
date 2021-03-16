import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart';
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/ui/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class user_Registeration extends StatefulWidget {
  @override
  _user_RegisterationState createState() =>
      _user_RegisterationState();
}

class _user_RegisterationState extends State<user_Registeration> {
  String name = "",
      mobile = "",
      email = "",
      password = "",
      address = "",
      pinCode = "",
      latitude = "",
      longitude = "",
      userType = "Customer";

  @override
  void initState() {
    super.initState();
  }

  var isLoading = false;

  Future<void> _registerButton() async {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;
    latitude = first.coordinates.latitude.toString();
    longitude = first.coordinates.longitude.toString();

    if (name == "") {
      CommonMethods.showColoredToast("Please enter name.", Colors.red);
    } else if (mobile == "") {
      CommonMethods.showColoredToast("Enter enter mobile", Colors.red);
    } else if (email == "") {
      CommonMethods.showColoredToast("Enter enter email.", Colors.red);
    } else if (password == "") {
      CommonMethods.showColoredToast(
          "Enter confirm password.", Colors.red);
    } else if (address == "") {
      CommonMethods.showColoredToast("Please enter address", Colors.red);
    } else if (pinCode == "") {
      CommonMethods.showColoredToast("Please enter pinCode", Colors.red);
    } else {
      isLoading = true;
      loadProgress(isLoading);
      callAPI();
    }
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  callAPI() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"userRegister","name":"$name","mobile":"$mobile","email":"$email","address":"$address","password":"$password","pinCode":"$pinCode","latitude":"$latitude","longitude":"$longitude", "userType":"Customer"}';

    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('Register body' + bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'REGISTRATION_FAILED') {
      //login failed
      print('User Register Error');
      CommonMethods.showColoredToast("Registration Failed", Colors.red);
    } else if (data["Response"] == 'Email_Is_Already_Registered') {
      //login failed
      print('User Register Error');
      CommonMethods.showColoredToast(
          "You are already registered with us", Colors.red);
    } else {
      CommonMethods.showColoredToast("Registration Successful", Colors.blue);
      print('User Register success');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(Constant.isLogin, true);
      pref.setString(
          Constant.userId, data["Response"][0]["id"].toString());
      pref.setString(
          Constant.userType, data["Response"][0]["userType"].toString());
      pref.setString(
          Constant.name, data["Response"][0]["name"].toString());
      pref.setString(
          Constant.address, data["Response"][0]["address"].toString());
      pref.setString(
          Constant.mobileNo, data["Response"][0]["mobile"].toString());
      pref.setString(
          Constant.emailId, data["Response"][0]["email"].toString());
      pref.setString(
          Constant.shopName, data["Response"][0]["shopName"].toString());

      pref.setString(
          Constant.pincode, data["Response"][0]["pincode"].toString());

      pref.setString(
          Constant.latitude, data["Response"][0]["latitude"].toString());

      pref.setString(
          Constant.longitude, data["Response"][0]["longitude"].toString());


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Home_Screen()),
          ModalRoute.withName('/'));
    }
    loadProgress(false);  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Laundro Cart",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true),
//      resizeToAvoidBottomPadding: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  container(
                    widget: Column(children: <Widget>[
                      Text(
                        "User Registration",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.only(left: 50.0, right: 50.0, top: 25),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              onChanged: (text) {
                                name = text;
                              },
                              autofocus: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText: 'name',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (text) {
                                mobile = text;
                              },
                              autofocus: false,
                              autocorrect: false,
                              maxLength: 10,
                                keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Mobile',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (text) {
                                email = text;
                              },
                              autofocus: false,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (text) {
                                address = text;
                              },
                              autofocus: false,
                              maxLength: 70,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (text) {
                                pinCode = text;
                              },
                              autofocus: false,
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Pin Code',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (text) {
                                password = text;
                              },
                              autofocus: false,
                              autocorrect: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(height: 10),

                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            Center(
                              child: RaisedButton(
                                color: Colors.deepOrange[900],
                                splashColor: Colors.blueGrey[900],
                                onPressed: () => _registerButton(),
                                child: Text(
                                  " Register ",
                                  style: raisedButtonStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
