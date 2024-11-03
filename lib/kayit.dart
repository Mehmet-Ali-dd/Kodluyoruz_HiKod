import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class KayitSayfasi extends StatefulWidget {
  @override
  _KayitSayfasiState createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _soyisimController = TextEditingController();
  final TextEditingController _yasController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  bool _sifreGizli = true;
  String _sifreHataMesaji = "";

  @override
  void initState() {
    super.initState();
    // Giriş yapan kullanıcının UID'sini alma
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid;  // Giriş yapan kullanıcının UID'si
      print("Giriş yapan kullanıcının UID'si: $uid");
    } else {
      print("Kullanıcı giriş yapmamış.");
    }
  }

  void _kaydet() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase Authentication ile kullanıcı kaydı
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _mailController.text.trim(),
          password: _sifreController.text,
        );

        // Kullanıcı bilgilerini Firestore'a kaydetme
        String docId = "${_isimController.text}_${_soyisimController.text}";
        await FirebaseFirestore.instance.collection('Kullanıcılar').doc(docId).set({
          'isim': _isimController.text,
          'soyisim': _soyisimController.text,
          'yas': int.parse(_yasController.text),
          'mail': _mailController.text,
          'sifre': _sifreController.text,
          'telefon': _telefonController.text,
          'adres': _adresController.text,
          'uid': userCredential.user?.uid, // UID'yi kaydet
        });

        _showDialog("Kaydınız başarılı!", true);
      } catch (e) {
        _showDialog("Veri kaydetme sırasında bir hata oluştu: $e", false);
      }
    } else {
      _showDialog("Lütfen tüm alanları doğru bir şekilde doldurun.", false);
    }
  }

  void _showDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? "Başarılı" : "Hata"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.of(context).pushReplacementNamed('/ana_sayfa');
                }
              },
            ),
          ],
        );
      },
    );
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası boş olamaz';
    }
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Geçerli bir telefon numarası girin';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Yaş boş olamaz';
    }
    if (value.length != 2 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Geçerli bir yaş girin';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _sifreHataMesaji = 'Şifre boş olamaz';
      });
      return ' ';
    }
    if (value.length < 8 || !RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])').hasMatch(value)) {
      setState(() {
        _sifreHataMesaji = 'Şifre en az 8 karakter, bir büyük harf ve bir rakam içermelidir';
      });
      return ' ';
    }
    setState(() {
      _sifreHataMesaji = '';
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text("Kayıt Ol"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _isimController,
                  decoration: InputDecoration(
                    labelText: "İsim",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "İsim boş olamaz" : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _soyisimController,
                  decoration: InputDecoration(
                    labelText: "Soyisim",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Soyisim boş olamaz" : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _yasController,
                  decoration: InputDecoration(
                    labelText: "Yaş",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateAge,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _mailController,
                  decoration: InputDecoration(
                    labelText: "Mail",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    if (!value.contains("@gmail.com")) {
                      _mailController.text = "${_mailController.text.trim()}@gmail.com";
                    }
                  },
                  validator: (value) => value!.isEmpty ? "Mail boş olamaz" : null,
                ),
                SizedBox(height: 8),
                Text(
                  "@gmail.com ile birlikte yazınız",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _sifreController,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_sifreGizli ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _sifreGizli = !_sifreGizli;
                        });
                      },
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  obscureText: _sifreGizli,
                  validator: _validatePassword,
                ),
                if (_sifreHataMesaji.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _sifreHataMesaji,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _telefonController,
                  decoration: InputDecoration(
                    labelText: "Telefon Numarası",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: _validatePhone,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _adresController,
                  decoration: InputDecoration(
                    labelText: "Adres",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Adres boş olamaz" : null,
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.purple.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: _kaydet,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 10,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(
                    "Kaydet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
               ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}