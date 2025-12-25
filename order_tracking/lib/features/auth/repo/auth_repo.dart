import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking/features/auth/models/user_model.dart';

class AuthRepo {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<Either<String, String>> registerUser({
    required String password,
    required String userName,
    required String email,
  }) async {
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firebaseFirestore.collection("users").doc(user.user!.uid).set({
        "username": userName,
        "email": email,
        "uid": user.user!.uid,
      });
      return const Right("Account created successfuly");
    } catch (e) {
      log(e.toString());
      return Left("the error userCredential :$e");
    }
  }

  Future<Either<String, UserModel>> loginUser({
    required String password,
    required String email,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCredential.user!.uid;

      final querySnapshot = await firebaseFirestore
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Left("User data not found in database");
      }

      final userData = querySnapshot.docs.first.data();

      return Right(UserModel.fromeJson(userData));
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Authentication error");
    } catch (e) {
      return Left("Unexpected error: $e");
    }
  }
}
