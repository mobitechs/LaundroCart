import 'package:flutter/material.dart';

import '../../constants.dart';

import 'package:http/http.dart';
import 'dart:convert';

import 'cart.dart';

class PlaceOrder extends StatefulWidget {
  var finalMsg;
  var totalAmount;
  var shopId;
  PlaceOrder(this.finalMsg,this.totalAmount,this.shopId);
  @override
  _PlaceOrderState createState() => _PlaceOrderState(finalMsg,totalAmount,shopId);
}

class _PlaceOrderState extends State<PlaceOrder> {

  var finalMsg;
  var totalAmount;
  var shopId;
  _PlaceOrderState(this.finalMsg,this.totalAmount,this.shopId);

  String address = "";
  String orderDetails = "";
  String orderPreview = "";
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSharedPreference(Constant.address).then((value) => setState(() {
      address = value;
    }));
    getSharedPreference(Constant.userId).then((value) => setState(() {
      userId = value;
    }));
     orderDetails = finalMsg;
     orderPreview = orderDetails.replaceAll(',', '\n');

  }

  callPlaceOrderAPI() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"placeOrder" ,"userId":"$userId","shopId":"$shopId", "orderDetails":"$orderDetails" ,"totalAmount":"$totalAmount" ,"address":"$address"}';

    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('order body' + bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'SUCESS_TO_ADD') {
      CommonMethods.showColoredToast("Order Successfully Placed", Colors.blue);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Cart()));
    } else {
      CommonMethods.showColoredToast("Order failed", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Laundro Cart"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 15),
            // child: Text("Select Address"),
          ),
          GestureDetector(
            child: Container(
              color: Colors.blueGrey,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                orderPreview+"\n\nAddress Details:-\n"+ address,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 30,),
          RaisedButton(
            onPressed: () {
              callPlaceOrderAPI();
            },
            color: Colors.deepOrange,
            child: Text(
              "Confirm Order",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget alertBox(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text("Confirm Your Order"),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Colors.greenAccent,
                onPressed: () {},
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              RaisedButton(
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
