import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kdlyrz/ana_sayfa.dart';
import 'package:kdlyrz/problemler.dart';

class KullaniciBilgileriSayfasi extends StatefulWidget {
  final String email; // Kullanıcı e-posta bilgisi

  KullaniciBilgileriSayfasi({required this.email});

  @override
  _KullaniciBilgileriSayfasiState createState() => _KullaniciBilgileriSayfasiState();
}

class _KullaniciBilgileriSayfasiState extends State<KullaniciBilgileriSayfasi> {
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _soyisimController = TextEditingController();
  final TextEditingController _yasController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  bool _sifreGizli = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .where('mail', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        setState(() {
          _isimController.text = userDoc['isim'];
          _soyisimController.text = userDoc['soyisim'];
          _yasController.text = userDoc['yas'].toString();
          _mailController.text = userDoc['mail'];
          _telefonController.text = userDoc['telefon'];
          _adresController.text = userDoc['adres'];
          _sifreController.text = userDoc['sifre'];
        });
      } else {
        _showDialog("Kullanıcı bilgileri bulunamadı.");
      }
    } catch (e) {
      _showDialog("Veritabanından veri çekilirken hata oluştu: $e");
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .where('mail', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        await FirebaseFirestore.instance
            .collection('Kullanıcılar')
            .doc(userDoc.id)
            .update({
          'isim': _isimController.text,
          'soyisim': _soyisimController.text,
          'yas': int.tryParse(_yasController.text) ?? 0,
          'telefon': _telefonController.text,
          'adres': _adresController.text,
          'sifre': _sifreController.text,
        });
        _showDialog("Bilgiler güncellendi.");
      }
    } catch (e) {
      _showDialog("Güncelleme sırasında hata oluştu: $e");
    }
  }

  Future<void> _deleteUser() async {
    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .where('mail', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        await FirebaseFirestore.instance
            .collection('Kullanıcılar')
            .doc(userDoc.id)
            .delete();
        _showDialog("Kullanıcı silindi.");
      }
    } catch (e) {
      _showDialog("Silme işlemi sırasında hata oluştu: $e");
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Uyarı"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop(); // Öncelikle dialog'u kapat
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AnaSayfa(), // AnaSayfaya yönlendir
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Bilgileri"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/wp.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _isimController,
                    decoration: InputDecoration(
                      labelText: "İsim",
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _soyisimController,
                    decoration: InputDecoration(
                      labelText: "Soyisim",
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _yasController,
                    decoration: InputDecoration(
                      labelText: "Yaş",
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _mailController,
                    decoration: InputDecoration(
                      labelText: "Mail",
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _telefonController,
                    decoration: InputDecoration(
                      labelText: "Telefon Numarası",
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _adresController,
                    decoration: InputDecoration(
                      labelText: "Adres",
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
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
                    ),
                    obscureText: _sifreGizli,
                    //obscureText: true,
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _updateUserInfo,
                        child: Text(
                          "GÜNCELLE",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                      ElevatedButton(
                        onPressed: _deleteUser,
                        child: Text(
                          "SİL",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
