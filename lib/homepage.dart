import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sqflite.dart';
import 'main.dart';
class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class  _homepageState extends State<homepage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _journals = [];
  int? id;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:  _isLoading ? const Center(  child: CircularProgressIndicator(),):
                     ListView.builder(
                      itemCount: _journals.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                  title: Text(_journals[index]['username']),
                                  subtitle: Text(_journals[index]['password']),
                                  trailing: Text(_journals[index]['email']))
                            ],
                          ),
                        );
                      },
                    )
        );}
    }

