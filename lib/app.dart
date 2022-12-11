import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/screens/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;

  final String defaultLocale = Platform.localeName;

  @override
  void initState() {
    if (defaultLocale.length > 1) {
      String first = defaultLocale.substring(0, 2);
      String last = defaultLocale.substring(
          defaultLocale.length - 2, defaultLocale.length);
      setState(() {
        locale = Locale(first, last == 'TW' ? 'TW' : '');
      });
      // Preferences.setString('languageCode', first);
      // if (last == 'TW') {
      //   Preferences.setString('countryCode', last);
      // }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Split the bill',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
        ),
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
        Locale('ja', ''),
        Locale('ru', ''),
        Locale('hi', ''),
        Locale('vi', ''),
        Locale('th', ''),
        Locale('es', ''),
        Locale('zh', 'TW'),
      ],
      locale: locale ?? const Locale('en', ''),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}