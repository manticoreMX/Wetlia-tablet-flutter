import 'package:calculator/public/constants.dart';
import 'package:calculator/screens/login.dart';
import 'package:calculator/screens/reset-pwd.dart';
import 'package:calculator/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        // SPLASH: (BuildContext context) => new SplashScreen(),
        LOGIN: (BuildContext context) => new LoginScreen(),
        RESET: (BuildContext context) => new ResetScreen(),

        SPLASH: (BuildContext context) => new SplashScreen(),
      },
      initialRoute: SPLASH,
      home: SplashScreen(),
    );
  }
}
