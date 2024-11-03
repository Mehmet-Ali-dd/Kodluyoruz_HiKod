import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SikayetlerimSayfasi extends StatefulWidget {
  @override
  _SikayetlerimSayfasiState createState() => _SikayetlerimSayfasiState();
}

class _SikayetlerimSayfasiState extends State<SikayetlerimSayfasi> {
  final List<String> collections = [
    "İzinsiz Fotoğraf Paylaşımı",
    "Kişisel Bilgi Paylaşımı",
    "Tehdit",
    "Trolleme",
    "Oyun İçi Zorbalama",
  ];

  // Başlıkların açılıp kapandığını tutan liste
  List<bool> _isExpanded;

  _SikayetlerimSayfasiState() : _isExpanded = List.filled(5, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geçmiş Şikayetler"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wp.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView.builder(
          itemCount: collections.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded[index] = !_isExpanded[index]; // Başlığın durumunu değiştir
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Gölgenin konumu
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          collections[index],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          _isExpanded[index]
                              ? Icons.arrow_drop_up // Aşağı bakan ok
                              : Icons.arrow_drop_down, // Yukarı bakan ok
                          color: Colors.blue.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isExpanded[index]) // Eğer başlık açık ise
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Gölgenin konumu
                        ),
                      ],
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(collections[index])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Bir hata oluştu: ${snapshot.error}"));
                        }

                        final sikayetler = snapshot.data!.docs;

                        if (sikayetler.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Bu koleksiyonda şikayet yok."),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true, // Yükseklik sınırlama
                          physics: NeverScrollableScrollPhysics(), // Scroll'u devre dışı bırak
                          itemCount: sikayetler.length,
                          itemBuilder: (context, index) {
                            var sikayet = sikayetler[index];
                            String problemName = sikayet['problemName'] ?? "Bilgi yok";
                            Timestamp timestamp = sikayet['timestamp'] ?? Timestamp.now();
                            String date = timestamp.toDate().toString().split(' ')[0]; // Tarih formatını ayarlama

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 2), // Gölgenin konumu
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text("$problemName - $date"),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}