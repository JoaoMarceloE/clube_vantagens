import 'dart:convert';
import 'dart:developer';

import 'package:clube_vantagens/widgets/cards/card_with_list.dart';
import 'package:clube_vantagens/ui/companies/company_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CategoriesDetailsUi extends StatefulWidget {
  final Map<String, dynamic> data; // a categoria

  CategoriesDetailsUi(this.data);

  @override
  _CategoriesDetailsUiState createState() => _CategoriesDetailsUiState();
}

class _CategoriesDetailsUiState extends State<CategoriesDetailsUi> {
  List<Map<String, dynamic>>? sponsorers;

  Key key = Key('carrousel');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Anunciantes',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xfffeca57),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<http.Response>(
                  future: http.get(Uri.parse(
                      'http://joao.esquilodigital.com.br/public/categorias/${this.widget.data['id']}/subcategorias')),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return error();
                    }
                    // Once complete, show your application
                    if (snapshot.hasData) {
                      var subs = jsonDecode(snapshot.data!.body);

                      print(snapshot.data);
                      return CarouselSlider.builder(
                        itemCount: subs['banners'].length,
                        itemBuilder: (_, index, realIndex) {
                          if (subs['banners'].length > 0) {
                            return InkWell(
                              onTap: () {
                                if (subs['banners'].length > 0)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyUi(subs['banners'][index]),
                                    ),
                                  );
                              },
                              child: CachedNetworkImage(
                                imageUrl: subs['banners'][index],
                                errorWidget: (_, __, ___) =>
                                    Icon(Icons.error_outline),
                                fit: BoxFit.fill,
                              ),
                            );
                          }
                          return Container(
                            child: Center(
                              child: Text('Nenhuma empresa cadastrada'),
                            ),
                          );
                        },
                        key: key,
                        options: CarouselOptions(
                          initialPage: 0,
                          autoPlay: true,
                          viewportFraction: 1,
                          aspectRatio: 3 / 2,
                          height: 280,
                        ),
                      );
                      // return provList();
                    }
                    // Otherwise, show something whilst waiting for initialization to complete
                    return loading();
                  },
                ),

                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  child: Text(
                    widget.data['nome'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  color: Color(0xfffeca57),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),

                FutureBuilder<http.Response>(
                  future: http.get(Uri.parse(
                      'http://joao.esquilodigital.com.br/public/categorias/${this.widget.data['id']}/subcategorias')),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return error();
                    }
                    // Once complete, show your application
                    if (snapshot.hasData) {
                      var subs = jsonDecode(snapshot.data!.body);

                      print(snapshot.data);
                      return Column(
                        children: List.generate(
                          subs['resposta'].length,
                          (index) => CardWithList(
                            listItems: subs['resposta'][index]['empresas'],
                            title: subs['resposta'][index]['nome'],
                          ),
                        ),
                      );
                      // return provList();
                    }
                    // Otherwise, show something whilst waiting for initialization to complete
                    return loading();
                  },
                ),
                // gera os items de sub categoria e seus filhos
              ],
            )
          ],
        ));
    // FutureBuilder<http.Response>(
    //   future: http.get(
    //       'http://joao.esquilodigital.com.br/public/categorias/${this.data['id']}/subcategorias'),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       print(snapshot.error);
    //       return error();
    //     }
    //     // Once complete, show your application
    //     if (snapshot.hasData) {
    //       print(snapshot.data);
    //       return subCategoryList(jsonDecode(snapshot.data.body));
    //       // return provList();
    //     }
    //     // Otherwise, show something whilst waiting for initialization to complete
    //     return loading();
    //   },
    // ),
  }

  Widget error() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
          ),
          Text(
            'Nenhuma empresa cadastrada',
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget subCategoryList(subs, context) {
    print("item: ${subs[0]}");
    return ListView(
      children: [
        CarouselSlider.builder(
          itemCount: subs['banners'].length,
          itemBuilder: (_, index, realIndex) {
            if (subs['banners'].length > 0) {
              return InkWell(
                onTap: () {
                  if (subs['banners'].length > 0)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyUi(subs['banners'][index]),
                      ),
                    );
                },
                child: CachedNetworkImage(
                  imageUrl: subs['banners'][index],
                  errorWidget: (_, __, ___) => Icon(Icons.error_outline),
                  fit: BoxFit.fill,
                ),
              );
            }
            return Container(
              child: Center(
                child: Text('Nenhuma empresa cadastrada'),
              ),
            );
          },
          key: key,
          options: CarouselOptions(
            initialPage: 0,
            autoPlay: true,
            viewportFraction: 1,
            aspectRatio: 3 / 2,
            height: 280,
          ),
        ),
        // SizedBox(
        //   height: 10,
        // ),
        Container(
          child: Text(
            widget.data['nome'],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
        // gera os items de sub categoria e seus filhos
        Column(
          children: List.generate(
            subs['resposta'].length,
            (index) => CardWithList(
              listItems: subs['resposta'][index]['empresas'],
              title: subs['resposta'][index]['nome'],
            ),
          ),
        ),
      ],
    );
  }

  Widget loading() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CircularProgressIndicator(),
          Text('Carregando dados...'),
        ],
      ),
    );
  }
}
