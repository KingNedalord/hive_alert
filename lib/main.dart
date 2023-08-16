import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter;
  box = await Hive.openBox("box");
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController txtContr = TextEditingController();
  late String edit_text;

  longPress(String text, int index) {
    showDialog(
        context: context,
        builder: (context) {
          txtContr.text = text;
          return AlertDialog(
            title: Text("Edit window"),
            content: TextField(
              controller: txtContr,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter text",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    box.putAt(index, txtContr.value.text);
                    Navigator.pop(context);
                  },
                  child: Text("Save")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {
                return ListView.builder(
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text(box.getAt(index)),
                          IconButton(
                              onPressed: () {
                                edit_text = box.getAt(index);
                                longPress(box.getAt(index), index);
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                box.deleteAt(index);
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      );
                    },
                    itemCount: box.length);
              },
            ),
          ),
          TextField(
            controller: txtContr,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Message...",
                suffix: IconButton(
                    onPressed: () {
                      if (txtContr != "") {
                        box.add(txtContr.text);
                        txtContr.text = "";
                      }
                    },
                    icon: Icon(Icons.send))),
          )
        ],
      ),
    );
  }
}
