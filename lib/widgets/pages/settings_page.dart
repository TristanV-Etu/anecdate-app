import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/utils/notification_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late BuildContext _ctx;
  late Size _size;

  int _hour = Globals.hourNotif;
  int _min = Globals.minuteNotif;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Réglages"),
      ),
      body: SingleChildScrollView(child: _createSettings()),
    );
  }

  Widget _createSettings() {
    return Column(
      children: [
        _createDarkModeCard(),
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text("Mode Swipe:"),
        //     Switch(
        //         value: Globals.swipeMode,
        //         onChanged: ((newBool) {
        //           setState(() {
        //             Globals.swipeMode = !Globals.swipeMode;
        //             Globals.pushPreferences();
        //           });
        //         })),
        //   ],
        // ),
        _createDaysChoice(),
      ],
    );
  }

  Widget _createDarkModeCard() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.dark_mode_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Mode sombre :"),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Switch(
                        value: Globals.darkTheme,
                        onChanged: ((newBool) {
                          setState(() {
                            Globals.darkTheme = !Globals.darkTheme;
                            Globals.pushPreferences();
                            if (Globals.darkTheme) {
                              AdaptiveTheme.of(context).setDark();
                            } else {
                              AdaptiveTheme.of(context).setLight();
                            }
                          });
                        })),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: SizedBox(
                  width: _size.width,
                  child: Text(
                    "Change de mode pour passer en mode sombre ou clair.",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDaysChoice() {
    List<Widget> list = [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 8),
            child: Icon(
              Icons.schedule_outlined,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 8),
            child: Text("Notifications :"),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 8),
            child: Switch(
                value: Globals.activeNotif,
                onChanged: ((newBool) {
                  setState(() {
                    Globals.activeNotif = !Globals.activeNotif;
                    Globals.pushPreferences();

                    if (Globals.activeNotif) {
                      NotificationSystem.subscribeNotification();
                    } else {
                      NotificationSystem.cancelAll();
                    }
                  });
                })),
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.5,
        indent: 40,
        endIndent: 0,
      ),
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text("Heure :  $_hour:$_min"),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: _selectTime,
              child: Text('CHOISIR'),
            ),
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.5,
        indent: 40,
        endIndent: 0,
      ),
    ];

    Globals.choiceDays.forEach((key, value) {
      list.add(
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          leading: Checkbox(
              value: value,
              onChanged: (newBool) {
                setState(() {
                  Globals.choiceDays[key] = newBool ?? false;
                  Globals.pushPreferences();
                  if (Globals.activeNotif) {
                    NotificationSystem.cancelAll();
                    NotificationSystem.subscribeNotification();
                  }
                });
              }),
          title: Text(key),
        ),
        ),
      );
    });

    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
            children: list,
          ),
          ),
        ),
      ),
    );
  }
  

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: _ctx,
      initialTime:
          TimeOfDay(hour: Globals.hourNotif, minute: Globals.minuteNotif),
    );
    if (newTime != null) {
      setState(() {
        _hour = newTime.hour;
        _min = newTime.minute;
        Globals.hourNotif = newTime.hour;
        Globals.minuteNotif = newTime.minute;
        Globals.pushPreferences();
        if (Globals.activeNotif) {
          NotificationSystem.cancelAll();
          NotificationSystem.subscribeNotification();
        }
      });
    }
  }
}
