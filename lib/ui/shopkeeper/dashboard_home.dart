import 'package:flutter/material.dart';
import 'order_board.dart';

class DashBoard_Home extends StatefulWidget {
  @override
  _DashBoard_HomeState createState() => _DashBoard_HomeState();
}

class _DashBoard_HomeState extends State<DashBoard_Home> {

  Widget HoriScrollView(String shopName, String shopAdd) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      // height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
        boxShadow: [BoxShadow(offset: Offset(2, 2), blurRadius: 2)],
        color: Color(0xFF0A0E21),
      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset("assets/images/seller.png",
                height: 120),
            SizedBox(height: 15),
            Center(
              child: Text("$shopName",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
            ),
            SizedBox(height: 20),
            Text("$shopAdd",
              style: TextStyle(fontSize: 15),),
            SizedBox(height: 25),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderBoard())),
              color: Colors.greenAccent,
              child: Text("See Order",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 15),
            child: Text(
              "Your Orders",
              style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 400,
            child: PageView(
              controller: PageController(viewportFraction: 0.8),
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              children: <Widget>[
                HoriScrollView("User Name", "603, A/1, Panchasheel Co.op SOc, Worli, Mumbai-18"),
                HoriScrollView("Kunal", "XYZ Laundry , Mumbai-ndry Shop603, 1, Panchasheel Co.op SOdry , Mumbai-ndry Shop603, 1, Panchasheel Co.op SOc, Worli, Mumbai-18"),
                HoriScrollView("sd", "sd"),
                HoriScrollView("sd", "sd"),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
