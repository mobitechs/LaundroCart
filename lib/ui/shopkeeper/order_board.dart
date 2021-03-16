import 'package:flutter/material.dart';
import 'package:laundro_cart/constants.dart';

class OrderBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return appBar(OrderBoard_Body());
  }
}


class OrderBoard_Body extends StatefulWidget {
  @override
  _OrderBoard_BodyState createState() => _OrderBoard_BodyState();
}

class _OrderBoard_BodyState extends State<OrderBoard_Body> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Heloo"),
    );
  }
}

