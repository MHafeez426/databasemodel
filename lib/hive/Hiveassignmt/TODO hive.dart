import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Todo_notes');
  runApp(MaterialApp(
    home: HiveTodo(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.grey),
  ));
}

class HiveTodo extends StatefulWidget {
  const HiveTodo({Key? key}) : super(key: key);

  @override
  State<HiveTodo> createState() => _HiveTodoState();
}

class _HiveTodoState extends State<HiveTodo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, dynamic>> _notes = [];
  final _todo_notes = Hive.box("Todo_notes");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _todo_notes.keys.map((key) {
      final value = _todo_notes.get(key);
      return {
        "key": key,
        "title": value["title"],
        "description": value["description"]
      };
    }).toList();
    setState(() {
      _notes = data.reversed.toList();
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _todo_notes.add(newItem);
    _refreshItems();
  }

  Map<String, dynamic> _readItem(int key) {
    final item = _todo_notes.get(key);
    return item;
  }

  Future<void> _updateItems(int itemkey, Map<String, dynamic> item) async {
    await _todo_notes.put(itemkey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(int itemkey) async {
    await _todo_notes.delete(itemkey);
    _refreshItems();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("note has been deleted")));
  }

  void _showForm(BuildContext context, int? itemkey) async {
    if (itemkey != null) {
      final existingItem =
          _notes.firstWhere((element) => element['key'] == itemkey);
      _titleController.text = existingItem['title'];
      _descriptionController.text = existingItem['description'];
    }
    showModalBottomSheet(
        context: context,
        elevation: MediaQuery.of(context).viewInsets.top,
        isScrollControlled: true,
        builder: (_) => Column(
              children: [
                ListTile(
                  title: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "title",
                    ),
                  ),
                  subtitle: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(hintText: "description"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (itemkey == null) {
                        _createItem({
                          "title": _titleController.text,
                          "description": _descriptionController.text
                        });
                      }
                      if (itemkey != null) {
                        _updateItems(itemkey, {
                          "title": _titleController.text.trim(),
                          "description": _descriptionController.text.trim()
                        });
                      }
                      _titleController.text = ' ';
                      _descriptionController.text = "";
                      Navigator.of(context).pop();
                    },
                    child: Text("SAVE"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("KEEP NOTES"),
        ),
        backgroundColor: Colors.white,
      ),
      body: _notes.isEmpty
          ? Center(
              child: Text(
                "ADD NOTES",
                style: TextStyle(fontSize: 50),
              ),
            )
          : Container(child:ListView.builder(shrinkWrap:true,
          itemBuilder:
           (_, index) {
              final currentItem = _notes[index];
              return Card(
                color: Colors.orange,
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(currentItem['title']),
                  subtitle: Text(currentItem['description'].toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteItem(currentItem['key']),
                  ),
                  onTap: () {
                    _showForm(context, currentItem['key']);
                  },
                ),
              );})),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: Icon(Icons.create),
      ),
    );
  }
}
