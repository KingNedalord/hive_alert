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
  TextEditingController txtContr2 = TextEditingController();

  longPress() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit window"),
            content: TextField(
              controller: txtContr2,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter text"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close")),
              TextButton(onPressed: () {}, child: Text("Ok")),
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
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
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
