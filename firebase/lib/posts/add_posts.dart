import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  TextEditingController postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Post Screen'),
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
                    databaseRef.child(id).set({
                      'title': postController.text.toString(),
                      'id': id,
                    }).then((value) {
                      Utils().toastMessage("Post Added");
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                      debugPrint(error.toString());
                    });
                  },
                  title: 'Add')
            ],
          ),
        ));
  }


  
}
