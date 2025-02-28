import 'dart:math';

import 'package:firebase/posts/post_screen.dart';
import 'package:firebase/signupscreen.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // title: const Text('Login'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login here..!",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome back you've",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "been missed!",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email can't be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  RoundButton(
                    title: "Login",
                    loading: loading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        _auth
                            .signInWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString())
                            .then((value) {
                          setState(() {
                            loading = false;
                          });
                          Utils().toastMessage("Login Successfully");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostScreen()));
                        }).onError((error, stackTrace) {
                          debugPrint(error.toString());
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = true;
                          });
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
