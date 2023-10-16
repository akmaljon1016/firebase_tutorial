import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutorial/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CollectionReference humans = FirebaseFirestore.instance.collection("humans");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase"),
      ),
      body: StreamBuilder(
          stream: humans.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return Slidable(
                      key: const ValueKey(0),
                      endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: (value) {
                            setState(() {
                              humans.doc(documentSnapshot.id).delete();
                            });
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddScreen(
                                          humans: humans,
                                          human: {
                                            "name": documentSnapshot['name'],
                                            "id": documentSnapshot.id,
                                            "surname": documentSnapshot['surname']
                                          },
                                        )));
                          },
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ]),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.green,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(documentSnapshot['name']),
                            Text(documentSnapshot['surname']),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.error == true) {
              return Center(
                child: Text((snapshot.error.toString())),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddScreen(humans: humans)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
