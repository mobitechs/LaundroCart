import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "login.dart";
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/constants.dart';

class forgot_Password extends StatefulWidget {
  @override
  _forgot_PasswordState createState() => _forgot_PasswordState();
}

class _forgot_PasswordState extends State<forgot_Password> {
  var _formKey = GlobalKey<FormState>();

  var isLoading = false;
  String email;
  String mobileNo;
  String passwdChange;
  String password;
  bool visible = false;
  String credError = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileNoController = TextEditingController();

  loadProgress(bool visiblity) {
    setState(() {
      visible = visiblity;
    });
  }

  proceedBtn() {
    if (email == "") {
      var passwdChange = "NEW_PASSWORD_SUCCESSFULLY_SET";
    } else if (password == "") {
      credError = "ENTER_VALID_CREDENTIALS";
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
        '{"method":"setNewPassword" ,"email":"$email","mobileNo":"$mobileNo","password":"$mobileNo"}';

    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('body' + bodyObj);
    var data = json.decode(res.body);

    // visible = false;
    // loadProgress(visible);
    if (data["Response"] == 'ENTER_VALID_CREDENTIALS') {
      //login failed
      print('ENTER_VALID_EMAIL/MOBILE');
      // isLogin = false;
      CommonMethods.showColoredToast("Enter Valid Credentials", Colors.red);
    } else {
      CommonMethods.showColoredToast("Password Change Successfully", Colors.blue);
      // isLogin = true;
      print('NEW_PASSWORD_SUCCESSFULLY_SET');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool(Constant.isLogin, true);
      pref.setString(
          Constant.userId, data["Response"][0]["userId"].toString());
      pref.setString(
          Constant.userType, data["Response"][0]["userType"].toString());
      pref.setString(
          Constant.name, data["Response"][0]["name"].toString());
      pref.setString(
          Constant.mobileNo, data["Response"][0]["mobileNo"].toString());
      pref.setString(
          Constant.emailId, data["Response"][0]["emailId"].toString());

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laundro Cart",
          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 50),
                    margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                    decoration: BoxDecoration(
                        // shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.cyan[900],
                        boxShadow: [
                          BoxShadow(
                            // offset: Offset(8, 8),
                            blurRadius: 20,
                            color: Colors.black,
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // labelText: AutofillHints,
                              hintText: "Enter Number",
                              labelText: "Phone Number"),
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter Phone Number";
                            }
                            return null;
                          },
                          controller: mobileNoController,
                        ),
                        textFormFields("Enter Email", "Please Enter Email",
                            "Email", emailController, false, TextInputType.emailAddress),
                        textFormFields("Enter Password", "Enter New Password",
                            "Password", passwordController, true, TextInputType.visiblePassword),
                        SizedBox(height: 15),
                        RaisedButton(
                          onPressed: () => proceedBtn(),
                          color: Colors.orangeAccent,
                          splashColor: Colors.deepOrange,
                          child: Text(
                            "Proceed",
                            style: raisedButtonStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
