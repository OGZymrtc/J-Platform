import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jplatform/models/logicalref.dart';
import 'package:jplatform/models/logicalref_from_json.dart';
import 'package:jplatform/utils/database_helper.dart';
import 'details_activity.dart';

List notificationTabAllElements, confirmationTabAllELements;
String auth, userName;
int allNotificationsLength, itemCount, allConfirmationsLength;
int tabIndex = 0;
DatabaseHelper dh1 = DatabaseHelper();
int ok = 0;
bool isSwitched = true;
List notfReads = List();
List confReads = List();

class NotificationActivity extends StatefulWidget {
  NotificationActivity({String authToken, String usrName}) {
    auth = authToken;
    userName = usrName;
  }

  @override
  _NotificationActivityState createState() => _NotificationActivityState();
}

class _NotificationActivityState extends State<NotificationActivity> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  Map<String, dynamic> allDB2 = Map<String, int>();

  @override
  void initState() {
    readNotificationTabDataSource().then((value) => {
          notificationTabAllElements = value,
          setState(() {
            initializing();
            allNotificationsLength = notificationTabAllElements.length;
          })
        });
    readConfirmationTabDataSource().then((value) => {
          setState(() {
            confirmationTabAllELements = value;
            allConfirmationsLength = confirmationTabAllELements.length;
            ok = 1;
            getReads(
                notificationTabAllElements, confirmationTabAllELements, ok);
          }),
        });
    db();
    _inCreamentCounter();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications(int lenght, int type) async {
    await notification(lenght, type);
  }

  Future<void> notification(int lenght, int type) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel Title', 'Channel description',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: type == 0
                ? notificationTabAllElements[lenght - 1]['MESSAGESUBJECT']
                : confirmationTabAllELements[lenght - 1]['MESSAGESUBJECT']);
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0,
        type == 0
            ? notificationTabAllElements[lenght - 1]['MESSAGESUBJECT']
            : confirmationTabAllELements[lenght - 1]['MESSAGESUBJECT'],
        type == 0
            ? notificationTabAllElements[lenght - 1]['ACTUALDATE']
            : confirmationTabAllELements[lenght - 1]['STARTDATE'],
        notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payLoad) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print('');
            },
            child: Text("Okey"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return notificationTabAllElements != null &&
            confirmationTabAllELements != null
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.blue[700],
              body: Column(
                children: <Widget>[
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/njplatform.png"),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                            text: 'Notifications',
                            icon: Container(
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.notifications),
                                  isSwitched == true
                                      ? Text(
                                          "${notificationTabAllElements.length}")
                                      : tabIndex == 0
                                          ? Text("${notfReads.length}")
                                          : Text(
                                              "${notificationTabAllElements.length}")
                                ],
                              ),
                            )),
                        Tab(
                            text: 'Confirmations',
                            icon: Container(
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.check_circle),
                                  isSwitched == true
                                      ? Text(
                                          "${confirmationTabAllELements.length}")
                                      : tabIndex == 1
                                          ? Text("${confReads.length}")
                                          : Text(
                                              "${confirmationTabAllELements.length}")
                                ],
                              ),
                            )),
                      ],
                      indicatorColor: Colors.white,
                      labelPadding: EdgeInsets.only(top: 20),
                      onTap: (index) {
                        setState(() {
                          ok++;
                          getReads(notificationTabAllElements,
                              confirmationTabAllELements, ok);
                          db();
                        });
                        tabIndex = index;
                        db();
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: tabIndex == 0
                        ? EdgeInsets.only(left: 143)
                        : EdgeInsets.only(left: 135),
                    child: Row(
                      children: <Widget>[
                        Text(
                          tabIndex == 0 ? "Show Reads" : 'Show Approved',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              notfReads.clear();
                              confReads.clear();
                              ok = 1;
                              getReads(notificationTabAllElements,
                                  confirmationTabAllELements, ok);
                            });
                          },
                          activeTrackColor: Colors.green,
                          activeColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                topLeft: Radius.circular(60)),
                            color: Colors.white),
                        child: ListView.builder(
                            itemCount: isSwitched == true
                                ? (tabIndex == 0 || tabIndex == null
                                    ? notificationTabAllElements.length
                                    : confirmationTabAllELements.length)
                                : (tabIndex == 0 || tabIndex == null
                                    ? notfReads.length
                                    : confReads.length),
                            itemBuilder: (context, index) {
                              return tabIndex == 0 || tabIndex == null
                                  ? notificationTab(
                                      notificationTabAllElements, index)
                                  : confirmationTab(
                                      confirmationTabAllELements, index);
                            })),
                  ),
                ],
              ),
            ))
        : Center(child: CircularProgressIndicator());
  }

  _inCreamentCounter() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      print("was called");
      if (allNotificationsLength != notificationTabAllElements.length) {
        _showNotifications(notificationTabAllElements.length, 0);
        allNotificationsLength = notificationTabAllElements.length;
        setState(() {});
      }
      if (allConfirmationsLength != confirmationTabAllELements.length) {
        _showNotifications(confirmationTabAllELements.length, 1);
        allConfirmationsLength = confirmationTabAllELements.length;
        setState(() {});
      }
    });
  }

  db() {
    dh1
        .allRef()
        .then((value) => {
              for (Map readRef in value)
                {
                  allDB2["${Logicalreff.fromMAp(readRef).logicalRef}"] =
                      Logicalreff.fromMAp(readRef).ok
                },
            })
        .catchError((error) => print(error));
  }

  void getReads(List notificationTabAllElements,
      List confirmationTabAllElements, int ok) {
    if (ok == 1) {
      for (int i = 0; i < notificationTabAllElements.length; i++) {
        if (allDB2["${notificationTabAllElements[i]['LOGICALREF']}"] != 1) {
          notfReads.add(notificationTabAllElements[i]);
        }
      }
      for (int i = 0; i < confirmationTabAllElements.length; i++) {
        if (confirmationTabAllElements[i]['USERCHOICE'] == 0) {
          confReads.add(confirmationTabAllElements[i]);
        }
      }
    }
  }

  Widget notificationTab(List notificationTabAllElements, int index) {
    return isSwitched == true
        ? Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child:
                    notificationTabAllElements[index]['NOTIFICATIONTYPE'] == 0
                        ? Icon(
                            Icons.notifications,
                            color: Colors.black54,
                          )
                        : Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
              ),
              contentPadding:
                  EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
              title: Text(
                "${notificationTabAllElements[index]["MESSAGESUBJECT"]} ",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notificationTabAllElements[index]["PRIORITY"] == 3
                    ? "${notificationTabAllElements[index]["ACTUALDATE"]} Priority : High"
                    : notificationTabAllElements[index]["PRIORITY"] == 2
                        ? "${notificationTabAllElements[index]["ACTUALDATE"]} Priority : Medium"
                        : "${notificationTabAllElements[index]["ACTUALDATE"]} Priority : Low",
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.bold),
              ),
              trailing:
                  allDB2["${notificationTabAllElements[index]["LOGICALREF"]}"] ==
                          1
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : Icon(Icons.more_horiz),
              onTap: () {
                setState(() {
                  if (allDB2[
                          "${notificationTabAllElements[index]["LOGICALREF"]}"] ==
                      null) {
                    allDB2["${notificationTabAllElements[index]["LOGICALREF"]}"] =
                        1;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(
                                elements: notificationTabAllElements,
                                dex: index,
                                tab: 0,
                              )));
                  navigatorOk = 1;
                  dh1.addRef(Logicalreff(
                      logicalRef: notificationTabAllElements[index]
                          ["LOGICALREF"],
                      ok: navigatorOk));
                  db();
                  notfReads.clear();
                  confReads.clear();
                  ok = 1;
                  getReads(notificationTabAllElements,
                      confirmationTabAllELements, ok);
                  navigatorOk = 0;
                });
              },
            ),
            margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
          )
        : Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: notfReads[index]['NOTIFICATIONTYPE'] == 0
                    ? Icon(
                        Icons.notifications,
                        color: Colors.black54,
                      )
                    : Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
              ),
              contentPadding:
                  EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
              title: Row(
                children: <Widget>[
                  Text(
                    "${notfReads[index]["MESSAGESUBJECT"]} ",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(
                notfReads[index]["PRIORITY"] == 3
                    ? "${notfReads[index]["ACTUALDATE"]} Priority : High"
                    : notfReads[index]["PRIORITY"] == 2
                        ? "${notfReads[index]["ACTUALDATE"]} Priority : Medium"
                        : "${notfReads[index]["ACTUALDATE"]} Priority : Low",
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.bold),
              ),
              trailing: allDB2["${notfReads[index]["LOGICALREF"]}"] == 1
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Icon(Icons.more_horiz),
              onTap: () {
                setState(() {
                  if (allDB2["${notfReads[index]["LOGICALREF"]}"] == null) {
                    allDB2["${notfReads[index]["LOGICALREF"]}"] = 1;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(
                                elements: notfReads,
                                dex: index,
                                tab: 0,
                              )));
                  navigatorOk = 1;
                  dh1.addRef(Logicalreff(
                      logicalRef: notfReads[index]["LOGICALREF"],
                      ok: navigatorOk));
                  db();
                  notfReads.clear();
                  confReads.clear();
                  ok = 1;
                  getReads(notificationTabAllElements,
                      confirmationTabAllELements, ok);
                  navigatorOk = 0;
                });
              },
            ),
            margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
          );
  }

  Widget confirmationTab(List confirmationTabAllElements, int index) {
    return isSwitched == true
        ? Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
              contentPadding:
                  EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
              title: Text(
                '${confirmationTabAllElements[index]['MESSAGESUBJECT']}',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                confirmationTabAllElements[index]['ACTUALDATE'] != null
                    ? '${confirmationTabAllElements[index]['ACTUALDATE']}'
                    : '${confirmationTabAllElements[index]['STARTDATE']}',
                style: TextStyle(
                    //Icons.border_color
                    color: Colors.black45,
                    fontWeight: FontWeight.bold),
              ),
              trailing: confirmationTabAllElements[index]['USERCHOICE'] == 0
                  ? Icon(Icons.more_horiz)
                  : confirmationTabAllElements[index]['USERCHOICE'] == 1
                      ? Icon(Icons.done_all, color: Colors.green)
                      : confirmationTabAllElements[index]['USERCHOICE'] == 2
                          ? Icon(
                              Icons.rate_review,
                              color: Colors.green,
                            )
                          : confirmationTabAllElements[index]['USERCHOICE'] == 3
                              ? Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                )
                              : confirmationTabAllElements[index]
                                          ['USERCHOICE'] ==
                                      4
                                  ? Icon(
                                      Icons.rate_review,
                                      color: Colors.red,
                                    )
                                  : Icon(Icons.more_horiz),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Details(
                              elements: confirmationTabAllElements,
                              dex: index,
                              tab: 1,
                            )));
              },
            ),
            margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
          )
        : Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
              contentPadding:
                  EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
              title: Text(
                '${confReads[index]['MESSAGESUBJECT']}',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                confReads[index]['ACTUALDATE'] != null
                    ? '${confReads[index]['ACTUALDATE']}'
                    : '${confReads[index]['STARTDATE']}',
                style: TextStyle(
                    //Icons.border_color
                    color: Colors.black45,
                    fontWeight: FontWeight.bold),
              ),
              trailing: confReads[index]['USERCHOICE'] == 0
                  ? Icon(Icons.more_horiz)
                  : confReads[index]['USERCHOICE'] == 1
                      ? Icon(Icons.done_all, color: Colors.green)
                      : confReads[index]['USERCHOICE'] == 2
                          ? Icon(
                              Icons.rate_review,
                              color: Colors.green,
                            )
                          : confReads[index]['USERCHOICE'] == 3
                              ? Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                )
                              : confReads[index]['USERCHOICE'] == 4
                                  ? Icon(
                                      Icons.rate_review,
                                      color: Colors.red,
                                    )
                                  : Icon(Icons.more_horiz),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Details(
                              elements: confReads,
                              dex: index,
                              tab: 1,
                            )));
              },
            ),
            margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
          );
  }
}

Future<List> readNotificationTabDataSource() async {
  return fetchNotificationTabRef(auth, userName);
}

Future<List> readConfirmationTabDataSource() async {
  return fetchConfirmationTabRef(auth, userName);
}
