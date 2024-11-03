import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'kayit.dart';
import 'problemler.dart';

class AnaSayfa extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showAlert("Uyarı", "Lütfen e-posta ve şifrenizi girin.", context);
      return;
    }

    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .where('mail', isEqualTo: email)
          .where('sifre', isEqualTo: password)
          .limit(1)
          .get();

      print("Sorgulanan E-posta: $email");
      print("Sorgu Sonucu: ${userQuery.docs.length}");

      if (userQuery.docs.isNotEmpty) {
        // Başarılı giriş sonrası kullanıcı bilgilerini sakla
        final userDoc = userQuery.docs.first;
        String userId = userDoc.id; // Kullanıcı ID'si, gerektiğinde kullanabilirsiniz

        // Problemler sayfasına geçiş yap
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProblemlerSayfasi(email: email), // Email'i gönder
          ),
        );
      } else {
        _showAlert("Hata", "Bilgiler hatalı veya kayıtlı değilsiniz.", context);
      }
    } catch (e) {
      print("Giriş işlemi sırasında hata oluştu: $e");
      _showAlert("Hata", "Bir hata oluştu. Lütfen tekrar deneyin.", context);
    }
  }



  void _showAlert(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tamam"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Yardım Çağrı", style: TextStyle(fontSize: 35, color: Colors.black)),
                Text("Uygulaması", style: TextStyle(fontSize: 35, color: Colors.black)),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      labelText: 'E-posta',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      labelText: 'Şifre',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                  ),
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
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 10,
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      "Yardım Al",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    Text(
                      "Hesabın yok mu?",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KayitSayfasi()),
                        );
                      },
                      child: Text(
                        "Kayıt ol",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
