import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart';
import 'package:laundro_cart/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return appBar(Edit_Profile_Screen());
  }
}

class Edit_Profile_Screen extends StatefulWidget {
  @override
  _Edit_Profile_ScreenState createState() => _Edit_Profile_ScreenState();
}

class _Edit_Profile_ScreenState extends State<Edit_Profile_Screen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNumController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  SharedPreferences pref;
  String name = "",
      userId = "",
      shopName = "",
      mobile = "",
      email = "",
      password = "",
      address = "",
      pinCode = "",
      latitude = "",
      longitude = "";

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
  }

  getSharedPrefData() async {
    pref = await SharedPreferences.getInstance();
    userId = pref.getString(Constant.userId);
    name = pref.getString(Constant.name);
    email = pref.getString(Constant.emailId);
    mobile = pref.getString(Constant.mobileNo);
    address = pref.getString(Constant.address);
    pinCode = pref.getString(Constant.pincode);

    nameController = new TextEditingController(text: name);
    emailIdController = new TextEditingController(text: email);
    mobileNumController = new TextEditingController(text: mobile);
    addressController = new TextEditingController(text: address);
    pincodeController = new TextEditingController(text: pinCode);

    setState(() {});
  }

  var isLoading = false;

  Future<void> _registerButton() async {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;
    latitude = first.coordinates.latitude.toString();
    longitude = first.coordinates.longitude.toString();

    if (name == "") {
      CommonMethods.showColoredToast("Please enter name.", Colors.red);
    }  else if (mobile == "") {
      CommonMethods.showColoredToast("Enter enter mobile", Colors.red);
    } else if (email == "") {
      CommonMethods.showColoredToast("Enter enter email.", Colors.red);
    } else if (password == "") {
      CommonMethods.showColoredToast("Enter enter password.", Colors.red);
    } else if (address == "") {
      CommonMethods.showColoredToast("Please enter address", Colors.red);
    } else if (pinCode == "") {
      CommonMethods.showColoredToast("Please enter pin code", Colors.red);
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
        '{"method":"editProfileCustomer","userId":"$userId","name":"$name","mobile":"$mobile","email":"$email","address":"$address","password":"$password","pinCode":"$pinCode"}';

    print(bodyObj);
    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('Register body' + bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'UPDATE_FAILED') {
      CommonMethods.showColoredToast("Update Failed", Colors.red);
    } else {
      CommonMethods.showColoredToast("Update Successful", Colors.blue);

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(Constant.userId, data["Response"][0]["id"].toString());
      pref.setString(
          Constant.userType, data["Response"][0]["userType"].toString());
      pref.setString(Constant.name, data["Response"][0]["name"].toString());
      pref.setString(
          Constant.address, data["Response"][0]["address"].toString());
      pref.setString(
          Constant.mobileNo, data["Response"][0]["mobile"].toString());
      pref.setString(Constant.emailId, data["Response"][0]["email"].toString());
      pref.setString(
          Constant.shopName, data["Response"][0]["shopName"].toString());
      pref.setString(
          Constant.pincode, data["Response"][0]["pincode"].toString());

      pref.setString(
          Constant.latitude, data["Response"][0]["latitude"].toString());

      pref.setString(
          Constant.longitude, data["Response"][0]["longitude"].toString());

      setState(() {});
    }
    loadProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //       "Laundro Cart",
      //       style: TextStyle(
      //         fontSize: 30,
      //         fontWeight: FontWeight.w900,
      //       ),
      //     ),
      //     centerTitle: true),
//      resizeToAvoidBottomPadding: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  container(
                    widget: Column(children: <Widget>[
                      // Text(
                      //   "Shopkeeper Registration",
                      //   style: TextStyle(
                      //       fontSize: 22.0, fontWeight: FontWeight.bold),
                      // ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 50.0, right: 50.0, top: 25),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: nameController,
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
                              controller: mobileNumController,
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
                              controller: emailIdController,
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
                              controller: addressController,
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
                              controller: pincodeController,
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
                              obscureText: false,
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
                                  " Update ",
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
