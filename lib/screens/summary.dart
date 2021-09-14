import 'dart:convert';
import 'package:calculator/widgets/summary-item.dart';
import 'package:calculator/apis/home.dart';
import 'package:calculator/public/colors.dart';
import 'package:calculator/widgets/button.dart';
import 'package:calculator/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryScreen extends StatefulWidget {
  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool loading = false;
  String cliente = '';
  String precio = '';
  String descuento = '';
  String distribuidor = '';
  String rentabilidad = '';
  void initData() {
    SharedPreferences.getInstance().then((prefs) {
      dynamic propuesta = jsonDecode(prefs.getString('Propuesta')!);
      setState(() {
        cliente = prefs.getString('cliente') ?? '';
        precio = propuesta['NuevoPrecioPromedio'];
        descuento = propuesta['NuevoDescuentoSobreFullPrice'];
        distribuidor = prefs.getString('distribudor') ?? '';
        rentabilidad = propuesta['DiferencialEnValores'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: LoadingOverlay(
          isLoading: loading,
          opacity: 0.5,
          color: mainColor,
          progressIndicator: CircularProgressIndicator(),
          child: summaryBody(),
        ),
      ),
    );
  }

  Widget summaryBody() {
    var landscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(16)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(landscape
                                ? 'assets/images/back1.jpg'
                                : 'assets/images/back1.jpg'))),
                    child: Column(
                      children: [
                        Image.asset(landscape
                            ? 'assets/images/header-tablet.png'
                            : 'assets/images/header-phone.png'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset('assets/images/product.png',
                                width: 140),
                            Image.asset('assets/images/logo-m.png', width: 180),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    )),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      Text(
                        'Resumen',
                        style: TextStyle(color: Colors.grey, fontSize: 32),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(color: mainColor),
                        child: Column(
                          children: [
                            SummaryItem(title: 'Cliente', value: cliente),
                            SummaryItem(
                                title: 'Nuevo precio promedio x vial',
                                value: precio),
                            SummaryItem(
                                title: 'Descuento vs Full Price',
                                value: descuento),
                            SummaryItem(
                                title: 'Rentabilidad total',
                                value: rentabilidad),
                            SummaryItem(
                                title: 'Distribuidor', value: distribuidor),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(landscape
                        ? 'assets/images/back2.png'
                        : 'assets/images/back2.png'))),
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(16))),
                ),
                SizedBox(height: 12),
                Wrap(
                  runSpacing: 12,
                  children: [
                    Button(
                        iconName: 'save', title: 'Guardar', onPressed: onSave),
                    Button(
                        iconName: 'email', title: 'Enviar', onPressed: onSend),
                    Button(iconName: 'back', title: 'Atrás', onPressed: onBack),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  onSend() async {
    setState(() => loading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic propuesta = jsonDecode(prefs.getString('Propuesta')!);
    dynamic data = {
      'Email': propuesta['Email'],
      'Cliente': {'Cliente': cliente},
      'Informacion': {
        'Distribuidor': distribuidor,
        'Opcion': propuesta['CondicionComercialPropuesta'],
        'X1': propuesta['X1'],
        'X2': propuesta['X2'],
        'FechaInicio': propuesta['FechaInicio'],
        'FechaFin': propuesta['FechaFin'],
        'NuevoDescuentoSobreFullPrice':
            propuesta['NuevoDescuentoSobreFullPrice'],
        'CondicionComercialPropuesta': propuesta['CondicionComercialPropuesta'],
        'VialesEsperados': propuesta['VialesEsperados'],
        'PrecioPromedio': propuesta['NuevoPrecioPromedio'],
        'Diferencial': propuesta['DiferencialEnValores'],
      }
    };
    var res = await MainApi.sendEmail(data);
    setState(() => loading = false);
    if (res.toString() == 'Mensaje enviado')
      return showSnackbar('Email enviado.', context);
    else
      return showSnackbar(
          'Ha ocurrido un error, revisa tu conexión de internet.', context);
  }

  onBack() {
    Navigator.pop(context);
  }

  onNext() {}

  onSave() async {
    setState(() => loading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic propuesta = jsonDecode(prefs.getString('Propuesta')!);
    dynamic data = {
      'Distribuidor': {'Distribuidor': distribuidor},
      'Informacion': propuesta
    };
    var res = await MainApi.saveData(data);
    setState(() => loading = false);

    if (res.toString() == 'Campos actualizados') {
      return showSnackbar(
          'La información ha sido actualizada en la base de datos.', context);
    } else {
      showSnackbar(
          'Ha ocurrido un error, revisa tu conexión de internet.', context);
    }
  }
}
