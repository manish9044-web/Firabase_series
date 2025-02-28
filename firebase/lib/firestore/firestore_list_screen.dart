import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/add_firestore_data.dart';
import 'package:firebase/login_screen.dart';
import 'package:firebase/posts/add_posts.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  @override
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('Users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('Users');

  final editController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore Screen'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(
                  child: CircularProgressIndicator(),
                );

              if (snapshot.hasError)
                return Text("Something went wrong ${snapshot.error}");

              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (contect, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString()),
                            trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              _showMyDialog(
                                                  snapshot.data!
                                                      .docs[index]['title']
                                                      .toString(),
                                                  snapshot
                                                      .data!.docs[index]['id']
                                                      .toString());
                                            },
                                            leading: Icon(Icons.edit),
                                            title: Text("Edit"),
                                          )),
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              ref
                                                  .doc(snapshot
                                                      .data!.docs[index]['id']
                                                      .toString())
                                                  .delete();
                                            },
                                            leading: Icon(Icons.delete_outline),
                                            title: Text("Delete"),
                                          ))
                                    ]),
                          ),
                        );
                      }));
            },
            stream: fireStore,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFirestoreData()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update'),
          content: Container(
              child: TextField(
            controller: editController,
            decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: "Edit"),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                ref.doc(id).update(
                    {'title': editController.text.toString()}).then((value) {
                  Utils().toastMessage(' Successfully Updated');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
            ),
          ],
        );
      },
    );
  }
}
