import 'package:calculator/apis/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainApi {
  static getData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token');
    if (token == null) token = '';
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
