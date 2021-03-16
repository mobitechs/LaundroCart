import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const raisedButtonStyle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

const appBarStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0);

Widget appBar(Widget widget) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Laundro Cart",
        style: TextStyle(
            fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 25),
      ),
    ),
    body: widget,
  );
}

class Constant {
  static String clientBusinessId = "1";
  static String url = "https://mobitechs.in/laundryCart/api/laundroCart.php";

  // static String imgUrl = "http://mobitechs.in/KisanFreashAPI/images/";



  static String ownerName = "Pratik";
  static String isLogin = "false";
  static String userId = "userId";
  static String userType = "userType";
  static String address = "address";
  static String name = "name";
  static String shopName = "shopName";
  static String mobileNo = "mobileNo";
  static String pincode = "pincode";
  static String latitude = "latitude";
  static String longitude = "longitude";
  static String emailId = "emailId";
  static String orderItemMsg = "orderItemMsg";
  static String orderTotalAmount = "orderTotalAmount";
  static String serviceName = "serviceName";
  static String itemName = "itemName";
  static String rate = "rate";
  static String serviceId = "serviceId";
  static String deliveryCharges = "30";
}

class CommonMethods {
  static void showColoredToast(String msg, Color red) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: red,
        textColor: Colors.white);
  }

  static bool checkLogin(SharedPreferences pref)  {
    bool isLogin = false;

    if (pref.getBool(Constant.isLogin) == true) {
      isLogin = true;
    } else {
      isLogin = false;
    }

    return isLogin;
  }
}

Future<String> getSharedPreference(String key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String value = pref.getString(key);
  return value;
}

// Future<bool> checkLogin(SharedPreferences pref) async {
//   bool isLogin = false;
//
//   if (pref.getBool("isLogin") == true) {
//     isLogin = true;
// // Navigator.of(context)
// //     .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
//   } else {
// // Navigator.of(context).pushReplacement(
// //     MaterialPageRoute(builder: (context) => LoginPage() //LoginPage
// //         ));
//     isLogin = false;
//   }
//   return isLogin;
// }

Widget textFormFields(
    String hint,
    String errorMsg,
    String labelText,
    TextEditingController myController,
    bool secureText,
    TextInputType typeofKey) {
  return TextFormField(
    // obscureText: true,
    decoration: InputDecoration(
      hintText: "$hint",
      labelText: "$labelText",
    ),
    keyboardType: typeofKey,
    obscureText: secureText,
    validator: (value) {
      if (value.isEmpty) {
        // ignore: missing_return
        return "$errorMsg";
      }
      return null;
    },
    controller: myController,
  );
}

Widget container({widget: Widget}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 20),
    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.cyan[900],
        boxShadow: [BoxShadow(offset: Offset(3, 3), blurRadius: 15)]),
    child: widget,
  );
}


