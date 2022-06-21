import 'package:flutter/material.dart';
import 'package:scheduler/screens/home/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize:
                  MaterialStateProperty.all(const Size(double.infinity, 50)))),
        primarySwatch: Colors.purple,
      ),
      home: HomeView(),
    );
  }
}


