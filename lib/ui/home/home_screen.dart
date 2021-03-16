import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:laundro_cart/ui/services/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'home.dart';
// import 'profile.dart';
import 'cart.dart';
import 'google_map.dart';
import 'package:badges/badges.dart';
import 'edit_profile.dart';
import 'new_home.dart';



class Home_Screen extends StatefulWidget {
  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen>
    with SingleTickerProviderStateMixin {

  SharedPreferences pref;
  String name = "";
  String email = "";
  String mobileNo = "";
  String shopName = "";


  static List<Widget> _myPages = <Widget>[Home(), Google_map()];
  // static List<Widget> _myPages = <Widget>[Home(), Google_map(), Profile()];


  commonTextStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  }

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 500);
  AnimationController _controller;

  AppBar appBar = AppBar();
  double borderRadius = 0.0;

  int _navBarIndex = 0;
  TabController tabController;

  getSharedPrefData() async {
    pref = await SharedPreferences.getInstance();
    name = pref.getString(Constant.name);
    email = pref.getString(Constant.emailId);
    shopName = pref.getString(Constant.shopName);
      mobileNo = pref.getString(Constant.mobileNo);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        _navBarIndex = tabController.index;
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getSharedPreference(Constant.name).then((value) => setState(() {
      name = value;
    }));
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    getSharedPrefData();
    // var res = _getAddressList();

    return WillPopScope(
      onWillPop: () async {
        if (!isCollapsed) {
          setState(() {
            _controller.reverse();
            borderRadius = 0.0;
            isCollapsed = !isCollapsed;
          });
          return false;
        } else
          return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        body: Stack(
          children: <Widget>[
            menu(context),
            AnimatedPositioned(
                left: isCollapsed ? 0 : 0.6 * screenWidth,
                right: isCollapsed ? 0 : -0.2 * screenWidth,
                top: isCollapsed ? 0 : screenHeight * 0.1,
                bottom: isCollapsed ? 0 : screenHeight * 0.1,
                duration: duration,
                curve: Curves.fastOutSlowIn,
                child: dashboard(context)),
          ],
        ),
      ),
    );
  }

  Widget menu(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.6,
            heightFactor: 0.8,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Container(
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
                ),
                listTile(name),
                listTile(email),
                listTile(mobileNo),
                RaisedButton(
                  child: Text("Edit Profile",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                  color: Colors.redAccent,
                  splashColor: Colors.blueGrey[900],
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                ),
                RaisedButton(onPressed: () {
                  setState(() async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('email');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                },
                  color: Colors.redAccent,
                  splashColor: Colors.blueGrey[900],
                  child: Text("LogOut",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),),
                // ListTile(
                //   title: Text("ShopKeeper"),
                //   trailing: IconButton(
                //     icon: Icon(Icons.arrow_forward_ios),
                //     onPressed: () => Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => Shopkeeper_Dashboard())),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listTile(String text) {
    return ListTile(
        title: Text(
      "$text",
      style: commonTextStyle(),
    ));
  }

  Widget dashboard(context) {
    return SafeArea(
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        type: MaterialType.card,
        animationDuration: duration,
        color: Colors.blue,
        elevation: 8,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Laundro Cart',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 25),
                ),
                actions: <Widget>[
                  Badge(
                    position: BadgePosition.topEnd(top: 0, end: 3),
                    animationDuration: Duration(milliseconds: 300),
                    // animationType: BadgeAnimationType.slide,
                    badgeColor: Colors.blueGrey[900],
                    badgeContent: IconButton(
                      icon: Icon(Icons.shopping_cart_outlined),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart())),
                    ),
                  )
                ],
                leading: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _controller,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isCollapsed) {
                          _controller.forward();

                          borderRadius = 16.0;
                        } else {
                          _controller.reverse();

                          borderRadius = 0.0;
                        }

                        isCollapsed = !isCollapsed;
                      });
                    }),
              ),
              bottomNavigationBar: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomLeft: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius)),
                child: BottomNavigationBar(
                  backgroundColor: Colors.deepOrangeAccent,
                  selectedItemColor: Colors.greenAccent,
                  unselectedItemColor: Colors.redAccent,
                  currentIndex: _navBarIndex,
                  type: BottomNavigationBarType.shifting,
                  onTap: (index) {
                    setState(() {
                      _navBarIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text(
                          'Home',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.explore),
                        title: Text('Explore',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.person),
                    //   title: Text(
                    //     'Profile',
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              ),
              body: _myPages[_navBarIndex]),
        ),
      ),
    );
  }
}
