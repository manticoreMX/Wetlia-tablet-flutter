import 'package:calculator/apis/http.dart';

class MainApi {
  static getData(String token) async {
    var res = await post('/getData', {'Token': token});
    return res;
  }

  static saveData(dynamic data) async {
    var res = await put('/aPropuesta', data);
    return res;
  }

  static sendEmail(dynamic data) async {
    var res = await post('/email', data);
    return res;
  }
}
