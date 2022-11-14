import 'package:databasemodel/SharedPreference/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDashboard extends StatefulWidget{
  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
   late SharedPreferences Logindata;
  late String username;

  @override
  void initState(){
    super.initState();
    initial();
  }
  void initial()async{
    Logindata = await SharedPreferences.getInstance();
    username = Logindata.getString('username')!;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(  appBar: AppBar(
      title: Text("Shared Preference Example"),
    ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Hai $username',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Logindata.setBool('login', true);
                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Text('LogOut'),
            )
          ],
        ),
      ),);
  }
}

