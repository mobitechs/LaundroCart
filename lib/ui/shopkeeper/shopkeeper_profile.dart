import 'package:flutter/material.dart';
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShopKeeper_Profile extends StatefulWidget {
  @override
  _ShopKeeper_ProfileState createState() => _ShopKeeper_ProfileState();
}

class _ShopKeeper_ProfileState extends State<ShopKeeper_Profile> {

  // Future<Map<String, String>> pref =  getSharedPreference();
  // var shopName = getSharedPreference().then((value) => "ShopName");
  // var mobile = getSharedPreference().then((value) => "Mobile");
  // var email = getSharedPreference().then((value) => "Email");
  String shopName = "";
  String mobile = "";
  String email = "";

  Widget container(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFF0A0E21),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$text",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getSharedPreference(Constant.shopName).then((value) => setState(() {shopName = value;}));
    getSharedPreference(Constant.mobileNo).then((value) => setState(() {mobile = value;}));
    getSharedPreference(Constant.emailId).then((value) => setState(() {email = value;}));
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/press.jpg"))),
          ),
          container(shopName),
          container(mobile),
          container(email),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}

