import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProbIcerigiSayfasi extends StatefulWidget {
  final String problemName;

  ProbIcerigiSayfasi({required this.problemName});

  @override
  _ProbIcerigiSayfasiState createState() => _ProbIcerigiSayfasiState();
}

class _ProbIcerigiSayfasiState extends State<ProbIcerigiSayfasi> {
  final TextEditingController _sikayetController = TextEditingController();
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isFormVisible = false;

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Uyarı", style: TextStyle(color: Colors.red))),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.blue.shade50,
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text("Tamam", style: TextStyle(fontSize: 20, color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    if (_emailController.text.isNotEmpty && !_emailController.text.endsWith("@gmail.com")) {
      _emailController.text = _emailController.text + "@gmail.com";
    }

    if (_isimController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty) {
      _saveToFirestore();
      _showAlertDialog("Mesajınız gönderildi");
    } else {
      _showAlertDialog("Eksik bilgi");
    }
  }

  Future<void> _saveToFirestore() async {
    try {
      // Belge sayısını öğrenip yeni belge için ID belirleme
      CollectionReference sikayetlerCollection = FirebaseFirestore.instance.collection(widget.problemName);
      QuerySnapshot querySnapshot = await sikayetlerCollection.get();
      int documentCount = querySnapshot.size;

      String newDocumentId = 'sikayet_${documentCount.toString().padLeft(2, '0')}';

      // Veriyi Firestore'a kaydetme
      await sikayetlerCollection.doc(newDocumentId).set({
        'problemName': widget.problemName,
        'sikayet': _sikayetController.text,
        'name': _isimController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Kaydettikten sonra alanları temizleme
      _sikayetController.clear();
      _isimController.clear();
      _emailController.clear();
      _phoneController.clear();
    } catch (e) {
      print("Veri kaydedilirken hata oluştu: $e");
      _showAlertDialog("Veri kaydedilirken hata oluştu.");
    }
  }

  String _getProblemText() {
    switch (widget.problemName) {
      case "İzinsiz Fotoğraf Paylaşımı":
        return "Eğer size ait bir fotoğrafın izinsiz şekilde paylaşıldığını fark ettiyseniz, Türk Ceza Kanunu’nun (TCK) 134. maddesi (özel hayatın gizliliğini ihlal) ve Kişisel Verilerin Korunması Kanunu (KVKK) çerçevesinde yasal haklarınızı kullanabilirsiniz. Bu tür bir ihlalle karşılaştığınızda, aşağıdaki formu doldurarak hukuki işlem başlatabilirsiniz.";
      case "Kişisel Bilgi Paylaşımı":
        return "Eğer size ait kişisel bilgilerin izinsiz şekilde paylaşıldığını fark ettiyseniz, Türk Ceza Kanunu’nun (TCK) 136. maddesi (kişisel verilerin hukuka aykırı olarak ele geçirilmesi ve yayılması) ve Kişisel Verilerin Korunması Kanunu (KVKK) kapsamında yasal haklarınızı kullanabilirsiniz. Böyle bir durumla karşılaştığınızda, aşağıdaki formu doldurarak hukuki işlem başlatabilirsiniz.";
      case "Tehdit":
        return "Bir kişiye zarar vereceğini söyleyerek korkutma eylemidir. Türk Ceza Kanunu'nın 106. maddesi uyarınca, tehdit suçu 6 aydan 2 yıla kadar hapisle cezalandırılır. Böyle bir şikayetiniz varsa aşağıdaki formu doldurunuz.";
      case "Trolleme":
        return "Dijital platformlarda kişilere rahatsızlık verme ve yanıltıcı bilgi yayma eylemleridir. Türk Ceza Kanunu’nun 125. maddesi (hakaret), 106. maddesi (tehdit) ve 216. maddesi (halkı kin ve düşmanlığa tahrik) kapsamında suç teşkil edebilir. Ayrıca Kişisel Verilerin Korunması Kanunu (KVKK) ile de ilgili olabilir. Böyle bir şikayetiniz varsa aşağıdaki formu doldurunuz.";
      case "Oyun İçi Zorbalama":
        return "Girdiğiniz bir oyunda hakaret, tehdit, taciz veya dışlama gibi saldırgan davranışlara maruz kalıyorsanız, Türk Ceza Kanunu’nun (TCK) 125. maddesi (hakaret), 106. maddesi (tehdit) ve Kişisel Verilerin Korunması Kanunu (KVKK) kapsamında yasal yollara başvurabilirsiniz. Böyle bir şikayetiniz varsa aşağıdaki formu doldurunuz.";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.problemName),
        backgroundColor: Colors.blue.shade400,
      ),
      resizeToAvoidBottomInset: true, // Ekran daraltılır
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _getProblemText(),
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isFormVisible = !_isFormVisible;
                          });
                        },
                        child: Text(
                          _isFormVisible ? "Formu Gizle" : "Formu Göster",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      if (_isFormVisible) ...[
                        TextField(
                          controller: _sikayetController,
                          decoration: InputDecoration(
                            labelText: "Şikayetiniz",
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _isimController,
                          decoration: InputDecoration(
                            labelText: "Adınız",
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "E-posta",
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: "Telefon Numarası",
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Başına 0 koymayınız",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              "Gönder",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}