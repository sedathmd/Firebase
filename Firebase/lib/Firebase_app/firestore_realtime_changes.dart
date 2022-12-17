import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/Firebase_app/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_auth.dart';
import 'realtime_changes_auth.dart';

//https://firebase.flutter.dev/docs/firestore/usage/
//buradan alıp scafflodun bodysine verdim
//ana sayfa gibi bütün kullanıcıların eklediklerini gösterir

class AllUsersPosts extends StatefulWidget {
  const AllUsersPosts({super.key});

  @override
  State<AllUsersPosts> createState() => _AllUsersPostsState();
}

class _AllUsersPostsState extends State<AllUsersPosts> {
  @override
  Widget build(BuildContext context) {
    //************************************************************ */
    CollectionReference _usersStream =
        FirebaseFirestore.instance.collection('Textfieldvalue');
    //********************************************************** */
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Page"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.person_off_outlined),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UserProfile()));
              }),
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
              }), // IconButton
        ], // <Widget> []
      ),
      //buradan altı verileri cekmeye yarıyor
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['contents']),
              );
            }).toList(),
          );
        },
      ),
      //burada veri eklemeye yönlendiriyoruz
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CloudFireBaseManagement()));
        },
      ),
    );
  }
}
