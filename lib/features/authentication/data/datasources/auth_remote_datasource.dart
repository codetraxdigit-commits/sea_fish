import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishtrack/features/authentication/domain/entities/user_entity.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  // ----------------------------------------------------------
  // LOGIN
  // ----------------------------------------------------------

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential =
    await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User authentication failed.',
      );
    }

    final document = await firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!document.exists) {
      throw Exception(
        'User profile does not exist.',
      );
    }

    final data = document.data();

    if (data == null) {
      throw Exception(
        'User profile data is empty.',
      );
    }

    return UserModel.fromFirestore(data);
  }

  // ----------------------------------------------------------
  // REGISTER
  // ----------------------------------------------------------

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // 1. Create Firebase Authentication user
      final credential =
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw Exception(
          'Firebase user creation failed.',
        );
      }

      final uid = firebaseUser.uid;

      debugPrint('AUTH USER CREATED');
      debugPrint('UID: $uid');
      debugPrint('EMAIL: ${firebaseUser.email}');

      // 2. Create UserModel
      final userModel = UserModel(
        uid: uid,
        email: email.trim(),
        name: name.trim(),
        role: role == 'vendor'
            ? UserRole.vendor
            : UserRole.fisherman,
      );

      debugPrint('USER DATA: ${userModel.toFirestore()}');

      // 3. Save to Firestore
      await firestore
          .collection('users')
          .doc(uid)
          .set(
        userModel.toFirestore(),
      );

      debugPrint('FIRESTORE USER CREATED');
      debugPrint('PATH: users/$uid');

      // 4. Verify Firestore document
      final document = await firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!document.exists) {
        throw Exception(
          'Firestore document was not created.',
        );
      }

      debugPrint(
        'FIRESTORE DATA: ${document.data()}',
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'FIREBASE AUTH ERROR: ${e.code}',
      );
      debugPrint(
        'MESSAGE: ${e.message}',
      );

      rethrow;
    } on FirebaseException catch (e) {
      debugPrint(
        'FIRESTORE ERROR: ${e.code}',
      );
      debugPrint(
        'MESSAGE: ${e.message}',
      );

      rethrow;
    } catch (e) {
      debugPrint(
        'REGISTER ERROR: $e',
      );

      rethrow;
    }
  }
  // ----------------------------------------------------------
  // LOGOUT
  // ----------------------------------------------------------

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  // ----------------------------------------------------------
  // CURRENT USER
  // ----------------------------------------------------------

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser =
        firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    final document = await firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return UserModel.fromFirestore(data);
  }

  // ----------------------------------------------------------
  // ROLE
  // ----------------------------------------------------------

  UserRole _roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'vendor':
        return UserRole.vendor;

      case 'fisherman':
        return UserRole.fisherman;

      case 'admin':
        return UserRole.admin;

      default:
        throw Exception(
          'Invalid user role.',
        );
    }
  }
}