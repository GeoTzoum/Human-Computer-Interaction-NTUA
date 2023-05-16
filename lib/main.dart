import 'package:flutter/material.dart';
import 'package:meditracker/add_user.dart';
import 'package:meditracker/main2.dart';
import 'package:meditracker/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MediTracker());
}

class MediTracker extends StatelessWidget {
  const MediTracker({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTracker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const UserListScreenWidget(),
    );
  }
}

class UserListScreenWidget extends StatefulWidget {
  const UserListScreenWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserListScreenWidgetState();
}

class _UserListScreenWidgetState extends State<UserListScreenWidget> {
  final _users = <User>[];

  Future checkFirstRun(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  backgroundColor: const Color.fromARGB(185, 60, 155, 184),
                  content: const Text('To start add a new user.'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      child: const Text('Got it'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ]));

      prefs.setBool('isFirstRun', false);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => checkFirstRun(context));
  }

  void _deleteUser(int idx) async {
    bool? _delUser = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                content:
                    const Text('Are you sure you want to delete this user?'),
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

    if (_delUser == true) {
      _users.removeAt(idx);
      setState(() {});
    }
  }

  void _editUser(int idx) async {
    final Entry _edEntry = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditScreen(user: _users[idx])));

    if (_edEntry != null) {
      _users[idx].name = _edEntry.name;
      _users[idx].age = _edEntry.age;
      _users[idx].sex = _edEntry.sex;

      setState(() {});
    }
  }

  void _addNewUser() async {
    final Entry _newEntry = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ViewAddUserWidget()));

    if (_newEntry != null) {
      //add the new user
      _users.add(User(
        name: _newEntry.name,
        age: _newEntry.age,
        sex: _newEntry.sex,
      ));

      setState(() {});
    }

    if (globals.usernav == false) {
      showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  backgroundColor: const Color.fromARGB(185, 60, 155, 184),
                  content: const Text(
                      'Click on the profile icon to visit this user.'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      child: const Text('Got it'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ]));
      globals.usernav = true; //don't show it again
    }
  }

  Widget _buildUserList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Main2Page()));
                if (globals.notifnav == false) {
                  showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(185, 60, 155, 184),
                              content: const Text(
                                  'Swipe right or tap on navigation bar to enter your first medicine'),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.white),
                                  child: const Text('Got it'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ]));
                  globals.notifnav = true; //don't show it again
                }
              },
            ),
            title: Text(_users[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editUser(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteUser(index);
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
          onPressed: () {},
        ),
        title: const Text('User List'),
        centerTitle: true,
        backgroundColor: Colors.indigo[200],
        foregroundColor: Colors.black,
      ),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: _addNewUser,
        backgroundColor: Colors.indigo[400],
        foregroundColor: Colors.black,
        label: const Text("New User"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class User {
  String name;
  String age;
  String? sex;

  User({required this.name, required this.age, this.sex});
}

class EditScreen extends StatelessWidget {
  final String dropdownvalue = 'Sex';

  // List of items in our dropdown menu
  final items = [
    'Sex',
    'Male',
    'Female',
  ];

  // In the constructor, require a Todo.
  EditScreen({Key? key, required this.user}) : super(key: key);

  // Declare a field that holds the Todo.
  final User user;

  final _formKey = GlobalKey<FormState>();
  String newname = "";
  String newage = "";
  String? newsex = "";
  late bool namechange = false;
  late bool agechange = false;
  late bool sexchange = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Change a user'),
          centerTitle: true,
          backgroundColor: Colors.indigo[200],
          foregroundColor: Colors.black,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: user.name,
                    decoration: const InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(borderSide: BorderSide())),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty!';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      namechange = true;
                      newname = value;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: user.age,
                    decoration: const InputDecoration(
                        hintText: "Age",
                        border: OutlineInputBorder(borderSide: BorderSide())),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty!';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      agechange = true;
                      newage = value;
                    },
                  )),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid,
                        width: 2.0,
                        color: Colors.black26),
                    borderRadius: BorderRadius.circular(8.0)),
                child: DropdownButton<String>(
                  value: user.sex,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                  underline: SizedBox(),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    newsex = newValue;
                    sexchange = true;
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('CANCEL',
                                  style: TextStyle(color: Colors.purple)),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.white)))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (namechange == false) {
                                    newname = user.name;
                                  }
                                  if (agechange == false) {
                                    newage = user.age;
                                  }
                                  if (sexchange == false) {
                                    newsex = user.sex;
                                  }
                                  final entry = Entry(
                                    name: newname,
                                    age: newage,
                                    sex: newsex,
                                  );
                                  Navigator.pop(context, entry);
                                }
                              },
                              child: const Text('OKAY',
                                  style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.purple)))),
                    ],
                  )),
            ],
          ),
        ));
  }
}
