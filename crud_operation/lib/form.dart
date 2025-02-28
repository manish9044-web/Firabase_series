import 'package:crud_operation/service/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Employee",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Form",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: "Enter your Name"),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text("Age",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: "Enter your age"),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text("Location",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: "Enter your location"),
              ),
              SizedBox(
                height: 35,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      String id = randomAlphaNumeric(10).toString();
                      Map<String, dynamic> employeeInfoMap = {
                        "Name": nameController.text,
                        "Age": ageController.text,
                        "Location": locationController.text,
                        "Id": id,
                      };
                      await DatabaseMethods()
                          .addEmployeeDetils(employeeInfoMap, id)
                          .then((value) {
                        Fluttertoast.showToast(
                          msg: "Details Added Sucessfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      });
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    )),
              )
            ]),
      ),
    );
  }
}
