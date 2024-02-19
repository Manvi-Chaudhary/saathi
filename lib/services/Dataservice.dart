import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:saathi/model/CheckModel.dart';


class Dataservice {
  String uid = "";
  Dataservice({required this.uid});

  CollectionReference record = FirebaseFirestore.instance.collection("data");

  CollectionReference sharedChecklist = FirebaseFirestore.instance.collection("SharedChecklist");
  


  Future add(CheckModel task) async {
    try{
      return await sharedChecklist.doc().set({"task" : task.task,"isDone" : task.isComplete,"Date" : DateTime.now().toIso8601String()});

    }catch(e){
      return null;
    }
  }


  Future update(CheckModel task,String did) async {
    try{
      return await sharedChecklist.doc(did).set({"task" : task.task,"isDone" : task.isComplete,"Date" : DateTime.now().toIso8601String()});

    }catch(e){
      return null;
    }
  }

  List<CheckModel> _listdatafromsnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => CheckModel(
        did : doc.id,
      task: doc.get("task"),
    isComplete: doc.get("isDone")))
        .toList();
  }


  Stream<List<CheckModel>> getChecklist() {
    return sharedChecklist.orderBy("Date").snapshots().map(_listdatafromsnapshot);
  }

  Future cred(String email, String username, String password) async {
    try{
      return await record
          .doc(uid)
          .set({"Email": email, "Username": username, "Password": password});
    }catch(e){
      print("error in db: "+e.toString());
    }
  }

  Future<String?> getemail(String username, String password) async {
    QuerySnapshot s = await record
        .where("Username", isEqualTo: username)
        .where("Password", isEqualTo: password)
        .get();
    if (s.docs == []) {
      return null;
    }
    return s.docs[0]["Email"];
  }






}