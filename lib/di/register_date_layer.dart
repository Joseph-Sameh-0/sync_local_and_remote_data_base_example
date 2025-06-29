import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import 'injection_container.dart';
import 'register_data_sources.dart';
import 'register_repositories.dart';

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  } catch (e) {
    log('Failed to initialize Firebase: $e');
    rethrow;
  }
}

Future<void> registerDateLayer() async {
  sl.registerLazySingleton(() => SharedPreferences.getInstance());

  await _initializeFirebase();
  await registerDataSources();
  registerRepositories();
}
