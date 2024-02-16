import 'package:chat_demo_for_swazz/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

ThemeData themeData = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
);

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: themeData.scaffoldBackgroundColor,
      // navigation bar color
      statusBarColor: themeData.scaffoldBackgroundColor, // status bar color
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: SwazzHome(),
    ),
  );
}

class SwazzHome extends ConsumerStatefulWidget {
  const SwazzHome({super.key});

  @override
  ConsumerState<SwazzHome> createState() => _SwazzHomeState();
}

class _SwazzHomeState extends ConsumerState<SwazzHome> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        darkTheme: themeData,
        themeMode: ThemeMode.dark,
        home: const SplashPage(),
      ),
    );
  }
}
