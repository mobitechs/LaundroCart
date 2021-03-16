import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:laundro_cart/ui/shopkeeper/add_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Add_Services extends StatefulWidget {
  @override
  _Add_ServicesState createState() => _Add_ServicesState();
}

class _Add_ServicesState extends State<Add_Services> {
  int count = 0;
  String serviceName = "";
  var isLoading = false;
  String userId = "";

  List<GetServiceList> _getServiceList;

  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharedPreference(Constant.userId).then((value) => setState(() {
          userId = value;
        }));

    _getServiceList = [];
    getListOfService().then((val) => setState(() {
          _getServiceList = val;
        }));
  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  Future<void> _addServiceBtn() async {
    if (serviceName == "") {
      return CommonMethods.showColoredToast(
          "Please enter name of service", Colors.red);
    } else {
      isLoading = true;
      loadProgress(isLoading);
      callAPI();
    }
  }

  callAPI() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"AddService","serviceName":"$serviceName", "userId": "$userId"}';
    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('Register body' + bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'SUCESS_TO_ADD') {
      CommonMethods.showColoredToast("Service Added", Colors.blue);
      print('Service Added');
    }
    else {
      print('Service Not Added');
      CommonMethods.showColoredToast("Service Not Added", Colors.red);
    }
    // Navigator.of(context).pop();
    loadProgress(false);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Add_Services()));
  }

  void deleteService(String sId) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"deleteService","serviceId":"$sId", "userId": "$userId"}';
    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('Register body' + bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'SUCESS_TO_DELETE') {
      CommonMethods.showColoredToast("Service Deleted", Colors.blue);
      print('Service Deleted');
    }
    else {
      print('Service Not Deleted');
      CommonMethods.showColoredToast("Service Not Deleted", Colors.red);
    }
    // Navigator.of(context).pop();
    loadProgress(false);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Add_Services()));
  }

  Future<List<GetServiceList>> getListOfService() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      final response = await http
          .get(Constant.url + "?method=getServiceList&userId=$userId");
      if (200 == response.statusCode) {
        List<GetServiceList> getServiceList = [];
        final Map<String, dynamic> jsonObjRes = jsonDecode(response.body);
        {
          var list = jsonObjRes["Response"];
          for (var u in list) {
            print("Pratik u" + u.toString());
            GetServiceList item = GetServiceList(
              u["userId"],
              u["serviceName"],
              u["serviceId"],
            );
            getServiceList.add(item);
          }
        }
        return getServiceList;
      }
    } catch (e) {
      return List<GetServiceList>();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laundro Cart"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        splashColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        },
        tooltip: "Add Service",
        child: Icon(Icons.add),
      ),
      body: Add_Services_Screen(),
    );
  }

  ListView Add_Services_Screen() {
    TextStyle titleText = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: _getServiceList.length,
      itemBuilder: (context, index) {
        GetServiceList details = _getServiceList[index];
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                details.serviceName,
                style: titleText,
              )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        // height: double.infinity,
                        // color: Colors.grey,
                        child: Icon(Icons.delete, color: Colors.redAccent),
                      ),
                      onTap: () {
                        deleteService(details.serviceId);
                        // setState(() {
                        //   print("Item Deleted");
                        // });
                      },
                    ),
                    GestureDetector(
                      child: Icon(Icons.arrow_forward_ios,
                          color: Colors.greenAccent),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Add_Items(details)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        'Add Service Name',
        style: TextStyle(color: Colors.black),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            onChanged: (text) {
              serviceName = text;
            },
            cursorColor: Colors.black,
            autofocus: false,
            autocorrect: false,
            maxLength: 30,
            decoration: InputDecoration(
              labelText: 'Service Name',
              labelStyle: TextStyle(color: Colors.black),
              counterStyle: TextStyle(color: Colors.black),
              // focusColor: Colors.black,

              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: new RaisedButton(
              child: Text(
                "Add Service",
                style: TextStyle(color: Colors.black),
              ),
              color: Colors.greenAccent,
              splashColor: Colors.black,
              onPressed: () {
                _addServiceBtn();
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
