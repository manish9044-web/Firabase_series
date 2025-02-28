import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addEmployeeDetils(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<Stream<QuerySnapshot>> getEmployeeDetils() async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .snapshots();
  }

  Future updateEmployeeDetails(String id, Map<String, dynamic> employeeInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .update(employeeInfoMap);
  }

  Future deleteEmployeeDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .delete();
  }
}
