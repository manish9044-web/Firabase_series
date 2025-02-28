import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operation/form.dart';
import 'package:crud_operation/service/database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  Stream? EmployeeStream;

  getload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetils();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getload();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              
                              children: [
                                Text("Name : " + ds["Name"],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                                        Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    nameController.text = ds['Name'];
                                    ageController.text = ds['Age'];
                                    locationController.text = ds['Location'];
                                    EditEmployeeDetail(ds['Id']);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    DatabaseMethods().deleteEmployeeDetails(ds['Id']);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Employee Deleted")));
                                  },
                                  child: Icon(Icons.delete, color: Colors.orange))
                              ],
                            ),
                            Text("Age : " + ds["Age"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold)),
                            Text("Location : " + ds["Location"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Container();
      },
      stream: EmployeeStream,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Flutter",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Firebase",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              Expanded(child: allEmployeeDetails()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormPage()));
          },
        ));
  }

  Future EditEmployeeDetail(String Id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: Container(
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel),
                ),
                Text(
                  "Edit",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Details",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                )
              ]),
              Container(
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
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async{
                            Map<String, dynamic> updateEmployeeInfoMap = {
                              "Name": nameController.text,
                              "Age": ageController.text,
                              "Id": Id,
                              "Location": locationController.text
                            };
                           await DatabaseMethods().updateEmployeeDetails(Id, updateEmployeeInfoMap);
                            Navigator.pop(context);
                          },
                          child: Text("Update"))
                    ],
                  ))
            ]),
          )));
}
