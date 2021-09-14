import 'dart:async';
import 'package:calculator/public/constants.dart';
import 'package:calculator/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  bool _visible = true;

  startTime() async {
    return new Timer(Duration(seconds: 3), toNextPage);
  }

  void toNextPage() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen()));
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 3));
    animation = new CurvedAnimation(
        parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => this.setState(() {}));
    animationController!.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: body(context)));
  }

  Widget body(BuildContext context) {
    return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Center(
            child: Image.asset(
          'assets/images/icon.png',
          fit: BoxFit.cover,
          height: 240.0,
        )));
  }
}
