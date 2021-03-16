import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class Add_Items extends StatefulWidget {

  var details;
  Add_Items(this.details);

  @override
  _Add_ItemsState createState() => _Add_ItemsState(details);
}

class _Add_ItemsState extends State<Add_Items> {

  var details;
  _Add_ItemsState(this.details);

  int count = 0;
  String itemName = "";
  String rate = "";
  var isLoading = false;
  String serviceId = "";
  String userId = "";

  List<GetItemListByService> _getItemList;

  @override
  void initState() {
    super.initState();

    serviceId = details.serviceId;
    print("============$serviceId");

    _getItemList = [];
    getListOfItems().then((val) => setState(() {_getItemList = val;}));

  }

  loadProgress(bool loadingStatus) {
    setState(() {
      isLoading = loadingStatus;
    });
  }

  Future<void> _addServiceBtn() async {
    if (itemName == "") {
      return CommonMethods.showColoredToast(
          "Please enter name of product", Colors.red);
    } else if (rate == "") {
      CommonMethods.showColoredToast("Please enter price.", Colors.red);
    } else {
      isLoading = true;
      loadProgress(isLoading);
      callAPI();
    }
  }

  callAPI() async {

    serviceId = details.serviceId;
    print("////////////////////$serviceId");

    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyObj =
        '{"method":"AddItem","userId":"$userId", "serviceId": "$serviceId", "itemName": "$itemName", "rate": "$rate"}';
    print("-------------------------------$bodyObj");
    Response res = await post(Constant.url, headers: headers, body: bodyObj);
    print('Register body' + bodyObj);
    var data = json.decode(res.body);

    if (data["Response"] == 'SUCESS_TO_ADD') {
      CommonMethods.showColoredToast("Product Added", Colors.blue);
      print('Item Added');
    } else {
      print('Item Not Added');
      CommonMethods.showColoredToast("Item Not Added", Colors.red);
    }
   // Navigator.of(context).pop();
    loadProgress(false);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Add_Items(details)));
  }

  int dataFound = 0;

  Future<List<GetItemListByService>> getListOfItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString(Constant.userId);

    try {
      final response = await http.get(Constant.url + "?method=getItemListByService&userId=$userId&serviceId=$serviceId");
      if(200 == response.statusCode){
        List<GetItemListByService> getServiceList = [];
        final Map<String, dynamic> jsonObjRes = jsonDecode(response.body);
        {
          var list = jsonObjRes["Response"];
          for (var u in list) {
            print("Pratik u" + u.toString());
            GetItemListByService item = GetItemListByService( u["itemId"],u["id"], u["serviceId"], u["itemName"], u["rate"], 0,
                0,
                "0");
            getServiceList.add(item);
          }
        }
        return getServiceList;
      }
    }catch(e){
      return List<GetItemListByService>();
    }
  }

  @override
  Widget build(BuildContext context) {
    // getSharedPreference(Constant.serviceId).then((value) => setState(() {serviceId = value;}));
    // getSharedPreference(Constant.userId).then((value) => setState(() {userId = value;}));

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Items"),
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
        tooltip: "Add Product",
        child: Icon(Icons.add),
      ),
      body: Add_Items_Screen(),
    );
  }

  ListView Add_Items_Screen() {
    return ListView.builder(
      itemCount: _getItemList.length,
      itemBuilder: (context, index) {
        GetItemListByService details = _getItemList[index];
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Text(
                  details.itemName,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Rs. ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: details.rate, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.redAccent),
                  onTap: () {
                    setState(() {
                      print("Item Deleted");
                    });
                  },
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
              itemName = text;
            },
            cursorColor: Colors.black,
            autofocus: false,
            autocorrect: false,
            maxLength: 30,
            // keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Product Name',
              labelStyle: TextStyle(color: Colors.black),
              counterStyle: TextStyle(color: Colors.black),
              // focusColor: Colors.black,

              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            onChanged: (text) {
              rate = text;
            },
            cursorColor: Colors.black,
            autofocus: false,
            autocorrect: false,
            maxLength: 30,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price in rupee',
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
                "Add Products",
                style: TextStyle(color: Colors.black),
              ),
              color: Colors.greenAccent,
              splashColor: Colors.black,
              onPressed: () {
                _addServiceBtn();
              },
            ),
          )
        ],
      ),
    );
  }
}
