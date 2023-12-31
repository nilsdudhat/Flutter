import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var weightController = TextEditingController();
  var heightInchController = TextEditingController();
  var heightFootController = TextEditingController();

  var result = "";
  var bgColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BMI Calculator App"),
        ),
        body: Container(
          color: bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const FaIcon(FontAwesomeIcons.weightHanging),
                            ),
                            const Text(
                              "Weight: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              suffixText: "in Kgs.",
                              label: Text("Enter your Weight here")),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Icon(Icons.height),
                            ),
                            const Text(
                              "Height: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                decoration: const InputDecoration(
                                    suffixText: "'",
                                    label: Text("Enter your Height in Foot")),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 25,
                                    color: Colors.black),
                                controller: heightFootController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                decoration: const InputDecoration(
                                    suffixText: "''",
                                    label: Text("Enter your Height in Inch")),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 25,
                                    color: Colors.black),
                                controller: heightInchController,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(25),
                  child: ElevatedButton(
                      onPressed: () {
                        if ((heightFootController.text.toString() != "") &&
                            (heightInchController.text.toString() != "") &&
                            (weightController.text.toString() != "")) {
                          var heightInMetres = (int.parse(
                                      heightFootController.text.toString()) /
                                  3.28) +
                              (int.parse(heightInchController.text.toString()) /
                                  39.37);
                          var bmi = (int.parse(weightController.text.toString()) /
                                  (heightInMetres * heightInMetres));
                          setState(() {
                            result = "Your BMI value is ${bmi.toStringAsFixed(4)}";
                            if (bmi < 18.5) {
                              bgColor = Colors.grey;
                            } else if (bmi >=18.5 && bmi <= 25) {
                              bgColor = Colors.lightGreen;
                            } else if (bmi >25 && bmi <= 30) {
                              bgColor = Colors.redAccent;
                            } else if (bmi > 30) {
                              bgColor = Colors.red.shade800;
                            }
                          });
                        } else {
                          setState(() {
                            result = "Please fill all the Blanks!!";
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Calculate",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      )),
                ),
                Container(
                    margin: const EdgeInsets.all(25),
                    child: Text(
                      result,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ));
  }
}
