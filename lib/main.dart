import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(GoalkeeperStatsApp());
}

class GoalkeeperStatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stats de arquero',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}
