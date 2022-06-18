import 'dart:developer';
import 'dart:ui';

import 'package:clube_vantagens/services/local_storage.dart';
import 'package:clube_vantagens/ui/home/home_ui.dart';
import 'package:clube_vantagens/ui/perfil/ProfileUi.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clube de vantagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @protected
  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Get.to(() => HomeUi());
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      Response response = await Dio().post(
        'http://joao.esquilodigital.com.br/public/usuarios',
        data: {
          "email": googleUser.email,
          "name": googleUser.displayName,
          "password": googleUser.id,
        },
      );

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      LocalStorageService.save('user', response.data).then((_) {
        print('Login ====> ' + response.data.toString());
        if (response.statusCode == 201 || response.statusCode == 200) {
          Get.snackbar(
            'Seja bem vindo',
            'Acessando o sistema..',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Future.delayed(Duration(seconds: 2)).then((_) {
            Get.to(() => ProfileUi());
          });
        } else {
          Get.snackbar(
            'Houve um problema',
            response.data.toString(),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      });
    } catch (err) {
      Get.snackbar(
        'Houve um problema',
        err.toString(),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon.png',
                  width: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Clube de vantagens',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              'Transformando anúncios em doações',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await this.signInWithGoogle();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.red,
                ),
                padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.mail),
                  Text(
                    'ENTRAR COM O GOOGLE',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
