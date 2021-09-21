import 'dart:convert';
import 'dart:io';

import 'package:calculator/public/constants.dart';
import 'package:http/http.dart' as http;

post(url, body) async {
  var headers;

  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: ''
  };
  body = jsonEncode(body);
  try {
    var uri = Uri.parse(SERVER + url);
    final http.Response response =
        await http.post(uri, headers: headers, body: body);
    return response.body;
  } catch (e) {
    return {'success': false, 'message': e};
  }
}

put(url, body) async {
  var headers;

  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: ''
  };
  body = jsonEncode(body);
  try {
    var uri = Uri.parse(SERVER + url);
    final http.Response response =
        await http.put(uri, headers: headers, body: body);
    return response.body;
  } catch (e) {
    return {'success': false, 'message': e};
  }
}

get(url) async {
  var headers;

  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: ''
  };
  try {
    var uri = Uri.parse(SERVER + url);
    final http.Response response = await http.get(uri, headers: headers);
    var result = json.decode(response.body);
    return result;
  } catch (e) {
    return {'success': false, 'error': e};
  }
}

delete(url) async {
  var headers;

  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: ''
  };
  try {
    var uri = Uri.parse(SERVER + url);
    final http.Response response = await http.delete(uri, headers: headers);
    var result = json.decode(response.body);
    return result;
  } catch (e) {
    return {'success': false, 'message': e};
  }
}

maltipartRequest(String url, String filename) async {
  var headers;

  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: ''
  };
  var req = http.MultipartRequest('POST', Uri.parse(SERVER + url));
  req.headers.addAll(headers);
  req.files.add(http.MultipartFile('file',
      File(filename).readAsBytes().asStream(), File(filename).lengthSync(),
      filename: filename.split('/').last));
  JsonDecoder decoder = new JsonDecoder();
  return decoder
      .convert((await http.Response.fromStream(await req.send())).body);
}
