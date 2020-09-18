import 'package:http/http.dart';
import 'dart:convert';

Future<List> fetchNotificationTabElements(authToken, logicalRef) async {
  final response = await post(
      'http://172.16.1.97:8090/logo/restservices/rest/dataQuery/executeSelectQuery',
      headers: {
        'content-type': 'application/json; charset=UTF-8',
        'Auth-Token': authToken
      },
      body: jsonEncode({
        "jsonFormat": 1,
        "querySqlText":
            "SELECT LOGICALREF, NOTIFICATIONTYPE, BOSTATUS, PRIORITY, ACTUALDATE, MESSAGESUBJECT, MESSAGECONTENT FROM U_001_01_NOTIFYTRANS WHERE (USERREF = $logicalRef) ORDER BY ACTUALDATE DESC",
        "maxCount": -1
      }));
  final responseJson = json.decode(utf8.decode(response.bodyBytes))['rows'];
  return responseJson;
}
Future<List> fetchConfirmationTabElements(authToken, logicalRef) async {
  final response = await post(
      'http://172.16.1.97:8090/logo/restservices/rest/dataQuery/executeSelectQuery',
      headers: {
        'content-type': 'application/json; charset=UTF-8',
        'Auth-Token': authToken
      },
      body: jsonEncode({
        "jsonFormat": 1,
        "querySqlText":"SELECT LOGICALREF,USERCHOICE,RECORDTYPE,STARTDATE,ACTUALDATE,MESSAGESUBJECT,MESSAGECONTENT,LEVELNR,APPROVALDESC FROM U_001_01_APPROVALTRANS WHERE (USERREF = $logicalRef) ORDER BY LOGICALREF ASC",
        "maxCount":-1
      }));
  final responseJson = json.decode(utf8.decode(response.bodyBytes))['rows'];
  return responseJson;
}
