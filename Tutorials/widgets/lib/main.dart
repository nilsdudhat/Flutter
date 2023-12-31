import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:widgets/custom_widgets.dart';
import 'package:widgets/utils/style_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 30,
              fontFamily: "Regular",
              fontStyle: FontStyle.normal,
              color: Colors.black),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
          bodySmall: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              fontStyle: FontStyle.normal,
              fontFamily: "Regular",
              color: Colors.black),
        ),
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
  State<MyHomePage> createState() => TextInputDemo();
}

class RippleAnimationDemo extends State<MyHomePage> with SingleTickerProviderStateMixin {

  var sizeList = [100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0];

  late AnimationController _animationController;
  // late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 5), lowerBound: 0.2);
    // _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.addListener(() {
      setState(() {

      });
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ripple Animation Demo"),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: sizeList.map((size) {
            return Container(
              width: size*_animationController.value,
              height: size*_animationController.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(1.0-_animationController.value)
              ),
            );
          }).toList()
        ),
      ),
    );
  }

}

class TweenAnimationDemo extends State<MyHomePage> with SingleTickerProviderStateMixin {

  late Animation sizeAnimation;
  late Animation colorAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this, duration: Duration(seconds: 4));
    sizeAnimation = Tween(begin: 500.0, end: 50.0).animate(animationController);
    colorAnimation = ColorTween(begin: Colors.greenAccent, end: Colors.orange).animate(animationController);

    animationController.addListener(() { 
      print(sizeAnimation.value);
      setState(() {

      });
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tween Animation Demo"),
      ),
      body: Center(
        child: Container(
          color: colorAnimation.value,
          height: sizeAnimation.value,
          width: sizeAnimation.value
        ),
      ),
    );
  }

}

class ListModelMapDemo extends State<MyHomePage> {
  var profileList = [
    {"name": "Nilesh", "age": "26", "parent": "Shivabhai"},
    {"name": "Manoj", "age": "30", "parent": "Shivabhai"},
    {"name": "Daya", "age": "32", "parent": "Shivabhai"},
    {"name": "Trupti", "age": "34", "parent": "Shivabhai"},
    {"name": "Asmita", "age": "36", "parent": "Shivabhai"},
    {"name": "Geeta", "age": "40", "parent": "Shivabhai"},
    {"name": "Rinkal", "age": "26", "parent": "Govindbhai"},
    {"name": "Bhavesh", "age": "28", "parent": "Govindbhai"},
    {"name": "Nilam", "age": "32", "parent": "Govindbhai"},
    {"name": "Dhruvil", "age": "22", "parent": "Jagdeeshbhai"},
    {"name": "Drashti", "age": "18", "parent": "Jagdeeshbhai"},
    {"name": "Bhavya", "age": "12", "parent": "Bharatbhai"},
    {"name": "Sanjana", "age": "16", "parent": "Bharatbhai"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListModel Map Demo"),
      ),
      body: ListView(
          children: profileList
              .map((value) => ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text(value['name'].toString()),
                    subtitle: Text(value['parent'].toString()),
                    trailing:
                        CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                            radius: 12,
                            child: Text(value['age'].toString(), style: TextStyle(color: Colors.white),)),
                  ))
              .toList()),
    );
  }
}

class ListMapDemo extends State<MyHomePage> {
  var nameList = [
    "Nilesh",
    "Manoj",
    "Daya",
    "Trupti",
    "Asmita",
    "Geeta",
    "Rinkal",
    "Bhavesh",
    "Nilam",
    "Dhruvil",
    "Drashti",
    "Sanjana",
    "Bhavya"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Map Demo"),
      ),
      body: Container(
        child: ListView(
            children: nameList.map((value) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange.shade100),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(value,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900)),
              )),
            ),
          );
        }).toList()),
      ),
    );
  }
}

class GradientDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gradient Demo"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      // Linear Gradient Example
                      colors: [Color(0xff009FFF), Color(0xffec2F4B)],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                      stops: [0.0, 0.2])),
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    // Radial Gradient Example
                    colors: [Color(0xfff9c58d), Color(0xfff7f779)],
                    center: Alignment.bottomCenter)),
          ))
        ],
      ),
    );
  }
}

class ClipRRectDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ClipRRect Demo"),
      ),
      body: Container(
        color: Colors.orange.shade300,
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(50, 100),
                bottomRight: Radius.elliptical(100, 50)),
            child: Image.asset(
              "assets/images/flutter.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

class ListWheelDemo extends State<MyHomePage> {
  var list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Wheel Demo"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListWheelScrollView(
            itemExtent: 200,
            children: list
                .map((value) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (value % 2 == 1) ? Colors.black : Colors.orange,
                      ),
                      child: Center(
                          child: Text(
                        "$value",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      )),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class HeroAnimationDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hero Animation Demo"),
      ),
      body: Center(
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return DetailPage();
                },
              ));
            },
            child: Hero(
                tag: "image",
                child: FaIcon(
                  FontAwesomeIcons.amazon,
                  size: 100,
                ))),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hero Animation Demo"),
      ),
      body: Hero(
          tag: "image",
          child: FaIcon(
            FontAwesomeIcons.amazon,
            size: 400,
          )),
    );
  }
}

class CrossFadeAnimationDemo extends State<MyHomePage> {
  var toggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cross Fade Animation"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedCrossFade(
                firstChild: FaIcon(FontAwesomeIcons.airbnb, size: 200),
                secondChild: FaIcon(FontAwesomeIcons.amazon, size: 200),
                crossFadeState: toggle
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(seconds: 2),
                // reverseDuration: Duration(seconds: 3),
                firstCurve: Curves.bounceOut,
                secondCurve: Curves.bounceOut,
              ),
              SizedBox(
                height: 50,
              ),
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (toggle) {
                        toggle = false;
                      } else {
                        toggle = true;
                      }
                    });
                  },
                  child: Text("Animate"))
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedOpacityDemo extends State<MyHomePage> {
  var opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Opacity Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.blue,
                ),
                opacity: opacity,
                duration: Duration(seconds: 2)),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (opacity == 1.0) {
                      opacity = 0.2;
                    } else {
                      opacity = 1.0;
                    }
                  });
                },
                child: Text("Animate"))
          ],
        ),
      ),
    );
  }
}

class AnimatedContainerDemo extends State<MyHomePage> {
  var _width = 100.0;
  var _height = 100.0;

  var toggle = false;

  var bgColor = Colors.red;

  var decor = BoxDecoration(
      color: Colors.green, borderRadius: BorderRadius.circular(5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Container Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
                width: _width,
                height: _height,
                curve: Curves.bounceOut,
                decoration: decor,
                duration: Duration(seconds: 1)),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () {
                  if (toggle) {
                    _width = 100;
                    _height = 100;
                    decor = BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.green);
                    toggle = false;
                  } else {
                    _width = 200;
                    _height = 200;
                    decor = BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red);
                    toggle = true;
                  }
                  setState(() {});
                },
                child: Text("Animate"))
          ],
        ),
      ),
    );
  }
}

class RangeSliderDemo extends State<MyHomePage> {
  RangeValues values = RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    RangeLabels labels =
        RangeLabels(values.start.toString(), values.end.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Range Slider Demo"),
      ),
      body: Center(
        child: RangeSlider(
          labels: labels,
          divisions: 20,
          min: 0,
          max: 100,
          activeColor: Colors.deepOrange,
          inactiveColor: Colors.deepOrange.shade100,
          onChanged: (value) {
            values = value;

            setState(() {
              print(
                  "start selected value is ${values.start} and end selected value is ${values.end}");
            });
          },
          values: values,
        ),
      ),
    );
  }
}

class ConstraintBoxWidgetDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Constraint Box Demo"),
      ),
      body: Container(
        child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 75, minHeight: 50, maxWidth: 100, minWidth: 50),
            child: Container(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  "Hi there, My name is Nilesh Dudhat... How can I help you?"),
            )),
      ),
    );
  }
}

class PositionedWidgetDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Positioned Widget Demo"),
      ),
      body: Container(
        height: 200,
        width: 300,
        color: Colors.indigo,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.deepOrange,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IconWidgetDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Icon Widget Demo"),
      ),
      body: Center(
        child: Column(
          children: [
            Icon(
              Icons.access_alarm_sharp,
              color: Colors.blue,
              size: 100,
            ),
            FaIcon(
              FontAwesomeIcons.amazonPay,
              size: 50,
              color: Colors.blue,
            ),
            FaIcon(
              FontAwesomeIcons.googlePlay,
              size: 50,
              color: Colors.blue,
            ),
            FaIcon(
              FontAwesomeIcons.anchorLock,
              size: 50,
              color: Colors.blue,
            ),
            FaIcon(
              FontAwesomeIcons.airbnb,
              size: 50,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}

class RichTextDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rich Text Demo"),
      ),
      body: RichText(
        text: const TextSpan(
            style: TextStyle(color: Colors.grey, fontSize: 15),
            children: [
              TextSpan(text: "Hello "),
              TextSpan(
                  text: "World!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                      fontStyle: FontStyle.normal)),
              TextSpan(text: "... Welcome to "),
              TextSpan(
                  text: "Flutter",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Regular",
                      backgroundColor: Colors.yellow))
            ]),
      ),
    );
  }
}

class WrapWidgetDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wrap Widget Demo"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          direction: Axis.vertical,
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.black38,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.amberAccent,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.teal,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.lime,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.grey,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.deepPurple,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.black,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.brown,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.yellow,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.cyan,
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomStyleWidgetDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Custom Style Demo")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 50,
                child: RoundedButton(
                  btnName: "Rounded Button",
                  icon: Icon(Icons.add_circle),
                  voidCallback: () {
                    print("Button Clicked");
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              Container(
                width: 200,
                height: 50,
                child: RoundedButton(
                  btnName: "Rounded Button",
                  textStyle: getRequiredTextStyle(),
                  bgColor: Colors.green,
                  voidCallback: () {
                    print("Click Here");
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class StackDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stack Demo"),
      ),
      body: Container(
        height: 300,
        width: 300,
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.blue,
            ),
            Positioned(
              left: 50,
              top: 50,
              child: Container(
                height: 200,
                width: 200,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWidgetDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Widget Demo"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(flex: 2, child: ThirdCustomWidget()),
            Expanded(flex: 5, child: SecondCustomWidget()),
            Expanded(flex: 5, child: FirstCustomWidget()),
          ],
        ),
      ),
    );
  }
}

class ThirdCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
            ),
          )
        ],
      ),
    ));
  }
}

class SecondCustomWidget extends StatelessWidget {
  var nameList = ["Geeta", "Asmita", "Trupti", "Daya", "Manoj", "Nilesh"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Text(nameList[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                    height: 100,
                    thickness: 0.1,
                  );
                },
                itemCount: nameList.length)));
  }
}

class FirstCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 4),
        itemBuilder: (context, index) {
          return CircleAvatar(
            backgroundColor: Colors.blue,
          );
        },
      ),
    ));
  }
}

class GridViewBuilderDemo extends State<MyHomePage> {
  var colorList = [
    Colors.blue,
    Colors.red,
    Colors.grey,
    Colors.amberAccent,
    Colors.green,
    Colors.teal,
    Colors.black,
    Colors.blueGrey
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView Builder Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: colorList.length,
          itemBuilder: (context, index) {
            return Container(
              color: colorList[index],
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 4),
          /*gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 10, mainAxisSpacing: 10, maxCrossAxisExtent: 150),*/
        ),
      ),
    );
  }
}

class GridViewExtentDemo extends State<MyHomePage> {
  var colorList = [
    Colors.blue,
    Colors.red,
    Colors.grey,
    Colors.amberAccent,
    Colors.green,
    Colors.teal,
    Colors.black,
    Colors.blueGrey
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView Extent"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.extent(
          maxCrossAxisExtent: 150,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            Container(
              color: colorList[0],
            ),
            Container(
              color: colorList[1],
            ),
            Container(
              color: colorList[2],
            ),
            Container(
              color: colorList[3],
            ),
            Container(
              color: colorList[4],
            ),
            Container(
              color: colorList[5],
            ),
            Container(
              color: colorList[6],
            ),
            Container(
              color: colorList[7],
            )
          ],
        ),
      ),
    );
  }
}

class GridViewDemo extends State<MyHomePage> {
  var colorList = [
    Colors.blue,
    Colors.red,
    Colors.grey,
    Colors.amberAccent,
    Colors.green,
    Colors.teal,
    Colors.black,
    Colors.blueGrey
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            Container(
              color: colorList[0],
            ),
            Container(
              color: colorList[1],
            ),
            Container(
              color: colorList[2],
            ),
            Container(
              color: colorList[3],
            ),
            Container(
              color: colorList[4],
            ),
            Container(
              color: colorList[5],
            ),
            Container(
              color: colorList[6],
            ),
            Container(
              color: colorList[7],
            )
          ],
        ),
      ),
    );
  }
}

class DatePickerDemo extends State<MyHomePage> {
  String selectedDate = "";
  String selectedTime = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Date Picker Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Select Date $selectedDate"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        DateTime? datePicker = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime(2025));

                        if (datePicker != null) {
                          selectedDate =
                              DateFormat("yMMMMd").format(datePicker);
                          print("Selected Date: " +
                              DateFormat("yMMMMd").format(datePicker));

                          setState(() {});
                        }
                      },
                      child: Text("Date")),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Select Time $selectedTime"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? timePicker = await showTimePicker(
                            initialEntryMode: TimePickerEntryMode.input,
                            context: context,
                            initialTime: TimeOfDay.now());

                        if (timePicker != null) {
                          selectedTime = timePicker.hour.toString() +
                              ":" +
                              timePicker.minute.toString();
                          print(
                              "Seleted Time + ${timePicker.hour}:${timePicker.minute}");

                          setState(() {});
                        }
                      },
                      child: Text("Time")),
                ),
              ]),
            ],
          ),
        ));
  }
}

class DateTimeDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Current Date and Time Demo"),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Date: ${date}"),
              Text("weekday: ${date.weekday}"),
              Text("Day: ${date.day}"),
              Text("Month: ${date.month}"),
              Text("Year: ${date.year}"),
              Text("Time: ${date.hour}:${date.minute}:${date.second}"),
              Text("Date Format : ${DateFormat("yMMMMd").format(date)}"),
              ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text("Get Time"))
            ],
          ),
        ),
      ),
    );
  }
}

class TextInputDemo extends State<MyHomePage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Input Demo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
            child: TextField(
                controller: emailController,
                enabled: true,
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                    hintText: "Enter Email",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.blue, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.black, width: 1)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Colors.black38, width: 1)),
                    suffixIcon: Icon(
                      Icons.add_circle,
                      color: Colors.lightBlue,
                    ),
                    suffixText: "Plus",
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        print("Email Pressed");
                      },
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
            child: TextField(
              obscureText: true,
              obscuringCharacter: "*",
              controller: passController,
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                  hintText: "Enter Password",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black38, width: 1))),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String email = emailController.text;
              String password = passController.text;

              print("email: $email" + " ==== password: $password");
            },
            child: Text("Login"),
          )
        ],
      ),
    );
  }
}

class CardDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Demo"),
      ),
      body: Center(
        child: Card(
            elevation: 10,
            shadowColor: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Card View here",
                style: TextStyle(fontSize: 25),
              ),
            )),
      ),
    );
  }
}

class StyleDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Style Demo"),
      ),
      body: Column(
        children: [
          Text(
            "Hii, My name is Nilesh",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.purple,
                fontWeight: FontWeight.w100,
                fontSize: 10,
                fontFamily: "Regular"),
          ),
          Text(
            "Hii, My name is Nilesh",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.lightBlueAccent, fontWeight: FontWeight.w900),
          ),
          Text(
            "Hii, My name is Nilesh",
            style: getRequiredTextStyle(
                textColor: Colors.red,
                fontSize: 52,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal),
          ),
          Text(
            "Hii, My name is Nilesh",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class CustomFontDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Font"),
      ),
      body: Text(
        "Hi, Custom Fonts Applied here",
        style: TextStyle(
            fontFamily: "Regular", fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class CircleAvatarDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Circle Avatar"),
      ),
      body: Center(
        child: CircleAvatar(
          child: Column(
            children: [
              Container(
                  height: 75,
                  width: 75,
                  child: Image.asset("assets/images/logo.png")),
              Text("Main Dart")
            ],
          ),
          backgroundColor: Colors.lightBlueAccent,
          maxRadius: 100,
        ),
      ),
    );
  }
}

class ListTileDemo extends State<MyHomePage> {
  var nameList = [
    "Geeta",
    "Asmita",
    "Trupti",
    "Daya",
    "Manoj",
    "Nilesh",
    "Nilam",
    "Bhavesh",
    "Rinkal",
    "Dhruvil",
    "Drashti",
    "Sanjana",
    "Bhavya"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListTile Demo"),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text("${index + 1}"),
              trailing: Icon(Icons.add_circle),
              title: Text(nameList[index].toString()),
              subtitle: Text("Number"),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 25,
              thickness: 1,
            );
          },
          itemCount: nameList.length),
    );
  }
}

class MarginPaddingDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Margin"),
      ),
      body: Text(
        "My Name is Nilesh.",
        style: TextStyle(),
      ),
    );
  }
}

class ExpandedDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expanded"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: 100,
              width: 50,
              color: Colors.teal,
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              width: 50,
              margin: EdgeInsets.all(10.0),
              color: Colors.amber,
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              width: 50,
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 100,
              width: 50,
              color: Colors.grey,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 100,
              width: 50,
              color: Colors.lightBlueAccent,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 100,
              width: 50,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

class DecorationDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Decoration"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.amber.shade300,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.red.shade900,
                // borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: Colors.blue,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.teal.shade50,
                      spreadRadius: 10)
                ],
                shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class ListViewSeparatedDemo extends State<MyHomePage> {
  var nameList = [
    "Geeta",
    "Asmita",
    "Trupti",
    "Daya",
    "Manoj",
    "Nilesh",
    "Nilam",
    "Bhavesh",
    "Rinkal",
    "Dhruvil",
    "Drashti",
    "Sanjana",
    "Bhavya"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Text(
            nameList[index],
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          );
        },
        itemCount: nameList.length,
        reverse: false,
        scrollDirection: Axis.vertical,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 50,
            color: Colors.black,
            thickness: 0.1,
          );
        },
      ),
    );
  }
}

class ListViewBuilderDemo extends State<MyHomePage> {
  var nameList = [
    "Geeta",
    "Asmita",
    "Trupti",
    "Daya",
    "Manoj",
    "Nilesh",
    "Nilam",
    "Bhavesh",
    "Rinkal",
    "Dhruvil",
    "Drashti",
    "Sanjana",
    "Bhavya"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Text(
            nameList[index],
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          );
        },
        itemCount: nameList.length,
        reverse: false,
        itemExtent: 100,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}

class ListViewDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        itemExtent: 100,
        scrollDirection: Axis.vertical,
        reverse: true,
        children: const [
          Text(
            "Nilesh",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Manoj",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Dhruvil",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Bhavesh",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Bhavya",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Geeta",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Asmita",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Trupti",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Daya",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Nilam",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Rinkal",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Drashti",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "Sanjana",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class ScrollViewDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 200,
                          width: 200,
                          color: Colors.grey),
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 200,
                          width: 200,
                          color: Colors.grey),
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 200,
                          width: 200,
                          color: Colors.grey),
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 200,
                          width: 200,
                          color: Colors.grey),
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 200,
                          width: 200,
                          color: Colors.grey)
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InkWellDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: InkWell(
          onTap: () {
            print("Single Tap");
          },
          onDoubleTap: () {
            print("Double Tap");
          },
          onLongPress: () {
            print("Long Press");
          },
          child: Container(
            height: 200,
            width: 200,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class RowDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Normal"),
      ),
      body: Container(
        width: 300,
        color: Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "1",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              "2",
              style: TextStyle(fontSize: 25),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Hello")),
            Text(
              "3",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              "4",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDemo extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Normal"),
        ),
        body: Center(
            child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/flutter.png"))));
  }
}
