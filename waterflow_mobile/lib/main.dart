import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WaterFlow-Mobile'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: 233,
        height: 444,
        color: Colors.blue,
      ),
    );
  }
}
