import "dart:io";
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

late List<CameraDescription> cameras;

class ViewAddMedicineWidget extends StatefulWidget {
  const ViewAddMedicineWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewAddMedicineWidgetState();
}

class _ViewAddMedicineWidgetState extends State<ViewAddMedicineWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String dropdownvalue = 'Intake';
  String datetime = '';
  String lastday = '';

  String text = '';

  // List of items in our dropdown menu
  var items = [
    'Intake',
    '1',
    '2',
    '3',
    '4',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  File? image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add A New Medicine'),
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
                          hintText: 'Description',
                          border: OutlineInputBorder(borderSide: BorderSide())),
                      controller: _descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description cannot be empty!';
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
                DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Date of first intake',
                    timeLabelText: 'Hour',
                    selectableDayPredicate: (date) {
                      return true;
                    },
                    onChanged: (val) => {datetime = val},
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => {
                          datetime = val!,
                        }),
                DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Last day of medication',
                    timeLabelText: 'Hour',
                    selectableDayPredicate: (date) {
                      return true;
                    },
                    onChanged: (val) => {lastday = val},
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => {
                          lastday = val!,
                        }),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(70, 8, 8, 8),
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
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.camera_alt_rounded),
                                  color: Colors.purple,
                                  onPressed: () => pickImage(),
                                )
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final entry = EntryMedicine(
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      intake: dropdownvalue,
                                      meddate: datetime,
                                      lastmeddate: lastday,
                                    );
                                    Navigator.pop(context, entry);
                                  }
                                },
                                child: const Text('ADD',
                                    style: TextStyle(color: Colors.white)),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.purple)))),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: image != null
                      ? Image.file(
                          image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: AssetImage('Icons/blank.jpg'),
                          alignment: Alignment.center),
                ),
              ]),
        ));
  }
}

class EntryMedicine {
  String name;
  String description;
  String intake;
  String meddate;
  String lastmeddate;

  EntryMedicine(
      {required this.name,
      required this.description,
      required this.intake,
      required this.meddate,
      required this.lastmeddate});
}
