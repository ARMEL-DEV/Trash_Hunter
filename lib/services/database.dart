import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DatabaseService {

  FirebaseFirestore db = FirebaseFirestore.instance;

  createPersonne() {
    // Create a new user with a first and last name
    /*
    Map<String, Object> user = new HashMap<>();
    user.put("first", "Ada");
    user.put("last", "Lovelace");
    user.put("born", 1815);

    // Add a new document with a generated ID
    db.collection("users")
    .add(user)
    .addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
      @Override
      public void onSuccess(DocumentReference documentReference) {
        Log.d(TAG, "DocumentSnapshot added with ID: " + documentReference.getId());
      }
    })
    .addOnFailureListener(new OnFailureListener() {
      @Override
      public void onFailure(@NonNull Exception e) {
        Log.w(TAG, "Error adding document", e);
      }
    });
     */
  }
}
