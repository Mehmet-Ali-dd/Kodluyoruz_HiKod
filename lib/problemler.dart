import 'package:flutter/material.dart';
import 'ana_sayfa.dart'; // AnaSayfa dosyasını içe aktarıyoruz
import 'prob_içeriği.dart';
import 'sikayetlerim.dart';
import 'kullanici.dart';

class ProblemlerSayfasi extends StatelessWidget {
  final List<String> problemler = [
    "İzinsiz Fotoğraf Paylaşımı",
    "Kişisel Bilgi Paylaşımı",
    "Tehdit",
    "Trolleme",
    "Oyun İçi Zorbalama",
  ];

  final String email; // Kullanıcı e-posta adresini saklayacak

  // Constructor ile email'i alıyoruz
  ProblemlerSayfasi({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İhlal ve Saldırılar"),
        backgroundColor: Colors.blue.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AnaSayfa()),
                  (Route<dynamic> route) => false,
            ); // AnaSayfa'ya geri dön
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: problemler.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Problem İçeriği Sayfasına Yönlendir
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProbIcerigiSayfasi(problemName: problemler[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  problemler[index],
                  style: TextStyle(fontSize: 19, color: Colors.black),
                ),
              ),
            );
          },
        ),
      ),
      // Navigasyon Çubuğu
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem, color: Colors.black),
            label: 'Problemler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.black),
            label: 'Geçmiş Şikayetler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Kullanıcı Bilgileri',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SikayetlerimSayfasi()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KullaniciBilgileriSayfasi(email: email)), // email'i geçiyoruz
            );
          }
        },
      ),
    );
  }
}
