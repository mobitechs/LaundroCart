import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/ui/home/home_screen.dart';
import 'package:laundro_cart/ui/shopkeeper/shopkeeper_dashboard.dart';
import 'forgot_password.dart';
import 'register_screen.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;

  String passwd;
  String email = "";
  String userLoginIdError = "";
  String password = "";
  String passwordError = "";
  bool visible = false;
  bool isLogin = false;
  String userType;
  String shopName = "";
  String mobileNo = "";
  String emailId = "";
  String serviceName = "";
  String itemName = "";
  String address = "";

  loadProgress(bool visiblity) {
    setState(() {
      visible = visiblity;
    });
  }

  bool checkValue = false;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
        getCredential();
  }

  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("name", email.toString());
      sharedPreferences.setString("password", password.toString());
      sharedPreferences.setString("shopName", shopName.toString());
      sharedPreferences.setString("mobileNo", mobileNo.toString());
      sharedPreferences.setString("emailId", emailId.toString());
      sharedPreferences.setString("serviceName", serviceName.toString());
      sharedPreferences.setString("itemName", itemName.toString());
      sharedPreferences.setString("address", address.toString());

      sharedPreferences.commit();
      getCredential();
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          email = sharedPreferences.getString("email");
          password = sharedPreferences.getString("password");
        }
      } else {
        checkValue = false;
      }
    });
  }

  _navigator() {
    if (email.toString().length != 0 || password.toString().length != 0) {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => new Home_Screen()),
              (Route<dynamic> route) => false);
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          child: new CupertinoAlertDialog(
            content: new Text(
              "name or password \ncan't be empty",
              style: new TextStyle(fontSize: 16.0),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("OK"))
            ],
          ));
    }
  }

  Future<void> _loginBtn() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', 'email');

    if (email == "") {
      CommonMethods.showColoredToast(
          "Please enter Email/Mobile No.", Colors.red);
    } else if (password == "") {
      CommonMethods.showColoredToast("Please enter Password.", Colors.red);
    } else {
      visible = true;
      loadProgress(visible);
      callLoginAPI();
    }
  }

  callLoginAPI() async {
    // clientBusinessId = Constant.clientBusinessId;
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"userLogin" ,"email":"$email","password":"$password"}';

    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('Login body' + bodyObj);
    var data = json.decode(res.body);

    visible = false;
    loadProgress(visible);
    if (data["Response"] == 'LOGIN_FAILED') {
      //login failed
      print('Customer Login Error');
      isLogin = false;
      CommonMethods.showColoredToast("Login Failed", Colors.red);
    } else {
      CommonMethods.showColoredToast("SUCCESS_LOGIN", Colors.blue);
      isLogin = true;
      print('Customer Login Success');
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


      if(pref.getString(Constant.userType) == "Customer") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Screen()));
      }
      else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Shopkeeper_Dashboard()));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[900],
                      boxShadow: [
                        BoxShadow(color: Theme
                            .of(context)
                            .hintColor
                            .withOpacity(0.2),
                            offset: Offset(2, 3),
                            blurRadius: 5)
                      ]
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Laundro Cart",
                        style: TextStyle(
                            fontSize: 35.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                onChanged: (text) {
                                  email = text;
                                },
                                autofocus: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                onChanged: (text) {
                                  password = text;
                                },
                                autofocus: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            // highlightColor: Colors.blue,
                            splashColor: Colors.blueGrey[900],

                            color: Colors.deepOrange[900],
                            onPressed: () => _loginBtn(),
                            child: Text("Login", style: raisedButtonStyle),
                          ),
                          RaisedButton(
                            splashColor: Colors.blueGrey[900],
                            color: Colors.deepOrange[900],
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register_User()));
                            },
                            child:
                            Text("Register User", style: raisedButtonStyle),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 15.0)),
                      InkWell(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => forgot_Password()));
                          }),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}


//   _getCategoryList() async {
//     SharedPreferences pref;
//     pref = await SharedPreferences.getInstance();
//
//
//     String clientBusinessId = Constant.clientBusinessId;
//
//     var res = await get(Constant.url + "?method=GetCategoryList&clientBusinessId=" + clientBusinessId);
//     var jsonObjRes = json.decode(res.body);
//     List<getShopList> listItems = [];
//     List<String> nameArray = [];
//     List<String> idArray = [];
//
//     if (jsonObjRes["Response"] == "LIST_NOT_AVAILABLE") {
//       CommonMethods.showColoredToast("Data Not Available.", Colors.red);
//     } else {
//       for (var u in jsonObjRes["Response"]) {
//         getShopList item =
//         getShopList(u["id"], u["shopName"], u["name"], u["mobile"], u["email"], u["address"], u["pincode"], u["shopImage"], u["latitude"], u["longitude"]);
// //getShopList(this.id, this.shopName, this.name, this.mobile, this.email,this.address,this.pincode,this.shopImage,this.latitude,this.longitude);
//
//
//         getShopList cm = getShopList.fromJson(u);
//         // print("Cmmmm:  " + json.encode(cm.toJson()));
//
//         listItems.add(item);
//         nameArray.add(item.name);
//         idArray.add(item.id);
//       }
//       pref.setStringList("nameArray", nameArray);
//       pref.setStringList("idArray", idArray);
//       // pref.setString("categoryList", json.encode(listItems));
//     }
//   }
// }