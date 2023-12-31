import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  State<MyHomePage> createState() => SplashPage();
}

class SplashPage extends State<MyHomePage> {
  static const IS_LOGGED_IN = "is_logged_in";

  @override
  void initState() {
    super.initState();

    getLoginValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade50,
        child: Center(
          child: Text(
            "Loading...",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void getLoginValue() async {
    var mPrefs = await SharedPreferences.getInstance();
    var isLoggedIn = mPrefs.getBool(IS_LOGGED_IN);

    Timer(
      Duration(seconds: 2),
      () {
        if (isLoggedIn != null) {
          if (isLoggedIn) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ));
          }
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ));
        }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  var mailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextField(
                controller: mailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2))),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2))),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  if (mailController.text.isEmpty) {
                    print("mail not valid");

                    Fluttertoast.showToast(msg: "Enter valid Email Address");
                  } else if (passwordController.text.isEmpty) {
                    print("password not valid");

                    Fluttertoast.showToast(msg: "Enter valid Password");
                  } else {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ));

                    saveLoginValues();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Text("Login"),
                ))
          ],
        ),
      ),
    );
  }

  void saveLoginValues() async {
    var email = mailController.text.toString();
    var password = passwordController.text.toString();

    var mPrefs = await SharedPreferences.getInstance();
    mPrefs.setString("email", email);
    mPrefs.setString("password", password);
    mPrefs.setBool(SplashPage.IS_LOGGED_IN, true);
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Center(
          child: Icon(size: 100, Icons.home, color: Colors.blue),
        ),
      ),
    );
  }
}
