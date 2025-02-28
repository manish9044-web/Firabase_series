import 'dart:async';

import 'package:firebase/firestore/firestore_list_screen.dart';
import 'package:firebase/login_screen.dart';
import 'package:firebase/posts/post_screen.dart';
import 'package:firebase/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            // context, MaterialPageRoute(builder: (context) => PostScreen()));
            context,
            MaterialPageRoute(builder: (context) => FireStoreScreen()));
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
}
