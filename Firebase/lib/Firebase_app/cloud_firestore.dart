import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudFireBaseManagement extends StatefulWidget {
  const CloudFireBaseManagement({super.key});

  @override
  State<CloudFireBaseManagement> createState() =>
      _CloudFireBaseManagementState();
}

class _CloudFireBaseManagementState extends State<CloudFireBaseManagement> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var incomingDataTitle = "";
  var incomingDataContents = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  //kullanıcıyı aldık
  textSet() {
    FirebaseFirestore.instance
        .collection("Textfieldvalue")
        .doc(t1.text) //dosya adı
        .set({
      //kullanıcı post paylasırken mevcut kullanıcının idsi ile kayıt yapılır
      "userid": auth.currentUser?.uid,
      "title": t1.text,
      "contents": t2.text
    }).whenComplete(() => print('eklendi')); //icerik
    //burada auth.currentUser?.uid yerine auth.currentUser?.email de yapabilirdik
  }

  textUpdate() {
    FirebaseFirestore.instance
        .collection("Textfieldvalue")
        .doc(t1.text) //dosya adı
        .update({"title": t1.text, "contents": t2.text}).whenComplete(
            () => print('güncellendi')); //icerik
  }

  textDelete() {
    FirebaseFirestore.instance
        .collection("Textfieldvalue")
        .doc(t1.text) //dosya adı
        .delete()
        .whenComplete(() => print('silindi')); //icerik
  }

  textGet() {
    FirebaseFirestore.instance
        .collection("Textfieldvalue")
        .doc(t1.text)
        .get()
        .then((incomingData) {
      setState(() {
        incomingDataContents = incomingData.data()?['contents'];
        incomingDataTitle = incomingData.data()?['title'];
      });
    });
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
            TextButton(onPressed: textSet, child: const Text('Ekle')),
            TextButton(onPressed: textUpdate, child: const Text('Güncelle')),
            TextButton(onPressed: textDelete, child: const Text('Sil')),
            TextButton(onPressed: textGet, child: const Text('Göster'))
          ],
        ),
        ListTile(
          title: Text(incomingDataTitle),
          subtitle: Text(incomingDataContents),
        )
      ]),
    );
  }
}
