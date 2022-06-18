import 'dart:developer';

import 'package:clube_vantagens/services/local_storage.dart';
import 'package:clube_vantagens/ui/home/home_ui.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({Key? key}) : super(key: key);

  @override
  _ProfileUiState createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  Map user = {};
  int count = 0;
  List instituitions = [];
  bool showLoading = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecione as instituições',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Escolha duas instituições para receber doações',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ],
        ),
        backgroundColor: Color(0xfffeca57),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 10,
        actions: [],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            List i = instituitions
                .where((element) => element['marcado'] ?? false)
                .toList();
            if (i.length == 2) {
              Get.to(() => HomeUi());
            } else if (i.length > 2) {
              Get.snackbar(
                'Ops',
                'É permitido apenas duas instituições',
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            } else {
              Get.snackbar(
                'Ops',
                'Selecione pelo menos duas instituições',
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            }
          },
        ),
      ),
      body: this.showLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: FutureBuilder<Response>(
          future: this.getInstituitions(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            print(snapshot.data?.data);
            instituitions = snapshot.data?.data;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: List.generate(instituitions.length, (index) {
                  return CheckboxListTile(
                    secondary: Text(
                      instituitions[index]['doacoes'].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    activeColor: Colors.black,
                    title: GestureDetector(
                      onTap: () async {
                        if (await canLaunch(instituitions[index]['site'])) {
                          await launch(instituitions[index]['site']);
                        }
                      },
                      child: Image.network(
                        instituitions[index]['logo'] ?? '',
                        height: 50,
                      ),
                    ),
                    selectedTileColor: Colors.grey,
                    value: instituitions[index]['marcado'] ?? false,
                    onChanged: (bool? value) async {
                      List i = instituitions
                          .where((element) => element['marcado'] ?? false)
                          .toList();
                      if (i.length == 2 && value!) {
                        Get.snackbar(
                          'Ops',
                          'É permitido apenas duas instituições',
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                      } else {
                        
                        this.showLoading = true;
                        setState(() {
                          
                        });
                        Dio().post(
                          'http://joao.esquilodigital.com.br/public/instituicoes/doar',
                          data: {
                            '_id': instituitions[index]['_id'] ?? 0,
                            'user_id': user['id'] ?? null,
                            'instituition_id': instituitions[index]['id']
                          },
                        ).then((_) {
                          if (value ?? false) {
                            instituitions[index]['marcado'] = value;
                            count++;
                          } else {
                            count--;
                          }
                          this.showLoading = false;
                          setState(() {});
                        });
                      }
                    },
                  );
                }),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            List i = instituitions
                .where((element) => element['marcado'] ?? false)
                .toList();
            if (i.length == 2) {
              Get.to(() => HomeUi());
            } else if (i.length > 2) {
              Get.snackbar(
                'Ops',
                'É permitido apenas duas instituições',
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            } else {
              Get.snackbar(
                'Ops',
                'Selecione pelo menos duas instituições',
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            }
          },
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Text(
              'AVANÇAR',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Response> getInstituitions() async {
    String? email = FirebaseAuth.instance.currentUser?.email;

    Response user = await Dio().get(
      'http://joao.esquilodigital.com.br/public/usuarios?email=$email',
    );
    log('user ==> ' + user.data.toString());
    this.user = user.data;

    return Dio().get(
        'http://joao.esquilodigital.com.br/public/instituicoes?user=${user.data['id']}');
  }

  Future<void> doar(bool? value, int index) async {
    Dio().post(
      'http://joao.esquilodigital.com.br/public/instituicoes/doar',
      data: {
        '_id': this.instituitions[index]['_id'] ?? 0,
        'user_id': user['id'] ?? null,
        'instituition_id': this.instituitions[index]['id']
      },
    ).then((_) {
      setState(() {
        this.instituitions[index]['marcado'] = value;
        if (value ?? false) {
          count++;
        } else {
          count--;
        }
      });
    });
  }
}
