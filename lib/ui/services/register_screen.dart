import 'package:flutter/material.dart';
import 'package:laundro_cart/constants.dart';
import 'shopkeeper_registration.dart';
import 'user_registration.dart';
import 'login.dart';

class Register_User extends StatefulWidget {
  @override
  Register_UserState createState() => Register_UserState();
}

class Register_UserState extends State<Register_User> {
  Widget imageOnScreen(String imgName) {
    return Expanded(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Image.asset("assets/images/$imgName.png"),
      ),
    );
  }

  // buttonsOnScreen(String textOnButtons) {
  //   RaisedButton(
  //     // onPressed: () {
  //     //   Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //       builder: (context) => shopkeeper_Registration(),
  //     //     ),
  //     //   );
  //     // },
  //     child: Text(
  //       "$textOnButtons",
  //       style: raisedButtonStyle,
  //     ),
  //     color: Colors.redAccent,
  //   );
  // }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Center(child:
                Text("Laundro Cart",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontStyle: FontStyle.italic,
                ),)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.cyan[900],
                    borderRadius: BorderRadius.circular(20),
                    // shape: BoxShape.circle
                    // backgroundBlendMode: BlendMode.lighten
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2 , 3),
                        blurRadius: 15,

                      )
                    ]
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Who Are You?",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          imageOnScreen("seller"),
                          imageOnScreen("people"),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      shopkeeper_Registration(),
                                ),
                              );
                            },
                            child: Text(
                              "ShopKeeper",
                              style: raisedButtonStyle,
                            ),
                            color: Colors.black,
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => user_Registeration(),
                                ),
                              );
                            },
                            child: Text(
                              "Local User",
                              style: raisedButtonStyle,
                            ),
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Go Back",
                          style: raisedButtonStyle,
                        ),
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
