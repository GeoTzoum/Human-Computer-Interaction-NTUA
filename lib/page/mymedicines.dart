import 'package:flutter/material.dart';
import 'package:meditracker/globals.dart' as globals;
import 'package:meditracker/add_medicine.dart';

class MyMedicinesPage extends StatefulWidget {
  const MyMedicinesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyMedicinesPageState();
}

class _MyMedicinesPageState extends State<MyMedicinesPage>
    with AutomaticKeepAliveClientMixin<MyMedicinesPage> {
  final _medicines = <Medicine>[];

  //A function for the right navigation in the navigation bar

  void _addNewMedicine() async {
    final EntryMedicine _newEntry = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ViewAddMedicineWidget()));

    if (_newEntry != null) {
      //add the new medicine
      _medicines.add(Medicine(
        name: _newEntry.name,
        description: _newEntry.description,
        intake: _newEntry.intake,
        meddate: _newEntry.meddate,
        lastmeddate: _newEntry.lastmeddate,
      ));
      globals.medname = _newEntry.name;
      globals.medtime = _newEntry.meddate.substring(11);
      globals.medintake = _newEntry.intake;
      globals.reload = true;

      setState(() {});
    }

    if (globals.mednav == false) {
      showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  backgroundColor: const Color.fromARGB(185, 60, 155, 184),
                  content: const Text(
                      'Go to notifications and reload to add the notifications for this medicine.'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      child: const Text('Got it'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ]));
      globals.mednav = true; //don't show it again
    }
  }

  void _deleteMedicine(int idx) async {
    bool? _delMedicine = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                content: const Text(
                    'Are you sure you want to delete this medicine?'),
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

    if (_delMedicine == true) {
      globals.mednamedel = _medicines[idx].name;
      globals.meddeleted = true;
      _medicines.removeAt(idx);
      setState(() {});
    }
  }

  Widget _buildMedicinesList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _medicines.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: IconButton(
              icon: const Icon(Icons.medication),
              onPressed: () {},
            ),
            title: Text(_medicines[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteMedicine(index);
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
        title: const Text('My Medicines'),
        centerTitle: true,
        backgroundColor: Colors.indigo[200],
        foregroundColor: Colors.black,
      ),
      body: _buildMedicinesList(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: _addNewMedicine,
        backgroundColor: Colors.indigo[400],
        foregroundColor: Colors.black,
        label: const Text("New Medicine"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Medicine {
  String name;
  String description;
  String intake;
  String meddate;
  String lastmeddate;

  Medicine(
      {required this.name,
      required this.description,
      required this.intake,
      required this.meddate,
      required this.lastmeddate});
}
