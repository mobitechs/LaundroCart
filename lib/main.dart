import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundro_cart/ui/home/home_screen.dart';
import 'package:laundro_cart/ui/home/new_home.dart';
import 'package:laundro_cart/ui/services/login.dart';
import 'package:laundro_cart/ui/shopkeeper/shopkeeper_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Laundro Cart",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey[900],

        // backgroundColor: Colors.lightBlue[900]
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
      afterFinished,
    );
  }

  void afterFinished() async {
  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Shopkeeper_Dashboard()));
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool isLoggedIn = CommonMethods.checkLogin(pref);
    if (isLoggedIn == true) {
      if(pref.getString(Constant.userType) == "Customer") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home_Screen()));
      }
      else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Shopkeeper_Dashboard()));
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text(
            'Laundro Cart',
            style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          ),
        ],
      ),
    );
  }
}
