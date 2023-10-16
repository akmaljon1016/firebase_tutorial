import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  final CollectionReference humans;
  final Map<String, String>? human;

  const AddScreen({super.key, required this.humans, this.human});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.human?['name']);
    surnameController = TextEditingController(text: widget.human?['surname']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "name"),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: surnameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "surname"),
              )),
          MaterialButton(
            onPressed: () {
              if (widget.human == null) {
                widget.humans.add({
                  "name": nameController.text,
                  "surname": surnameController.text
                }).then((value) {
                  Navigator.pop(context);
                });
              } else {
                widget.humans.doc(widget.human?['id']).update({
                  "name": nameController.text,
                  "surname": surnameController.text
                }).then((value) {
                  Navigator.pop(context);
                });
              }
            },
            color: Colors.green,
            child: Text(widget.human == null ? "Save" : "Update"),
          )
        ],
      ),
    );
  }
}
