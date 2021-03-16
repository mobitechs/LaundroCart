import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_list.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class productListHome extends StatefulWidget {

  var details;
  productListHome(this.details);

  @override
  _productListHomeState createState() => _productListHomeState(details);
}

class _productListHomeState extends State<productListHome> {

  var details;
  _productListHomeState(this.details);



  void icon() {
    Icon(Icons.arrow_forward_ios);
  }

  @override
  Widget build(BuildContext context, [int totalAmount]) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laundro Cart"),
      ),
      body: ServiceList(details),
    );
  }
}

class ServiceList extends StatefulWidget {
  var details;
  ServiceList(this.details);
  @override
  _ServiceListState createState() => _ServiceListState(details);

}

class _ServiceListState extends State<ServiceList> {
  var details;
  _ServiceListState(this.details);

  static const commonTextStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  List<GetServiceList> _getListOfService;
  bool _loading;
  var shopId="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopId = details.id;
    print("====shop========$shopId");

    _loading = true;
    _getListOfService = [];
    GetListOfServices().then((val) => setState(() {
      _getListOfService = val;
    }));
    _loading = false;
  }

  Future<List<GetServiceList>> GetListOfServices() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
          Constant.url + "?method=getServiceList&userId=$shopId");
      if (200 == response.statusCode) {
        List<GetServiceList> getServiceList = [];
        final Map<String, dynamic> jsonObjRes = jsonDecode(response.body);
        {
          var list = jsonObjRes["Response"];
          for (var u in list) {
            print("Pratik u" + u.toString());
            GetServiceList item = GetServiceList(
              u["id"],
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


  Widget _buildListView(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: (_getListOfService != null)
          ? (_getListOfService.length)
          : 0,
      itemBuilder: (BuildContext context, int index) {
        GetServiceList details = _getListOfService[index];
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: 25.0,
                  right: 10,
                ),
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.0,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey,
                        offset: Offset(1, 1),
                        // blurRadius: 5,
                      ),
                    ],
                    color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(details.serviceName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfItems(shopId,details)));
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


  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }
}
