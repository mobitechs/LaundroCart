import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:laundro_cart/utilities/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants.dart';
import 'home.dart';

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  String selectedId = "";
  bool isLoading = false;

  String selectedAddressId = "";
  String selectedAddress = "";
  bool isSelected = false;

  String userId = "";
  String orderItemMsg = "";
  String orderTotalAmount = "";
  String dialogFor = "";
  String positiveBtnText = "";


  Future<List<GetShopList>> _getAddressList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Response res = await get(Uri.parse(Constant.url + "?method=getShopList"));
    Map<String, dynamic> jsonObjRes = jsonDecode(res.body);
    List<GetShopList> listItems = [];

    if (jsonObjRes["Response"] == "List not available"){
      CommonMethods.showColoredToast("Address Not Available.", Colors.red);
    } else {
      var list = jsonObjRes["Response"];
      for (var u in list) {
        print("Pratik u" + u.toString());
        GetShopList item = GetShopList(u["id"], u["name"], u["shopName"],
            u["mobile"], u["email"], u["address"], u["pinCode"], u["shopImage"], u["latitude"], u["longitude"]);
        listItems.add(item);
      }
    }
    return listItems;
  }

  showOrderPreview() {

  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address', style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => AddAddressDetails(null),
          // ));
        },
        elevation: 10.0,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: FutureBuilder(
              future: _getAddressList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        // var itemData = snapshot.data[index];
                        var itemData;
                        return Card(
                          elevation: 10.0,
                          child: ListTile(
                            leading: isSelected ? Icon(
                              Icons.radio_button_checked,
                              color: Colors.green,
                            ) : Icon(
                              Icons.radio_button_checked,
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("address: " + snapshot.data[index].address),
                                  ],
                                ),
                                // Row(
                                //   children: <Widget>[
                                //     Text(
                                //       "Land Mark: " + itemData.landMark,
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Area: " + snapshot.data[index].pinCode,
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: <Widget>[
                                //     Text(
                                //       "City: " + itemData.city,
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "PinCode: " + snapshot.data[index].pinCode,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              selectedAddressId = snapshot.data[index].addressId;
                              selectedAddress = "Address: " +
                                  snapshot.data[index].address +
                                  " \nLandmark: " +
                                  snapshot.data[index].landMark +
                                  " \nArea: " +
                                  snapshot.data[index].area +
                                  " \nCity: " +
                                  snapshot.data[index].city +
                                  " \nPinCode: " +
                                  snapshot.data[index].pincode;
                              setState(() {
                                if (isSelected) {
                                  isSelected = false;
                                }
                                else {
                                  isSelected = true;
                                }
                                CommonMethods.showColoredToast(
                                    "AddressId " + isSelected.toString(),
                                    Colors.red);
                              });
                            },
                          ),
                        );
                      });
                } else {
                  return Center(child: Text("Error Occured"));
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child:
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                        Container(

                          child:
                          RaisedButton(
                            onPressed: () {
                              showOrderPreview();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.deepOrange,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Confirm & Place Order",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


    );
  }
}
