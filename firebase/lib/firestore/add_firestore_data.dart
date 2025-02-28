import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  bool loading = false;
  TextEditingController postController = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add FirestoreData'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextField(
                  controller: postController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "What is in your mind")),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    fireStore.doc(id).set({
                      'title': postController.text.toString(),
                      'id': id,
                    }).then((value) {
                      Utils().toastMessage("Post Added");
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  title: 'Add')
            ],
          ),
        ));
  }
}
