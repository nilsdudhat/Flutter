import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var textEditController = TextEditingController();
  var textValue = "";
  static const KEYNAME = "name";

  @override
  void initState() {
    super.initState();

    getSavedValue();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                controller: textEditController,
                decoration: InputDecoration(
                  labelText: "Value",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 2))),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(onPressed: () async {
              textValue = textEditController.text.toString();

              var mPrefs = await SharedPreferences.getInstance();

              mPrefs.setString(KEYNAME, textValue);
              setState(() {

              });
            }, child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Text("Save"),
            )),
            SizedBox(
              height: 50,
            ),
            Text("Saved Value: $textValue")
          ],
        ),
      ),
    );
  }

  void getSavedValue() async {
    var mPrefs = await SharedPreferences.getInstance();
    textValue = mPrefs.getString(KEYNAME) ?? "No value saved";

    setState(() {

    });
  }
}
