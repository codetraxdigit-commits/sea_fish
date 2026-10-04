import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../models/boat_model.dart';

abstract class BoatRemoteDataSource {
  Future<BoatModel?> getMyBoat();

  Future<BoatModel> addBoat({
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
  });

  Future<BoatModel> updateBoat({
    required String boatId,
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
    required String existingImageUrl,
  });
}

class BoatRemoteDataSourceImpl implements BoatRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  BoatRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.storage,
  });

  @override
  Future<BoatModel?> getMyBoat() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    debugPrint('========== GET MY BOAT ==========');
    debugPrint('Current UID: ${firebaseAuth.currentUser?.uid}');

    final snapshot = await firestore
        .collection('boats')
        .where(
      'ownerId',
      isEqualTo: firebaseAuth.currentUser?.uid,
    )
        .get();

    debugPrint('Documents found: ${snapshot.docs.length}');

    for (final doc in snapshot.docs) {
      debugPrint('Document ID: ${doc.id}');
      debugPrint('Document data: ${doc.data()}');
    }

    debugPrint('=================================');
    if (snapshot.docs.isEmpty) {
      debugPrint('NO BOAT FOUND');
      return null;
    }

    debugPrint('BOAT DATA: ${snapshot.docs.first.data()}');

    return BoatModel.fromFirestore(
      snapshot.docs.first,
    );
  }
  @override
  Future<BoatModel> addBoat({
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final existingBoat = await firestore
        .collection('boats')
        .where('ownerId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (existingBoat.docs.isNotEmpty) {
      throw Exception('You already have a registered boat.');
    }

    final boatReference =
    firestore.collection('boats').doc();

    String imageUrl = '';

    if (imagePath.isNotEmpty) {
      imageUrl = await _uploadBoatImage(
        user.uid,
        boatReference.id,
        imagePath,
      );
    }

    final now = Timestamp.now();

    final boatModel = BoatModel(
      id: boatReference.id,
      ownerId: user.uid,
      boatName: boatName.trim(),
      registrationNumber: registrationNumber.trim(),
      boatType: boatType.trim(),
      capacityKg: capacityKg,
      engineNumber: engineNumber.trim(),
      licenseNumber: licenseNumber.trim(),
      imageUrl: imageUrl,
      status: 'active',
      createdAt: now.toDate(),
      updatedAt: now.toDate(),
    );

    await boatReference.set(
      boatModel.toFirestore(),
    );

    final document = await boatReference.get();

    return BoatModel.fromFirestore(document);
  }

  @override
  Future<BoatModel> updateBoat({
    required String boatId,
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
    required String existingImageUrl,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final boatReference =
    firestore.collection('boats').doc(boatId);

    final document = await boatReference.get();

    if (!document.exists) {
      throw Exception('Boat does not exist.');
    }

    final existingData = document.data();

    if (existingData == null ||
        existingData['ownerId'] != user.uid) {
      throw Exception(
        'You are not allowed to update this boat.',
      );
    }

    String imageUrl = existingImageUrl;

    if (imagePath.isNotEmpty) {
      imageUrl = await _uploadBoatImage(
        user.uid,
        boatId,
        imagePath,
      );
    }

    await boatReference.update({
      'boatName': boatName.trim(),
      'registrationNumber': registrationNumber.trim(),
      'boatType': boatType.trim(),
      'capacityKg': capacityKg,
      'engineNumber': engineNumber.trim(),
      'licenseNumber': licenseNumber.trim(),
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final updatedDocument = await boatReference.get();

    return BoatModel.fromFirestore(updatedDocument);
  }

  Future<String> _uploadBoatImage(
      String uid,
      String boatId,
      String imagePath,
      ) async {
    final file = File(imagePath);

    if (!await file.exists()) {
      throw Exception('Selected boat image does not exist.');
    }

    final reference = storage
        .ref()
        .child('boats')
        .child(uid)
        .child('$boatId.jpg');

    await reference.putFile(
      file,
      SettableMetadata(
        contentType: 'image/jpeg',
      ),
    );

    return await reference.getDownloadURL();
  }
}