import 'package:calculator/public/constants.dart';
import 'package:calculator/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Houseace',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      routes: <String, WidgetBuilder>{
        // SPLASH: (BuildContext context) => new SplashScreen(),
        LOGIN: (BuildContext context) => new LoginScreen(),
        // HOME: (BuildContext context) => new HomeScreen(),
      },
      initialRoute: LOGIN,
    );
  }
}
