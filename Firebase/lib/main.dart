import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Firebase_app/firebase_auth.dart';

//firebase islemleri icin böyle yapmalıyız
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //burada getmaterial app yaptık cünkü lottiede theme change icin lazim
    return MaterialApp(
      //materialapp projenin şemasını çiziyor
      title:
          'Flutter Demo', //android kisminda kareye basıp kaydırıp kapattigimiz yerde cikan isim
      debugShowCheckedModeBanner: false,
      theme: //LightTheme().theme,   //custom theme'da change theme yaparken hata verdi ??
          ThemeData.light(),
      home: FirebaseAuthentication(),
      //const FirebaseAuthentication(), //ara sayfayı burada çagiriyoruz
    );
  }
}
