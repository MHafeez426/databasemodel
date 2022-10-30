import 'package:databasemodel/homepage.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOGIN',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Flutter SQFLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  var id;

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _usernameController.text = existingJournal['username'];
      _passwordController.text = existingJournal['password'];
      _emailController.text = existingJournal['email'];


        showModalBottomSheet(
            context: context,
            builder: (__) =>Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      icon: Icon(Icons.account_circle),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "email address",
                      icon: Icon(Icons.email),
                    ),
                  ),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                  ElevatedButton(
                      child: Text("LOGIN"),
                      onPressed: ()async { if( id== null) {
                        await _addItem();
                      }


                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _usernameController.text = '';
                      _passwordController.text = '';
                      _emailController.text = '';
                      await Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => homepage()));
                      })
                ]));

    }}


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by t
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[ElevatedButton(onPressed: () => showForm(id),
           child: Text("LOGIN")),
            ElevatedButton(onPressed: (){}, child: Text("SIGNUP"))
        ])),floatingActionButton: FloatingActionButton(
      onPressed: () => showForm(id),child: Text("CREATE NEW"),
    ),
    );

  }
  Future<void> _addItem() async{
    await SQLHelper.createItem(_usernameController.text, _passwordController.text, _emailController.text);
    _refreshJournals();
  }
  Future<void>_updateItem(int id) async{
    await SQLHelper.updateItem(id, _usernameController.text, _passwordController.text, _emailController.text);
    _refreshJournals();
  }
}
