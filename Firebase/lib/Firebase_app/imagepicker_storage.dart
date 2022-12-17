import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_auth.dart';

class ImagePickerStorage extends StatefulWidget {
  const ImagePickerStorage({super.key});

  @override
  State<ImagePickerStorage> createState() => _ImagePickerStorageState();
}

class _ImagePickerStorageState extends State<ImagePickerStorage> {
  late File file;
  FirebaseAuth auth = FirebaseAuth.instance;
  var downloadUrl;
  final _firebaseStorage = FirebaseStorage.instance;

  //program calıstıgında getUrl fonksiyonunu otomatik olarak calıstırır
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUrl());
  }

  //profil fotosunu getirme
  getUrl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profil Resmi.png")
        .getDownloadURL();
    setState(() {
      downloadUrl = baglanti;
    });
  }

  uploadImage() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      file = File(pickedFile!.path);
    });
    var snapshot = await _firebaseStorage
        .ref()
        .child("profilepictures")
        .child(auth.currentUser!.uid)
        .child("myprofilepicture.png")
        .putFile(file);
    var url = await snapshot.ref.getDownloadURL();
    setState(() {
      downloadUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FirebaseAuthentication()),
                      (Route<dynamic> route) => false);
                });
              }),
        ],
      ),
      body: Row(
        children: [
          ClipOval(
            //downloadUrl bos olunca hata vermemesi icin böyle yaptım
            child: downloadUrl == null
                ? const Text('No Profile Picture')
                : Image.network(
                    downloadUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          TextButton(
              onPressed: uploadImage,
              child: const Text('Choose Profile Picture')),
        ],
      ),
    );
  }
}
