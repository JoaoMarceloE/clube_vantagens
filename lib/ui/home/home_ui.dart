import 'dart:convert';
import 'dart:developer';

import 'package:clube_vantagens/ui/categories/includes/grid_categories.dart';
import 'package:clube_vantagens/ui/home/search_ui.dart';
import 'package:clube_vantagens/widgets/drawer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class HomeUi extends StatefulWidget {
  HomeUi({Key? key}) : super(key: key);

  @override
  _HomeUiState createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  List instituitions = [];

  @override
  void initState() {
    super.initState();
    Dio()
        .get(
            'http://joao.esquilodigital.com.br/public/usuarios?email=${FirebaseAuth.instance.currentUser?.email}')
        .then((value) {
      setState(() {
        this.instituitions = value.data['instituitions'];
      });
      log('DRAWER ==> ' + value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Clube de vantagens', style: TextStyle(color: Colors.black),),
        backgroundColor: Color(0xfffeca57),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Get.to(SearchUi());
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<http.Response>(
                future: http.get(Uri.parse(
                    'http://joao.esquilodigital.com.br/public/empresas')),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider.builder(
                      itemCount: jsonDecode(snapshot.data!.body).length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        // log(snapshot.data.docs[index].data().toString());
                        List categorias = jsonDecode(snapshot.data!.body);
                        return CachedNetworkImage(
                          imageUrl: categorias[index]['foto'],
                          errorWidget: (_, __, ___) =>
                              Icon(Icons.error_outline),
                          fit: BoxFit.fill,
                        );
                      },
                      // itemBuilder: (_, index) {
                      //   // log(snapshot.data.docs[index].data().toString());
                      //   List categorias = jsonDecode(snapshot.data.body);
                      //   return CachedNetworkImage(
                      //     imageUrl: categorias[index]['foto'],
                      //     errorWidget: (_, __, ___) =>
                      //         Icon(Icons.error_outline),
                      //     fit: BoxFit.fill,
                      //   );
                      // },
                      options: CarouselOptions(
                        initialPage: 0,
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 3 / 2,
                        height: 280,
                      ),
                    );
                  }
                  return Container();
                },
              ),
              Container(
                child: Text(
                  'Categorias',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
                ),
                color: Color(0xfffeca57),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
              GridCategories(),
            ],
          ),
        ],
      ),
      drawer: DrawerWidget(instituitions: this.instituitions),
    );
  }
}
