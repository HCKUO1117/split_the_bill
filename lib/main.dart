import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/app.dart';
import 'package:split_the_bill/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
