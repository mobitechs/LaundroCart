//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundro_cart/ui/services/login.dart';
//import 'package:online_laundry/ui.services/login.dart';
import 'package:laundro_cart/constants.dart';
import 'package:fancy_drawer/fancy_drawer.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.edit, semanticLabel: "Edit"),
          //   onPressed: () {
          //     setState(() {
          //       print("Icon Button Tapped");
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          container("User Name"),
          container("Mobile Number"),
          container("Email"),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: Colors.redAccent,
                splashColor: Colors.blueGrey[900],
                onPressed: () {
                  // Navigator.of(context)
                  //     .pushReplacementNamed('/LoginScreen');
                },
                child: Text("LogOut", style: raisedButtonStyle),
              ),
              RaisedButton(
                color: Colors.red[800],
                splashColor: Colors.blueGrey[900],
                onPressed: () {
                  // Navigator.of(context)
                  //     .pushReplacementNamed('/LoginScreen');
                },
                child: Text("LogOut", style: raisedButtonStyle),
              )
            ],
          ),
        ],
      ),
    );
  }
}
