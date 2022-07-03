import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrudMethods {
  Future<void> addData(blogData, String id) async {
    print(blogData);
    FirebaseFirestore.instance.collection("images").doc(id).set(blogData);
  }
}
