import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:findapet/pages/auth_pages/login_page.dart';
import 'package:findapet/firebase_options.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  /*  // Inicializa Firebase dependiendo de si es web o no
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB5uIs6MJ8x0f2kL2YBpcmpB54jG0AWJhg",
          authDomain: "findapet-app-56a90.firebaseapp.com",
          projectId: "findapet-app-56a90",
          storageBucket: "findapet-app-56a90.appspot.com",
          messagingSenderId: "343767235488",
          appId: "1:343767235488:web:134164c5703906c5e182c5"),
    );
  } else {
    await Firebase.initializeApp();
  } */
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Findapet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
