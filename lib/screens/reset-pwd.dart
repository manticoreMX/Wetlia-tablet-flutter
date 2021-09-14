import 'package:calculator/apis/auth.dart';
import 'package:calculator/components/custom-button.dart';
import 'package:calculator/components/custom-input.dart';
import 'package:calculator/public/colors.dart';
import 'package:calculator/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ResetScreen extends StatefulWidget {
  @override
  ResetScreenState createState() => ResetScreenState();
}

class ResetScreenState extends State<ResetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: resetPwdBody()));
  }

  Widget resetPwdBody() {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/back1.jpg'))),
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Image.asset('assets/images/logo-l.png'),
                Text(
                  'Restablecer Contraseña',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 360,
                  height: 220,
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
                      SizedBox(height: 40),
                      CustomButton(
                          text: 'ENVIAR',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.white,
                          backColor: mainColor,
                          onPressed: doReset)
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Image.asset('assets/images/logo.png', width: 40, height: 40)
              ]))),
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(
        color: mainColor,
      ),
    );
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

  doReset() async {
    if (emailController.text == '')
      return showSnackbar('Por favor ingrese la correo electrónico.', context);
    if (!emailValidator(emailController.text))
      return showSnackbar(
          'El correo electrónico no tiene un formato válido.', context);
    setState(() => isLoading = true);
    var res = await AuthApi.sendResetInstruction(emailController.text);
    setState(() => isLoading = false);

    if (res.toString() == 'Wrong email')
      return showSnackbar(
          'El correo no pertenece a alguna cuenta registrada.', context);
    else {
      showSnackbar('Revisa tu correo.', context);
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
    }
    print(res);
  }
}
