import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'imagepicker_storage.dart';

class FirebaseAuthentication extends StatefulWidget {
  const FirebaseAuthentication({super.key});

  @override
  State<FirebaseAuthentication> createState() => _FirebaseAuthenticationState();
}

class _FirebaseAuthenticationState extends State<FirebaseAuthentication> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  Future<void> register() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: t1.text, password: t2.text) //burada kayıt bitti
        .then((user) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(t1.text)
          .set({"userMail": t1.text, "userPassword": t2.text});
      //daha sonra kullanıcı bilgilerini firestore'a kaydettik
    }).whenComplete(() => print('Kullanici veri tabanina kaydedildi'));
  }

  login() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ImagePickerStorage(),
          ),
          (Route<dynamic> route) => false); //push yerine pushandremoveuntil
      //yaparak önceki sayfaya dönmeyi engelledik. push yapsaydık bir üstteki
      //satira gerek yoktu. True yaparak geri butonunu etkinleştirebiliriz
    }).whenComplete(() => print('Giris Yapildi'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        TextField(
          controller: t1,
        ),
        TextField(
          controller: t2,
        ),
        Row(
          children: [
            TextButton(onPressed: register, child: const Text('Register')),
            TextButton(onPressed: login, child: const Text('Login')),
          ],
        ),
      ]),
    );
  }
}
