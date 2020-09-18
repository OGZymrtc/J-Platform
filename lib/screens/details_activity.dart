import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';

List allElements;
int index, navigatorOk, tabIndex;
String newMessageContent;

class Details extends StatelessWidget {
  Details({List elements, int dex, int tab}) {
    allElements = elements;
    index = dex;
    tabIndex = tab;
  }

  @override
  Widget build(BuildContext context) {
    return tabIndex == 0
        ? Scaffold(
            backgroundColor: Colors.blue[700],
            appBar: AppBar(
              title: Text(allElements[index]["MESSAGESUBJECT"]),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.blue[700],
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  height: MediaQuery.of(context).size.height * (2 / 3),
                  width: MediaQuery.of(context).size.width - 20,
                  left: 10,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          "Actual Date : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("${allElements[index]["ACTUALDATE"]}",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          "Message Content : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Html(data: decodeAndParseContent()),
                        Text(
                          "Notification Type: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                            allElements[index]["NOTIFICATIONTYPE"] == 1
                                ? "Onay"
                                : allElements[index]["NOTIFICATIONTYPE"] == 0
                                    ? "Bildirim"
                                    : "null",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          "Priority : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          allElements[index]["PRIORITY"] == 3
                              ? "Yüksek"
                              : allElements[index]["PRIORITY"] == 2
                                  ? "Normal"
                                  : "Düşük",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: "tag",
                    child: Container(
                      margin: EdgeInsets.only(top: 0),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/details_icon.png"),
                          )),
                    ),
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.blue[700],
            appBar: AppBar(
              title: Text(allElements[index]["MESSAGESUBJECT"]),
              automaticallyImplyLeading: true,
              backgroundColor: Colors.blue[700],
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  height: MediaQuery.of(context).size.height * (2 / 3),
                  width: MediaQuery.of(context).size.width - 20,
                  left: 10,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 80,
                        ),
                        allElements[index]['APPROVALDESC'] != ''
                            ? Text(
                                "Approval Desc : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        allElements[index]['APPROVALDESC'] != ''
                            ? Text("${allElements[index]["APPROVALDESC"]}",
                                style: TextStyle(fontSize: 16))
                            : SizedBox(
                                height: 0,
                              ),
                        allElements[index]['ACTUALDATE'] != '' &&
                                allElements[index]['ACTUALDATE'] != null
                            ? Text(
                                "Actual Date : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        allElements[index]['ACTUALDATE'] != '' &&
                                allElements[index]['ACTUALDATE'] != null
                            ? Text("${allElements[index]["ACTUALDATE"]}",
                                style: TextStyle(fontSize: 16))
                            : SizedBox(
                                height: 0,
                              ),
                        Text(
                          "Start Date : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("${allElements[index]["STARTDATE"]}",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          "Message Content : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Html(data: decodeAndParseContent()),
                        Text(
                          "Level Nr : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("${allElements[index]["LEVELNR"]}",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          "Record Type : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("${allElements[index]["RECORDTYPE"]}",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          "User Choice : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                            allElements[index]["USERCHOICE"] == 0
                                ? 'Bekliyor'
                                : allElements[index]["USERCHOICE"] == 1
                                    ? 'Onaylandı'
                                    : allElements[index]["USERCHOICE"] == 2
                                        ? 'E-imza ile onaylandı'
                                        : allElements[index]["USERCHOICE"] == 3
                                            ? 'Reddedildi'
                                            : allElements[index]
                                                        ["USERCHOICE"] ==
                                                    4
                                                ? 'E-imza ile reddedildi'
                                                : 'Belirsiz',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        allElements[index]['USERCHOICE'] == 0 ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.done_outline,
                                  color: Colors.green,
                                ),
                                label: Text("Onayla")),
                            FlatButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                label: Text("Reddet"))
                          ],
                        ) : SizedBox(height: 0,)
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: "tag",
                    child: Container(
                      margin: EdgeInsets.only(top: 0),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/details_icon.png"),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

String decodeAndParseContent() {
  newMessageContent = allElements[index]["MESSAGECONTENT"];
  String str = newMessageContent.replaceAll('\n', '');
  String decoded = utf8.decode(base64.decode(str));
  return decoded;
}
