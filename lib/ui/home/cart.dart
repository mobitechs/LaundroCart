import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: MyOrdersBody(),
    );
  }
}

class MyOrdersBody extends StatefulWidget {
  @override
  _MyOrdersBodyState createState() => _MyOrdersBodyState();
}

class _MyOrdersBodyState extends State<MyOrdersBody> {

  static const commonTextStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  List<OrderListModel> orderListItems;

  bool _loading;
  var userId="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderListItems = [];
    GetListOfMyOrder().then((val) => setState(() {
      orderListItems = val;
    }));

  }

  Future<List<OrderListModel>> GetListOfMyOrder() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString(Constant.userId);
    try {
      var url = Constant.url + "?method=getMyOrder&userId=$userId";
      print(url);
      final response = await http.get(url);
      if (200 == response.statusCode) {
        List<OrderListModel> getServiceList = [];
        final Map<String, dynamic> jsonObjRes = jsonDecode(response.body);
        {
          var list = jsonObjRes["Response"];
          for (var u in list) {
            print("Pratik u" + u.toString());
            OrderListModel item = OrderListModel(
              u["orderId"],
              u["userId"],
              u["shopId"],
              u["orderDetails"],
              u["totalAmount"],
              u["address"],
              u["orderDate"],
            );
            getServiceList.add(item);
          }
        }
        return getServiceList;
      }
    } catch (e) {
      return List<OrderListModel>();
    }
  }

  Widget _buildListView(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: (orderListItems != null)
          ? (orderListItems.length)
          : 0,
      itemBuilder: (BuildContext context, int index) {
        OrderListModel details = orderListItems[index];
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
                child:
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(details.orderId,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 25,
                              ),
                              // onPressed: () {
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfItems()));
                              // },
                            ),
                          ],
                        ),
                        Text(details.orderDate,),
                        Text(details.totalAmount,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
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

