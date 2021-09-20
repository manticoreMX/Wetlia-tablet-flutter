import 'dart:convert';
import 'package:calculator/apis/auth.dart';
import 'package:calculator/widgets/new-client.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:calculator/apis/home.dart';
import 'package:calculator/components/custom-dropdown.dart';
import 'package:calculator/components/custom-input.dart';
import 'package:calculator/components/dropdown.dart';
import 'package:calculator/public/colors.dart';
import 'package:calculator/public/constants.dart';
import 'package:calculator/widgets/button.dart';
import 'package:calculator/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData().then((res) async {
      if (res.toString() == '') {
      } else {
        res = jsonDecode(res);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Clientes', res['Clientes']);
        prefs.setString('Distribuidores', res['Distribuidores']);
        prefs.setString('PropuestaActual', res['PropuestaActual']);
        prefs.setString('FullPrice', res['FullPrice']);

        prefs.setString('aux_cca', '');
        prefs.setString('aux_ccp', '');
        prefs.setString('aux_x1a', '0');
        prefs.setString('aux_x1b', '0');
        prefs.setString('aux_x2a', '0');
        prefs.setString('aux_x2b', '0');
        prefs.setString('aux_vam2', _vam.text);
        prefs.setString('aux_cliente', clientId.toString());

        initData(res);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  dynamic getData() async {
    setState(() => loading = true);
    return await MainApi.getData();
  }

  void initData(res) {
    List<dynamic> distribudores = jsonDecode(res['Distribuidores']);
    List<dynamic> clientes = jsonDecode(res['Clientes']);

    List<String> clients = [];
    List<String> distributors = [];
    distribudores.forEach((element) {
      distributors.add(element['Distribuidor']);
    });
    distributors.add('Nuevo');
    clientes.forEach((element) {
      clients.add(element['Cliente']);
    });
    clients.add('Nuevo');
    setState(() {
      this._clients = clients;
      this._distributors = distributors;
      pUnitario = (jsonDecode(res['FullPrice'])[0]['FullPrice']).toDouble();
      _pUnitario.text = addComa(pUnitario);
      loading = false;
    });
  }

  void onDistributorChanged(int value) {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString('distribudor', _distributors[value]));
  }

  void onClientChanged(int value) {
    if (value == _clients.length - 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: NewClient(onPressed: onNewClient),
              ));
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('aux_cliente', (clientId = value).toString());
      prefs.setString('cliente', _clients[clientId]);
    });
  }

  void onNewClient(String name) {
    setState(() {
      _clients.insert(_clients.length - 1, name);
      clientId = _clients.length - 1;
    });
    SharedPreferences.getInstance()
        .then((pref) => pref.setString('cliente', name));
  }

  void ccaChanged(int value) {
    this.ccaIndex = value;
    calc();
  }

  void x1aChanged(String value) => calc();
  void x2aChanged(String value) => calc();
  void onVamChanged(String value) => calc();
  void onVemChanged(String value) => calc();
  void calc() {
    this.x1a = double.tryParse(_x1a.text) ?? 0;
    this.x2a = double.tryParse(_x2a.text) ?? 0;
    this.vam = double.tryParse(_vam.text) ?? 0;
    this.vem = double.tryParse(_vem.text) ?? 0;

    double pu = pUnitario;
    var aux_ppv = 0.0;
    switch (ccaIndex) {
      case 0:
        hidel();
        aux_ppv = pu.toDouble();
        break;
      case 1:
        hidel();
        aux_ppv = double.parse((37789.0 / 3.0).toStringAsFixed(2));
        break;
      case 2:
        hidel();
        aux_ppv = double.parse((5.0 * pu / 13.0).toStringAsFixed(2));
        break;
      case 3:
        hidel();
        aux_ppv = double.parse((10.0 * pu / 27.0).toStringAsFixed(2));
        break;
      case 5:
        e1Title = 'Tipo de condición comercial especial: % vs Full Price';
        x1aT = '%';
        x2aT = 'Full Price';
        showl();
        setState(() {
          _x2a.text = '23558.00';
          x2aReadOnly = true;
        });
        aux_ppv = double.parse(((pu * (100 - x1a)) / 100.0).toStringAsFixed(2));
        break;
      case 4:
        showl();
        e1Title = 'Tipo de condición comercial especial: X1 + X2';
        x1aT = 'X1';
        x2aT = 'X2';
        setState(() {
          x2aReadOnly = false;
          if (_x2a.text == '23558.00') _x2a.text = '0';
        });
        if (x1a + x2a != 0)
          aux_ppv = double.parse(((x1a * pu) / (x1a + x2a)).toStringAsFixed(2));
        else {
          return setNan();
        }

        break;
      default:
    }
    _ppva.text = addComa(aux_ppv);
    dynamic propAlg = evalPropuesta(aux_ppv);

    if (propAlg != null) {
      _dsfpa.text = (100 - (aux_ppv / pu) * 100).toStringAsFixed(0) + '%';
      double aux1 =
          (double.tryParse(_vem.text) ?? 0) * propAlg['Precio Promedio'];
      double aux2 = (double.tryParse(_vam.text) ?? 0) * aux_ppv.floor();
      _dev.text = addComa(aux1 - aux2);
    }
  }

  showl() {
    this.setState(() {
      showe1 = true;
      // _x1a.text = '0';
      // _x2a.text = '0';
    });
  }

  hidel() {
    this.setState(() {
      showe1 = false;
      _x2aPlaceholder = '';
    });
  }

  dynamic evalPropuesta(double val) {
    List<dynamic> prop = [
      {
        "Condicion": "Ful price",
        "Precio": 23558,
        "Precio Promedio": 23558,
        "Viales": 1,
        "VarvsFP": 0
      },
      {
        "Condicion": "10%",
        "Precio": 21202.20,
        "Precio Promedio": 21202.20,
        "Viales": 1,
        "VarvsFP": 10
      },
      {
        "Condicion": "20%",
        "Precio": 18846.4,
        "Precio Promedio": 18846.4,
        "Viales": 1,
        "VarvsFP": 20
      },
      {
        "Condicion": "3+1",
        "Precio": 70674,
        "Precio Promedio": 17668.5,
        "Viales": 4,
        "VarvsFP": 25
      },
      {
        "Condicion": "3+2",
        "Precio": 70674,
        "Precio Promedio": 14134.8,
        "Viales": 5,
        "VarvsFP": 40
      },
      {
        "Condicion": "5+4",
        "Precio": 117790,
        "Precio Promedio": 13087.78,
        "Viales": 9,
        "VarvsFP": 44
      },
      {
        "Condicion": "Tripack",
        "Precio": 37789,
        "Precio Promedio": 12596.33,
        "Viales": 3,
        "VarvsFP": 47
      },
      {
        "Condicion": "6+6",
        "Precio": 141348,
        "Precio Promedio": 11779,
        "Viales": 12,
        "VarvsFP": 50
      },
      {
        "Condicion": "8+10",
        "Precio": 188464,
        "Precio Promedio": 10470.22,
        "Viales": 18,
        "VarvsFP": 56
      },
      {
        "Condicion": "10+17",
        "Precio": 235580,
        "Precio Promedio": 8725.19,
        "Viales": 27,
        "VarvsFP": 63
      }
    ];
    dynamic j;
    for (var i = 0; i < prop.length; i++) {
      dynamic element = prop[i];
      j = element;
      if (element['Precio Promedio'] < val) {
        _ppve.text = addComa(element['Precio Promedio']);
        _dsfpe.text = element['VarvsFP'].toString() + '%';
        _ccp.text = element['Condicion'];
        return element;
      }
    }
    _ppve.text = addComa(j['Precio Promedio']);
    _dsfpe.text = j['VarvsFP'].toString() + '%';
    _ccp.text = j['Condicion'].toString();
    return j;
  }

  setNan() {
    _dsfpa.text = 'NaN';
    _dsfpe.text = '63%';
    _dev.text = 'NaN';
    _ppva.text = 'NaN';
    _ppve.text = '8725.19';
    _ccp.text = '10+17';
  }

  String addComa(val) {
    var r = (val.abs() % 1000).abs().toStringAsFixed(2);
    var m = (val / 1000).truncate();
    var l = r.split(".")[0].length;

    if (val > 999) {
      if (l == 2) {
        r = "0" + r;
      } else if (l == 1) {
        r = "00" + r;
      }
      return (m.toString() + "," + r);
    } else {
      return r;
    }
  }

  List<String> _distributors = [];
  List<String> _clients = [];
  int clientId = 0, distributorId = 0;
  double pUnitario = 0;
  bool loading = false;
  bool showe1 = false;
  bool x2aReadOnly = false;
  bool saved = false;
  int ccaIndex = 0;
  double x1a = 0;
  double x2a = 0;
  double vam = 0;
  double vem = 0;
  String _x2aPlaceholder = '';
  String e1Title = 'Tipo de condición comercial especial:% vs Full Price';
  String x1aT = '%';
  String x2aT = 'Full Price';
  TextEditingController _pUnitario = TextEditingController();
  TextEditingController _dsfpa = TextEditingController();
  TextEditingController _dsfpe = TextEditingController();
  TextEditingController _dev = TextEditingController();
  TextEditingController _vam = TextEditingController(text: '0');
  TextEditingController _vem = TextEditingController(text: '0');
  TextEditingController _ccp = TextEditingController();
  TextEditingController _x1a = TextEditingController();
  TextEditingController _x2a = TextEditingController();
  TextEditingController _ppva = TextEditingController();
  TextEditingController _ppve = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: LoadingOverlay(
              isLoading: loading,
              opacity: 0.5,
              color: mainColor,
              progressIndicator: CircularProgressIndicator(),
              child: homeBody(),
            ),
          ),
          onWillPop: () async {
            return false;
          }),
    );
  }

  Widget homeBody() {
    var landscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(landscape
                  ? 'assets/images/back2.png'
                  : 'assets/images/back2.png'))),
      child: SingleChildScrollView(
          child: Container(
        // height: MediaQuery.of(context).size.height -
        //     MediaQuery.of(context).padding.top,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.366,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(landscape
                              ? 'assets/images/back-tablet.jpg'
                              : 'assets/images/back-tablet.jpg'))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        landscape
                            ? 'assets/images/header-tablet.png'
                            : 'assets/images/header-tablet.png',
                      ),
                      Column(
                        children: [
                          loading
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomDropdown(
                                          landscape: true,
                                          items: this._distributors,
                                          title: 'Distribuidor',
                                          value: distributorId,
                                          onChanged: onDistributorChanged),
                                      SizedBox(width: 12),
                                      CustomDropdown(
                                          landscape: true,
                                          items: this._clients,
                                          title: 'Clientes',
                                          value: clientId,
                                          onChanged: onClientChanged)
                                    ],
                                  ),
                                ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.width * 0.035),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.0,
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: fieldLeft(
                                    'Viales actuales x mes',
                                    CustomInputField(
                                      controller: _vam,
                                      textInputType: TextInputType.number,
                                      height: 30,
                                      borderWidth: 3,
                                      paddingTop: 0,
                                      paddingLeft: 0,
                                      fontSize: 12,
                                      textAlign: TextAlign.center,
                                      borderColor: Colors.grey[800]!,
                                      backColor: Colors.white,
                                      alignment: Alignment.center,
                                      onChanged: onVamChanged,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: CustomInputField(
                                          controller: _pUnitario,
                                          textInputType: TextInputType.number,
                                          paddingLeft: 0,
                                          textAlign: TextAlign.center,
                                          height: 36,
                                          readOnly: true,
                                          backColor: Colors.white,
                                        )),
                                    SizedBox(height: 6),
                                    Text(
                                      'Full Price',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    )
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.0,
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: fieldRight(
                                    'Viales esperados x mes',
                                    CustomInputField(
                                      controller: _vem,
                                      textInputType: TextInputType.number,
                                      height: 30,
                                      borderWidth: 3,
                                      borderColor: Colors.grey[800]!,
                                      paddingTop: 0,
                                      paddingLeft: 0,
                                      fontSize: 12,
                                      textAlign: TextAlign.center,
                                      backColor: Colors.white,
                                      onChanged: onVemChanged,
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      )
                    ],
                  ),
                ),

                // Section 1 finished
                Container(
                    padding: EdgeInsets.only(top: 8),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.0,
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              fieldLeft(
                                'Diferencial en valores',
                                CustomDropdowHome(
                                    landscape: true,
                                    items: [
                                      'Full price',
                                      'Tripack',
                                      '5+8',
                                      '10+17',
                                      'X1+X2',
                                      '% vs FP'
                                    ],
                                    onChanged: ccaChanged),
                              ),
                              showe1
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left: 12,
                                          right: 6,
                                          top: 6,
                                          bottom: 6),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Column(
                                        children: [
                                          Text(
                                            e1Title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                x1aT,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                                width: 80,
                                                child: CustomInputField(
                                                  controller: _x1a,
                                                  textInputType:
                                                      TextInputType.number,
                                                  height: 30,
                                                  borderWidth: 3,
                                                  borderColor:
                                                      Colors.grey[800]!,
                                                  paddingTop: 0,
                                                  paddingLeft: 0,
                                                  fontSize: 12,
                                                  textAlign: TextAlign.center,
                                                  backColor: Colors.white,
                                                  onChanged: x1aChanged,
                                                ),
                                              ),
                                              Text(
                                                x2aT,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                              Container(
                                                width: 80,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                                child: CustomInputField(
                                                  controller: _x2a,
                                                  textInputType:
                                                      TextInputType.number,
                                                  height: 30,
                                                  borderWidth: 3,
                                                  borderColor:
                                                      Colors.grey[800]!,
                                                  paddingTop: 0,
                                                  paddingLeft: 0,
                                                  fontSize: 12,
                                                  readOnly: x2aReadOnly,
                                                  textAlign: TextAlign.center,
                                                  backColor: Colors.white,
                                                  onChanged: x2aChanged,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(height: 40),
                              fieldLeft(
                                'Precio promedio x vial actual',
                                CustomInputField(
                                  controller: _ppva,
                                  textInputType: TextInputType.number,
                                  height: 30,
                                  borderWidth: 3,
                                  borderColor: Colors.grey[800]!,
                                  paddingTop: 0,
                                  paddingLeft: 0,
                                  fontSize: 12,
                                  textAlign: TextAlign.center,
                                  backColor: Colors.white,
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    CustomInputField(
                                      controller: _dsfpa,
                                      textInputType: TextInputType.number,
                                      paddingLeft: 0,
                                      textAlign: TextAlign.center,
                                      height: 36,
                                      readOnly: true,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Descuento sobre Full Price actual',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: Column(
                                  children: [
                                    CustomInputField(
                                      controller: _dsfpe,
                                      textAlign: TextAlign.center,
                                      paddingLeft: 0,
                                      textInputType: TextInputType.number,
                                      height: 36,
                                      readOnly: true,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Nuevo descuento sobre Full Price',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: Column(
                                  children: [
                                    CustomInputField(
                                      controller: _dev,
                                      textAlign: TextAlign.center,
                                      textInputType: TextInputType.number,
                                      paddingLeft: 0,
                                      height: 36,
                                      readOnly: true,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Diferencial en valores',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.0,
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              fieldRight(
                                'Condición comercial propuesta',
                                CustomInputField(
                                  controller: _ccp,
                                  textInputType: TextInputType.number,
                                  height: 30,
                                  borderWidth: 3,
                                  borderColor: Colors.grey[800]!,
                                  paddingTop: 0,
                                  paddingLeft: 0,
                                  fontSize: 12,
                                  textAlign: TextAlign.center,
                                  backColor: Colors.white,
                                  readOnly: true,
                                ),
                              ),
                              SizedBox(height: 40),
                              fieldRight(
                                'Nuevo precio promedio',
                                CustomInputField(
                                  controller: _ppve,
                                  textInputType: TextInputType.number,
                                  height: 30,
                                  borderWidth: 3,
                                  borderColor: Colors.grey[800]!,
                                  paddingTop: 0,
                                  paddingLeft: 0,
                                  fontSize: 12,
                                  textAlign: TextAlign.center,
                                  backColor: Colors.white,
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            )),
            Container(
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
                          iconName: 'save',
                          title: 'Guardar',
                          onPressed: onSave),
                      Button(
                          iconName: 'clean',
                          title: 'Limpiar',
                          onPressed: onClear),
                      Button(
                          iconName: 'back', title: 'Atrás', onPressed: onBack),
                      Button(
                          iconName: 'next',
                          title: 'Siguiente',
                          onPressed: onNext,
                          iconRight: true),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget fieldLeft(String title, Widget input) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 6),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: mainColor, borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            width: 100,
            padding: EdgeInsets.only(left: 8),
            margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey[900]!, width: 2),
              ),
            ),
            child: input,
          ),
        ],
      ),
    );
  }

  Widget fieldRight(String title, Widget input) {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 12),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: mainColor, borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: EdgeInsets.only(right: 8),
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[900]!, width: 2),
              ),
            ),
            child: input,
          ),
          Expanded(
            child: Container(
              width: 80,
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  onClear() {
    Navigator.pushReplacementNamed(context, HOME);
  }

  onBack() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = jsonDecode(prefs.getString('data')!)[0]['Email'];
    var res = await AuthApi.logout(email);
    setState(() {
      loading = false;
    });
    if (res.toString() == 'Wrong credential')
      return showSnackbar('Sorry try again', context);
    else {
      prefs.remove('data');
      Phoenix.rebirth(context);
    }
  }

  onNext() {
    double vam = double.tryParse(_vam.text) ?? 0;
    double vem = double.tryParse(_vem.text) ?? 0;
    if (vem <= vam) {
      return showSnackbar(
          'Viales esperados x mes debe ser mayor a los actuales.', context);
    } else if (!saved) {
      return showSnackbar(
          'Antes de continuar recuerda guardar los valores calculados.',
          context);
    }
    Navigator.pushNamed(context, SUMMARY);
  }

  onSave() async {
    double vam = double.tryParse(_vam.text) ?? 0;
    double vem = double.tryParse(_vem.text) ?? 0;
    if (vem <= vam)
      return showSnackbar(
          'Viales esperados x mes debe ser mayor a los actuales.', context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic profile = jsonDecode(prefs.getString('data')!);
    dynamic json = {
      'Email': profile[0]['Email'],
      'Distribuidor': distributorId,
      'Cliente': clientId,
      'VialesActuales': vam,
      'CondicionComercialActual': ccaIndex,
      'X1': _x1a.text,
      'X2': _x2a.text,
      'PrecioPromedioxVial': _ppva.text,
      'DescuentoSobreFullPrice': _dsfpa.text,
      'VialesEsperados': _vem.text,
      'CondicionComercialPropuesta': _ccp.text,
      'NuevoPrecioPromedio': _ppve.text,
      'NuevoDescuentoSobreFullPrice': _dsfpe.text,
      'DiferencialEnValores': _dev.text,
      'FechaInicio': getDate1(),
      'FechaFin': getDate2()
    };
    prefs.setString('Propuesta', jsonEncode(json));
    showSnackbar('Los datos han sido guardados en el dispositivo.', context);
    this.saved = true;
  }

  getDate1() {
    var date = new DateTime.now();

    return DateFormat('dd-MM-yyyy').format(date);
  }

  getDate2() {
    var date = new DateTime.now();
    var day = date.day;
    var month = date.month;
    var year = date.year;
    month = month + 3;
    if (month > 11) {
      month -= 11;
    }
    return day.toString() + "-" + month.toString() + "-" + year.toString();
  }
}
