import 'dart:convert';

import 'package:calculator/apis/auth.dart';
import 'package:calculator/components/custom-button.dart';
import 'package:calculator/components/custom-input.dart';
import 'package:calculator/public/colors.dart';
import 'package:calculator/public/constants.dart';
import 'package:calculator/screens/home.dart';
import 'package:calculator/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: loginBody(),
    ));
  }

  Widget loginBody() {
    return LoadingOverlay(
        isLoading: isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(color: mainColor),
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/back1.jpg'))),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Image.asset('assets/images/logo-m.png'),
                  Text(
                    'Iniciar sesión',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 360,
                    height: 340,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        CustomInputField(
                          controller: emailController,
                          labelText: 'Correo electrónico',
                          textInputType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 32),
                        CustomInputField(
                          controller: passwordController,
                          labelText: 'Contraseña',
                          obscureText: true,
                          textInputType: TextInputType.visiblePassword,
                        ),
                        SizedBox(height: 32),
                        CustomButton(
                            text: '¿Olvidaste tu contraseña?',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.blue,
                            backColor: Colors.white,
                            width: 0,
                            onPressed: gotoReset),
                        SizedBox(height: 16),
                        CustomButton(
                            text: 'INGRESAR',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.white,
                            backColor: mainColor,
                            onPressed: doLogin)
                      ],
                    ),
                  ),
                  Image.asset('assets/images/logo.png', width: 40, height: 40)
                ]))));
  }

  bool emailValidator(String value) {
    String pattern =
        r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$";
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  doLogin() async {
    if (emailController.text == '')
      return showSnackbar('Por favor ingrese el correo electrónico.', context);
    if (passwordController.text == '')
      return showSnackbar('Por favor ingrese la contraseña.', context);
    if (!emailValidator(emailController.text))
      return showSnackbar(
          'El correo electrónico no tiene un formato válido.', context);
    setState(() => isLoading = true);
    var res =
        await AuthApi.login(emailController.text, passwordController.text);
    setState(() => isLoading = false);
    if (res.toString() == 'Wrong credential')
      return showSnackbar('Correo y/o contraseña incorrectos.', context);
    else {
      SharedPreferences.getInstance().then((pref) {
        dynamic resJson = jsonDecode(res);
        pref.setString('token', resJson['Token'].toString());
        pref.setString('data', resJson['Perfil']);
        pref.setString(
            'distribudor', jsonDecode(resJson['Perfil'])[0]['Nombre']);
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen()));
      });
    }
  }

  gotoReset() {
    Navigator.pushNamed(context, RESET);
  }
}
