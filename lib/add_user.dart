import 'package:flutter/material.dart';

class ViewAddUserWidget extends StatefulWidget {
  const ViewAddUserWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewAddUserWidgetState();
}

class _ViewAddUserWidgetState extends State<ViewAddUserWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  String dropdownvalue = 'Sex';

  // List of items in our dropdown menu
  var items = [
    'Sex',
    'Male',
    'Female',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add A New User'),
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
                    decoration: const InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(borderSide: BorderSide())),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty!';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Age',
                        border: OutlineInputBorder(borderSide: BorderSide())),
                    controller: _ageController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Age cannot be empty!';
                      }
                      return null;
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
                  value: dropdownvalue,
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
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(100, 8, 8, 8),
                  child: Row(
                    children: <Widget>[
                      //const Flexible(fit: FlexFit.tight, child: SizedBox()),
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
                                  final entry = Entry(
                                    name: _nameController.text,
                                    age: _ageController.text,
                                    sex: dropdownvalue,
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

class Entry {
  String name;
  String age;
  String? sex;

  Entry({required this.name, required this.age, this.sex});
}