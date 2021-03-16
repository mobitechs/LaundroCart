import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'placeOrder.dart';

class ListOfItems extends StatefulWidget {
  var details;
  var shopId;

  ListOfItems(this.shopId, this.details);

  @override
  _ListOfItemsState createState() => _ListOfItemsState(shopId, details);
}

class _ListOfItemsState extends State<ListOfItems> {
  var details;
  var shopId;

  _ListOfItemsState(this.shopId, this.details);

  int quantity = 0;
  int price = 0;
  var serviceId = "";
  var serviceName = "";
  var finalAmount = 0;
  var finalMsg = "";

  static const commonTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  List<ProductListModel> _getItemListByService;
  bool _loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    serviceId = details.serviceId;
    serviceName = details.serviceName;
    print("============$serviceId" + shopId);

    _loading = true;
    _getItemListByService = [];
    GetListOfItems().then((val) => setState(() {
          _getItemListByService = val;
        }));
    _loading = false;
  }

  Future<List<ProductListModel>> GetListOfItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // shopId = pref.getString(Constant.userId);
    try {
      var url = Constant.url +
          "?method=getItemListByService&userId=$shopId&serviceId=$serviceId";
      print(url);
      final response = await http.get(url);
      if (200 == response.statusCode) {
        List<ProductListModel> getItemsList = [];
        final Map<String, dynamic> jsonObjRes = jsonDecode(response.body);
        {
          // var list = jsonObjRes["Response"];
          // for (var u in list) {
          //   print("Pratik u" + u.toString());
          //   ProductListModel item = ProductListModel(
          //     u["itemId"],
          //     u["userId"],
          //     u["serviceId"],
          //     u["itemName"],
          //     u["rate"],
          //     0,
          //     0,
          //     "0"
          //   );
          //   getItemsList.add(item);
          // }

          for (var u in jsonObjRes["Response"]) {
            ProductListModel pm = ProductListModel.fromJson(u);
            getItemsList.add(pm);
          }
        }
        return getItemsList;
      }
    } catch (e) {
      return List<ProductListModel>();
    }
  }

  // List<TextEditingController> _quantityController = new List();

  // void _addQuantity(int index) {
  //   setState(() {
  //     quantity++;
  //     _quantityController[index].text = '$quantity';
  //   });
  // }
  //
  // void _removeQuantity(int index) {
  //   setState(() {
  //     if (quantity > 0) {
  //       quantity--;
  //     } else {
  //       quantity = 0;
  //     }
  //     _quantityController[index].text = '$quantity';
  //   });
  // }

  Widget _buildListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount:
          (_getItemListByService != null) ? (_getItemListByService.length) : 0,
      itemBuilder: (BuildContext context, int index) {
        ProductListModel details = _getItemListByService[index];
        // _quantityController.add(new TextEditingController());

        var item = _getItemListByService[index];
        int pos = index;
        String iId = item.itemId;
        int pqty = item.qty;

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //color: Colors.deepOrangeAccent,
                padding: EdgeInsets.only(left: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF0A0E21),
                        offset: Offset(1, 1),
                        // blurRadius: 5,
                      ),
                    ],
                    color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: details.itemName,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "     ₹ ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent)),
                            TextSpan(
                                text: details.rate,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ButtonTheme(
                            height: 16.0,
                            minWidth: 10.0,
                            child: RaisedButton(
                                padding: const EdgeInsets.all(4.0),
                                color: Colors.white,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                // onPressed: () => _removeQuantity(index)
                                onPressed: () {
                                  if (item.qty > 0) {
                                    quantity = item.qty - 1;
                                    setState(() {
                                      final tile =
                                          _getItemListByService.firstWhere(
                                              (item) => item.itemId == iId);
                                      pqty = pqty--;
                                      tile.qty = quantity;
                                      print(".............$quantity");
                                    });

                                    calculateAmount();
                                  }
                                }),
                          ),
                          Container(
                              width: 60.0,
                              padding:
                                  const EdgeInsets.only(left: 1.0, right: 1.0),
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(
                                  hintText: pqty.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                // controller: _quantityController[index],
                              )),
                          ButtonTheme(
                            height: 16.0,
                            minWidth: 10.0,
                            child: RaisedButton(
                                padding: const EdgeInsets.all(4.0),
                                color: Colors.white,
                                child: Icon(Icons.add,
                                    color: Colors.black, size: 20.0),
                                onPressed: () {
                                  quantity = item.qty + 1;
                                  setState(() {
                                    final tile =
                                        _getItemListByService.firstWhere(
                                            (item) => item.itemId == iId);
                                    pqty = pqty++;
                                    tile.qty = quantity;
                                    print(".............$quantity");
                                  });

                                  calculateAmount();
                                }),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
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

  void calculateAmount() {
    String pName, msg = ",Your Order Details: "+",$serviceName ,";
    int no = 0, pAmount = 0, pQty, total = 0, fTotal = 0;

    for (var item in _getItemListByService) {

      pName = item.itemName;
      pAmount = int.parse(item.rate);
      pQty = (item.qty != null) ? item.qty : 1;

      total = pAmount * pQty;
      fTotal = fTotal + total;
      var mydata =  "   Qty: " + pQty.toString();

      if(pQty > 0){
        no++;
        msg = msg +" "+ no.toString() + ". " + pName + ", " + mydata+ " = " + total.toString() + " Rs. ,";
      }

    }
    finalAmount = fTotal;
    msg = msg + ",Payable Amount = " + finalAmount.toString()+" Rs.";
    finalMsg = msg;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart', style: TextStyle(color: Colors.white)),
          // centerTitle: true,
          // backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
            Stack(children: <Widget>[
              Container(
                color: Colors.black54,
                padding:
                    EdgeInsets.only(top: 15, right: 12, left: 8, bottom: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Total Amount",
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rs." + finalAmount.toString(),
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            // Visibility(
                            //   //visible: showDelivery,
                            //   child: Text(
                            //     "+Rs." +
                            //         Constant.deliveryCharges.toString() +
                            //         " Delivery Charges",
                            //     style: TextStyle(
                            //         fontSize: 10.0,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.red),
                            //   ),
                            // ),
                            // Visibility(
                            //   //  visible: showDelivery,
                            //   child: Text(
                            //     "Buy More Rs." +
                            //         //     amountRemainingForFreeDel.toString() +
                            //         " to get free delivery",
                            //     style: TextStyle(
                            //         fontSize: 10.0,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.red),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // decoration: BoxDecoration(
                        //   // color: Color(0xFF0A0E21),
                        //     border: Border.all()),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlaceOrder(finalMsg,finalAmount.toString(),shopId)));
                          },
                          color: Colors.deepOrange,
                          child: Text(
                            "Place Order",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            //  SizedBox(height: 15,),
          ],
        ));
  }
}
