import 'package:firebase/login_screen.dart';
import 'package:firebase/posts/add_posts.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  // Corrected database reference path
  final ref = FirebaseDatabase.instance.ref('Post');

  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.once().then((DatabaseEvent event) {
      print('Database connection test: ${event.snapshot.value}');
    }).catchError((error) {
      print('Error connecting to database: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                // Check if snapshot has data and is not null
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Get the map of posts
                Map<dynamic, dynamic>? map =
                    snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

                // Check if map is null
                if (map == null) {
                  return const Center(child: Text('No posts found'));
                }

                // Convert map to list of posts
                List<dynamic> list = map.values.toList();

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    // Filter posts based on search input
                    if (searchFilter.text.isEmpty ||
                        list[index]['title']
                            .toString()
                            .contains(searchFilter.text.toString())) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(list[index]['title'] ?? 'No Title'),
                          subtitle: Text(list[index]['id'] ?? 'No ID'),
                          trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showMyDialog(list[index]['title'],
                                                list[index]['id']);
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
                                                .child(list[index]['id'])
                                                .remove();
                                          },
                                          leading: Icon(Icons.delete_outline),
                                          title: Text("Delete"),
                                        ))
                                  ]),
                        ),
                      );
                    } else {
                      return Container(); // Hide items that don't match search
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
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
                ref.child(id).update(
                    {'title': editController.text.toLowerCase()}).then((value) {
                  Utils().toastMessage('Updated');
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

//second method without stream builder to fetch data from firebase (show data)
// Expanded(
//             child: FirebaseAnimatedList(
//               query: ref,
//               defaultChild: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//               itemBuilder: (context, snapshot, index, animation) {
//                 final title = snapshot.child('title').value.toString();

//                 if (searchFilter.text.isEmpty) {
//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: ListTile(
//                       title: Text(
//                         snapshot.child('title').value?.toString() ?? 'No Title',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         snapshot.child('id').value?.toString() ?? 'No ID',
//                       ),
//                     ),
//                   );
//                 } else if (title
//                     .toLowerCase()
//                     .contains(searchFilter.text.toLowerCase().toString())) {
//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: ListTile(
//                       title: Text(
//                         snapshot.child('title').value?.toString() ?? 'No Title',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         snapshot.child('id').value?.toString() ?? 'No ID',
//                       ),
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               },
//             ),
//           ),
