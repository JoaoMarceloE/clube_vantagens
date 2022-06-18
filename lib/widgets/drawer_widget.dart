import 'dart:developer';

import 'package:clube_vantagens/main.dart';
import 'package:clube_vantagens/ui/home/home_ui.dart';
import 'package:clube_vantagens/ui/perfil/ProfileUi.dart';
import 'package:clube_vantagens/ui/screens/cupom_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:get/get.dart';

class DrawerWidget extends StatefulWidget {
  final List? instituitions;

  const DrawerWidget({Key? key, this.instituitions}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // List instituitions = [];

  @override
  void initState() {
    super.initState();
    // Dio()
    //     .get(
    //         'http://joao.esquilodigital.com.br/public/usuarios?email=${FirebaseAuth.instance.currentUser?.email}')
    //     .then((value) {
    //   this.instituitions = value.data['instituitions'];
    //   log('DRAWER ==> ' + value.toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Color(0xfffeca57),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Image.network(
                        FirebaseAuth.instance.currentUser?.photoURL ?? '',
                        width: 40,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Clube de vantagens',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widget.instituitions!
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Image.network(
                      e['logo'],
                      fit: BoxFit.contain,
                      width: 70,
                    ),
                  ),
                )
                .toList(),
          ),
          ListTile(
            onTap: () {
              Get.to(() => ProfileUi());
            },
            title: Text(
              'Instituições',
              style: TextStyle(fontSize: 18),
            ),
            // trailing: Icon(Icons.more_vert),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text(
              'Anunciantes',
              style: TextStyle(fontSize: 18),
            ),
            // trailing: Icon(Icons.more_vert),
          ),
          ListTile(
            onTap: () {
              Get.to(() => CupomUi(
                    title: 'Como funciona',
                    description:
                        'Escolha 2 ong(s) na aba (instituições) que mais goste e que queira ajudar com parte dos valores arrecadados com os anúncios. Pronto.Você já está contribuindo.',
                  ));
            },
            title: Text(
              'Como funciona',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => CupomUi(
                    title: 'Sobre nós',
                    description:
                        'O nosso app fez a combinação de ideias entre promover empresas através de anúncios, incentivar a colaboração e doações para Instituições carentes e ONGs. Combinando assim, a nossa missão em dar visibilidade às marcas, além de oferecer a  oportunidade de se juntar as nossas ações sociais.',
                  ));
            },
            title: Text(
              'Sobre nós',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => CupomUi(
                    title: 'Entre em Contato',
                    description: '''Clube de Vantagens
contato@clubedevantagens.adm.br

(19) 3304-9171 / 99470-4788''',
                  ));
            },
            title: Text(
              'Entre em Contato',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.to(() => Login());
            },
            title: Text(
              'Sair',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () async {},
            title: Text(
              'Nossas redes:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch('http://clubedevantagens.adm.br')) {
                      await launch('http://clubedevantagens.adm.br');
                    }
                  },
                  child: Image.asset('assets/site.png', width: 30),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch('https://wa.me/559994704788')) {
                      await launch('https://wa.me/559994704788');
                    }
                  },
                  child: Image.asset('assets/whatsapp.png', width: 30),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(
                        'https://www.instagram.com/app_clube_devantagens_cps')) {
                      await launch(
                          'https://www.instagram.com/app_clube_devantagens_cps');
                    }
                  },
                  child: Image.asset('assets/instagram.png', width: 30),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(
                        'https://www.facebook.com/APP-Clube-de-Vantagens-Campinas-152967151939003')) {
                      await launch(
                          'https://www.facebook.com/APP-Clube-de-Vantagens-Campinas-152967151939003');
                    }
                  },
                  child: Image.asset('assets/facebook.png', width: 30),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
