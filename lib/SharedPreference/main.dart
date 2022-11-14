import 'package:databasemodel/SharedPreference/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(MaterialApp(home: MyApp(),));
}
class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences Logindata;
  late bool newuser;

  final username_Controller = TextEditingController();
  final password_Controller = TextEditingController();

  @override
  void initState(){
  super.initState();
  check_if_already_login();
  }
 void check_if_already_login()async{
    Logindata = await SharedPreferences.getInstance();
    newuser = (Logindata.getBool('login')??true);
    print(newuser);
    if(newuser == false){
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => MyDashboard()));
    }
  }
  @override
  void dispose(){
    username_Controller.dispose();
    password_Controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(
      title: Text(" Shared Preferences"),
    ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login Form",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "To show Example of Shared Preferences",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: username_Controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: password_Controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                String username = username_Controller.text;
                String password = password_Controller.text;
                if (username != '' && password != '') {
                  print('Successfull');
                  Logindata.setBool('login', false);
                  Logindata.setString('username', username);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDashboard()));
                }

              },
              child: Text("Log-In"),
            )
          ],
        ),
      ),);
  }
}