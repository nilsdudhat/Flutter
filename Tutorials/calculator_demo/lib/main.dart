import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var textField1Controller = TextEditingController();
  var textField2Controller = TextEditingController();

  var result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade50,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: textField1Controller,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: textField2Controller,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () {
                        var value1 = int.parse(textField1Controller.text.toString());
                        var value2 = int.parse(textField2Controller.text.toString());

                        var sum = value1 + value2;

                        result = "The sum of $value1 and $value2 is $sum";

                        setState(() {

                        });
                      }, child: Text("Add")),
                      ElevatedButton(onPressed: () {
                        var value1 = int.parse(textField1Controller.text.toString());
                        var value2 = int.parse(textField2Controller.text.toString());

                        var subtract = value1 - value2;

                        result = "The subtraction of $value1 and $value2 is $subtract";

                        setState(() {

                        });
                      }, child: Text("Subtract")),
                      ElevatedButton(onPressed: () {
                        var value1 = int.parse(textField1Controller.text.toString());
                        var value2 = int.parse(textField2Controller.text.toString());

                        var multiply = value1 * value2;

                        result = "The multiply of $value1 and $value2 is $multiply";

                        setState(() {

                        });
                      }, child: Text("Multiply")),
                      ElevatedButton(onPressed: () {
                        var value1 = int.parse(textField1Controller.text.toString());
                        var value2 = int.parse(textField2Controller.text.toString());

                        var divide = value1 / value2;

                        result = "The result of $value1 divided by $value2 is $divide";

                        setState(() {

                        });
                      }, child: Text("Divide")),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(result, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
