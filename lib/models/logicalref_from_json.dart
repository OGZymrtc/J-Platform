import 'package:http/http.dart';
import 'dart:convert';
import 'elements_from_json.dart';

Future<List> fetchNotificationTabRef(authToken, userName) async {
  String auth = "1:$authToken:$userName";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String refEncoded = stringToBase64.encode(auth);
  final response = await post(
      'http://172.16.1.97:8090/logo/restservices/rest/dataQuery/executeSelectQuery',
      headers: {
        'content-type': 'application/json; charset=UTF-8',
        'Auth-Token': refEncoded
      },
      body: jsonEncode({
        "jsonFormat": 1,
        "querySqlText":
        "SELECT LOGICALREF FROM S_USERS WHERE USERNAME = 'admin'",
        "maxCount": -1
      }));

  final responseJson = json.decode(response.body)['rows'];
  var logicalRef = responseJson[0]['LOGICALREF'];
  return fetchNotificationTabElements(refEncoded, logicalRef);
}
Future<List> fetchConfirmationTabRef(authToken, userName) async {
  String auth = "1:$authToken:$userName";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String refEncoded = stringToBase64.encode(auth);
  final response = await post(
      'http://172.16.1.97:8090/logo/restservices/rest/dataQuery/executeSelectQuery',
      headers: {
        'content-type': 'application/json; charset=UTF-8',
        'Auth-Token': refEncoded
      },
      body: jsonEncode({
        "jsonFormat": 1,
        "querySqlText":
        "SELECT LOGICALREF FROM S_USERS WHERE USERNAME = 'admin'",
        "maxCount": -1
      }));

  final responseJson = json.decode(response.body)['rows'];
  var logicalRef = responseJson[0]['LOGICALREF'];
  return fetchConfirmationTabElements(refEncoded, logicalRef);
}
