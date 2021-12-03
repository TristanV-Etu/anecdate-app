import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late BuildContext _ctx;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      appBar: AppBar(),
      body: _createSettings(),
    );
  }

  Widget _createSettings() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mode sombre:"),
            Switch(
                value: Globals.darkTheme,
                onChanged: ((newBool) {
                  setState(() {
                    Globals.darkTheme = !Globals.darkTheme;
                    Globals.pushPreferences();
                  });
                })),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mode Swipe:"),
            Switch(
                value: Globals.swipeMode,
                onChanged: ((newBool) {
                  setState(() {
                    Globals.swipeMode = !Globals.swipeMode;
                    Globals.pushPreferences();
                  });
                })),
          ],
        ),
        _createDaysChoice(),
      ],
    );
  }

  Widget _createDaysChoice() {
    List<Widget> list = [
      Row(
        children: [
          Text("Notification"),
          Switch(
              value: Globals.activeNotif,
              onChanged: ((newBool) {
                setState(() {
                  Globals.activeNotif = !Globals.activeNotif;
                  Globals.pushPreferences();
                });
              })),
        ],
      ),
      ElevatedButton(
        onPressed: _selectTime,
        child: Text('SELECT TIME'),
      ),
    ];

    Globals.choiceDays.forEach((key, value) {
      list.addAll([
        Checkbox(
            value: value,
            onChanged: (newBool) {
              setState(() {
                Globals.choiceDays[key] = newBool ?? false;
                Globals.pushPreferences();
              });
            }),
        Text(key),
      ]);
    });

    return Column(
      children: list,
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
        Globals.hourNotif = newTime.hour;
        Globals.minuteNotif = newTime.minute;
        Globals.pushPreferences();
      });
    }
  }
}
