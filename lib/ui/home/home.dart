import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/model/shop_list_items.dart';
import 'package:laundro_cart/ui/home/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int dataFound = 0;


  Future<List<GetShopList>> _getAddressList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

   try {
     final response = await http.get(Constant.url + "?method=getShopList");
     if(200 == response.statusCode){
       List<GetShopList> getShopList = [];
       final Map<String, dynamic> jsonObjRes = jsonDecode(response.body);
       {
         var list = jsonObjRes["Response"];
         for (var u in list) {
          //  print("Pratik u" + u.toString());
           GetShopList item = GetShopList(u["id"], u["name"], u["shopName"],
               u["mobile"], u["email"], u["address"], u["pinCode"], u["shopImage"], u["latitude"], u["longitude"]);
           getShopList.add(item);
         }
       }
       return getShopList;
     }
   }catch(e){
     return List<GetShopList>();
    }
  }

  List<GetShopList> _getShopList;
  bool _loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    _getShopList = [];
    _getAddressList().then((val) => setState(() {_getShopList = val;}));
    _loading = false;
  }

  Widget _buildListView(){
    return ListView.builder(
      // scrollDirection: Axis.horizontal,
        itemCount: _getShopList.length,
        itemBuilder: (context , index){
          GetShopList details = _getShopList[index];
          return Padding(
            padding: const EdgeInsets.only(top:10.0, bottom: 10),
            child: Column(
              children: [
                Container(
                  // height: MediaQuery.of(context).copyWith().size.height / 1.5,
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    boxShadow: [BoxShadow(offset: Offset(2, 2), blurRadius: 2)],
                    color: Color(0xFF0A0E21),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Image.asset("assets/images/seller.png",
                                height: 100),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(details.name,
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                                SizedBox(height: 15,),
                                Text(details.address,
                                  style: TextStyle(fontSize: 14),),
                                SizedBox(height: 15,),

                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: RaisedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => productListHome(details))),
                          color: Colors.greenAccent,
                          splashColor: Colors.deepOrangeAccent,
                          child: Text("Visit Shop",
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 15),
          child: Text(
            "   Shop's Near You",
            style: TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: _buildListView()),
      ],
    );
  }
}
