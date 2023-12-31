import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurpleAccent,
);

final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.deepPurpleAccent,
);

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((value) => {
            runApp(
              MaterialApp(
                debugShowCheckedModeBanner: false,
                darkTheme: ThemeData.dark().copyWith(
                  useMaterial3: true,
                  colorScheme: darkColorScheme,
                  appBarTheme: const AppBarTheme().copyWith(
                      backgroundColor: darkColorScheme.onPrimaryContainer,
                      foregroundColor: darkColorScheme.primaryContainer),
                  cardTheme: const CardTheme().copyWith(
                    color: darkColorScheme.secondaryContainer,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkColorScheme.secondaryContainer,
                      foregroundColor: darkColorScheme.onPrimaryContainer,
                    ),
                  ),
                  textTheme: ThemeData.dark().textTheme.copyWith(
                        titleLarge: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkColorScheme.onSecondaryContainer,
                          fontSize: 16,
                        ),
                      ),
                ),
                theme: ThemeData().copyWith(
                  useMaterial3: true,
                  colorScheme: colorScheme,
                  appBarTheme: const AppBarTheme().copyWith(
                      backgroundColor: colorScheme.onPrimaryContainer,
                      foregroundColor: colorScheme.primaryContainer),
                  cardTheme: const CardTheme().copyWith(
                    color: colorScheme.secondaryContainer,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  textTheme: ThemeData().textTheme.copyWith(
                        titleLarge: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                          fontSize: 16,
                        ),
                      ),
                ),
                themeMode: ThemeMode.system,
                home: const Expenses(),
              ));
          //   ),
          // });
}
