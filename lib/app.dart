import 'package:flutter/material.dart';
import 'package:split_the_bill/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Split the bill',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,

        ),
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
