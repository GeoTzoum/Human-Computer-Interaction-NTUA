import 'package:flutter/material.dart';
import 'package:meditracker/globals.dart' as globals;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin<NotificationsPage> {
  int counter = 0;
  final _notifications = <Notification>[];
  var timer = "0";
  var hour;
  var minute;

  void _reload() {
    if (globals.meddeleted == true) {
      _notifications.removeWhere((Notification notification) =>
          notification.name == globals.mednamedel);

      globals.meddeleted = false;
      setState(() {});
      return;
    }

    if (globals.reload == false) {
      return;
    }

    var count = int.parse(globals.medintake);
    //Obnoxiously complicated way of making notifications
    for (int c = 0; c < count; c++) {
      if (count == 1) {
        timer = globals.medtime;
      }

      if (count == 2) {
        if (c == 0) {
          timer = globals.medtime;
        } else {
          hour = int.parse(globals.medtime.substring(0, 2)) + 12;
          if (hour > 23) {
            hour = hour - 24;
          }
          minute = int.parse(globals.medtime.substring(3, 5));
          timer = "$hour:$minute";
        }
      }

      if (count == 3) {
        if (c == 0) {
          timer = globals.medtime;
        } else if (c == 1) {
          hour = int.parse(globals.medtime.substring(0, 2)) + 8;
          if (hour > 23) {
            hour = hour - 24;
          }
          minute = int.parse(globals.medtime.substring(3, 5));
          timer = "$hour:$minute";
        } else {
          hour = int.parse(globals.medtime.substring(0, 2)) + 16;
          if (hour > 23) {
            hour = hour - 24;
          }
          minute = int.parse(globals.medtime.substring(3, 5));
          timer = "$hour:$minute";
        }
      }

      if (count == 4) {
        if (c == 0) {
          timer = globals.medtime;
        } else if (c == 1) {
          hour = int.parse(globals.medtime.substring(0, 2)) + 6;
          if (hour > 23) {
            hour = hour - 24;
          }
          minute = int.parse(globals.medtime.substring(3, 5));
          timer = "$hour:$minute";
        } else if (c == 2) {
          hour = int.parse(globals.medtime.substring(0, 2)) + 12;
          if (hour > 23) {
            hour = hour - 24;
          }
          minute = int.parse(globals.medtime.substring(3, 5));
          timer = "$hour:$minute";
        } else {
          hour = int.parse(globals.medtime.substring(0, 2)) + 18;
          if (hour > 23) {
            hour = hour - 24;
          }
          minute = int.parse(globals.medtime.substring(3, 5));
          timer = "$hour:$minute";
        }
      }
      TimeOfDay _selectedTime = TimeOfDay(
          hour: int.parse(timer.split(":")[0]),
          minute: int.parse(timer.split(":")[1]));
      String s = _selectedTime.toString();
      timer = s.substring(10, 15);

      _notifications.add(Notification(
        name: globals.medname,
        time: timer,
      ));
    }
    globals.reload = false;
    setState(() {});

    if (globals.notifrel == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  backgroundColor: const Color.fromARGB(185, 60, 155, 184),
                  content: const Text(
                      'You have to reload everytime you change your medicines.'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      child: const Text('Got it'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ]));
      globals.notifrel = true; //don't show it again
    }
  }

  void _deleteNotification(int idx) async {
    bool? _delNotif = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                content: const Text(
                    'Are you sure you want to delete this notification?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () => Navigator.pop(context, true),
                  )
                ]));

    if (_delNotif == true) {
      _notifications.removeAt(idx);
      setState(() {});
    }
  }

  void _editNotification(int idx) async {
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(_notifications[idx].time.split(":")[0]),
        minute: int.parse(_notifications[idx].time.split(":")[1]));

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _startTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _startTime) {
      setState(() {
        _startTime = timeOfDay;
      });
      String s = _startTime.toString();
      _notifications[idx].time = s.substring(10, 15);
      setState(() {});
    }
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: IconButton(
              icon: const Icon(Icons.notification_important_outlined),
              onPressed: () {},
            ),
            title: Text(_notifications[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(_notifications[index].time),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editNotification(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteNotification(index);
                  },
                ),
              ],
            ));
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Daily Notifications'),
        centerTitle: true,
        backgroundColor: Colors.indigo[200],
        foregroundColor: Colors.black,
      ),
      body: _buildNotificationList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.arrow_circle_up),
        onPressed: _reload,
        backgroundColor: Colors.indigo[400],
        foregroundColor: Colors.black,
        label: const Text("Reload"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Notification {
  String name;
  String time;

  Notification({required this.name, required this.time});
}
