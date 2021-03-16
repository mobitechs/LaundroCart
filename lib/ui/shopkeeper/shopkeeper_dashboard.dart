import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:laundro_cart/ui/services/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'add_services.dart';
import 'dashboard_home.dart';
import 'edit_profile.dart';
import 'shopkeeper_profile.dart';

class Shopkeeper_Dashboard extends StatefulWidget {
  @override
  _Shopkeeper_DashboardState createState() => _Shopkeeper_DashboardState();
}

class _Shopkeeper_DashboardState extends State<Shopkeeper_Dashboard>
    with SingleTickerProviderStateMixin {
  static List<Widget> _myPages = <Widget>[
    DashBoard_Home(),
    ShopKeeper_Profile()
  ];

  // static List<Widget> _myPages = <Widget>[Home(), Google_map(), Profile()];

  commonTextStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  }

  SharedPreferences pref;
  String shopName = "";
  String email = "";
  String mobileNo = "";

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
    shopName = pref.getString(Constant.shopName);
    email = pref.getString(Constant.emailId);
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
    getSharedPreference(Constant.shopName).then((value) => setState(() {
          shopName = value;
        }));

    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

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
        // backgroundColor: Theme
        //     .of(context)
        //     .scaffoldBackgroundColor,
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
                    child: Center(
                  child: Text(
                    shopName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
                ListTile(
                  title: Text("Add Services"),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Add_Services()));
                    },
                  ),
                ),
                ListTile(
                  title: Text("Edit Profile"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Edit_Shopkeeper_Profile()));
                    },
                  ),
                ),
                ListTile(
                  title: Text("LogOut"),
                  trailing: IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      setState(() async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      });
                    },
                  ),
                ),
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
        // shadowColor: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        type: MaterialType.card,
        animationDuration: duration,
        // color: Theme
        //     .of(context)
        //     .scaffoldBackgroundColor,
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
                        icon: Icon(Icons.person),
                        title: Text('Profile',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              body: _myPages[_navBarIndex]),
        ),
      ),
    );
  }
}
