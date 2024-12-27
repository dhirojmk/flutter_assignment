import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('uploaded_images');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management App',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: HomePage(),
    );
  }
}
