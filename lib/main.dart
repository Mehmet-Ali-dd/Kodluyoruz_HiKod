import 'package:flutter/material.dart';
import 'package:kdlyrz/ana_sayfa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'kayit.dart';
import 'problemler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dijital Farkındalık',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnaSayfa(),
      routes: {
        '/ana_sayfa': (context) => AnaSayfa(),
        '/kayit': (context) => KayitSayfasi(), // Kayıt sayfasını tanımla
        '/problemler': (context) => ProblemlerSayfasi(email: '',), // Problemler sayfasını tanımla
      },
    );

  }

}


