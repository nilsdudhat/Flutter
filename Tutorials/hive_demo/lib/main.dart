import 'package:flutter/material.dart';
import 'package:hive_demo/pages/splash_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'database/student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashPage(),
        );
      },
      maxTabletWidth: 900,
    );
  }
}
