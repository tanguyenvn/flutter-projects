import 'package:flutter/material.dart';
import 'package:unit_converter/category_route.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CategoryRoute(),
    );
  }
}
