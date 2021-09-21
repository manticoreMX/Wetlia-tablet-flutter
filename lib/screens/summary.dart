import 'dart:convert';
import 'package:calculator/widgets/summary-item.dart';
import 'package:calculator/apis/home.dart';
import 'package:calculator/public/colors.dart';
import 'package:calculator/widgets/button.dart';
import 'package:calculator/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SummaryScreen extends StatefulWidget {
  final dynamic propuesta;
  final String cliente;
  final String distribudor;
  SummaryScreen(
      {required this.propuesta,
      required this.cliente,
      required this.distribudor});
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
    dynamic propuesta = jsonDecode(widget.propuesta);
    setState(() {
      cliente = widget.cliente;
      precio = propuesta['NuevoPrecioPromedio'];
      descuento = propuesta['NuevoDescuentoSobreFullPrice'];
      distribuidor = widget.distribudor;
      rentabilidad = propuesta['DiferencialEnValores'];
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
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(landscape
                    ? 'assets/images/back2.png'
                    : 'assets/images/back2.png'))),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.width * 0.284,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16)),
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage(landscape
                                    ? 'assets/images/back-tablet-1.jpg'
                                    : 'assets/images/back-tablet-1.jpg'))),
                        child: Column(
                          children: [
                            Image.asset(landscape
                                ? 'assets/images/header-tablet.png'
                                : 'assets/images/header-tablet.png'),
                          ],
                        )),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          Text(
                            'Resumen',
                            style: TextStyle(color: Colors.grey, fontSize: 32),
                          ),
                          SizedBox(height: 12),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
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
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //
                padding: EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16))),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      runSpacing: 12,
                      children: [
                        Button(
                            iconName: 'back',
                            title: 'Atrás',
                            onPressed: onBack),
                        Button(
                            iconName: 'save',
                            title: 'Guardar',
                            onPressed: onSave),
                        Button(
                            iconName: 'email',
                            title: 'Enviar',
                            onPressed: onSend),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  onSend() async {
    setState(() => loading = true);
    dynamic propuesta = widget.propuesta;

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
    dynamic propuesta = widget.propuesta;
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
