import 'package:flutter/material.dart';
import 'package:laundro_cart/constants.dart';
import 'package:laundro_cart/constants.dart';
class Main_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return appBar(Edit_Profile());
  }
}

class Edit_Profile extends StatefulWidget {
  @override
  _Edit_ProfileState createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    var isLoading = false;

    String _email;
    String _passwd;

    void _submitBtn() {
      final isValid = _formKey.currentState.validate();
      // isValid
      //     ? Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => LoginScreen(),
      //   ),
      // )
      //     : null;
    }

    Widget textFormFields(String labelText, String hintText, bool obsercureText,
        String ErrorMsg) {
      return TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "$labelText",
              hintText: "$hintText",
              labelStyle: TextStyle(fontSize: 17)),
          obscureText: obsercureText,
          onChanged: (val) {
            _email = val;
          },
          validator: (val) {
            if (val.isEmpty) {
              return "$ErrorMsg";
            } else {
              return null;
            }
          });
    }

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[900],
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                  offset: Offset(2, 3),
                  blurRadius: 5)
            ]),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Center(
                child: Text("Edit Email"),
              ),
              textFormFields("User Name", "Enter Name", false, "Enter Name"),
              textFormFields("New Email", "Enter New Email", false, "Enter Email"),
              SizedBox(height: 15,),
              Center(
                child: RaisedButton(
                    child: Text("Submit",
                    style: raisedButtonStyle),
                    color: Colors.deepOrangeAccent,
                    splashColor: Colors.black,
                    onPressed: () => _submitBtn()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
