import 'dart:convert';

import 'package:clube_vantagens/ui/categories/details/categories_details_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class GridCategories extends StatelessWidget {
  List<Color> categories = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.cyan,
    Colors.deepOrange,
    Colors.pink
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: http.get(
          Uri.parse('http://joao.esquilodigital.com.br/public/categorias')),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return error();
        }
        // Once complete, show your application
        if (snapshot.hasData) {
          print(snapshot);
          // return Text(jsonDecode(snapshot.data.body).toString());
          return categoryListCustom(jsonDecode(snapshot.data!.body), context);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading();
      },
    );
  }

  Widget error() {
    return Container(
      alignment: Alignment.center,
      child: Text('Ocorreu um erro, tente novamente'),
    );
  }

  Widget categoryListCustom(snap, context) {
    List<dynamic> list = [];

    do {
      if (snap.length >= 2) {
        list.add(snap.sublist(0, 2));
        snap.removeRange(0, 2);
      } else {
        list.add(snap.sublist(0));
        snap.clear();
      }
    } while (snap.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        list.length,
        (i) {
          return Row(
            children: List.generate(
              list[i].length,
              (j) {
                Map<String, dynamic> cat = list[i][j];
                return Expanded(
                  child: Container(
                    height: 80,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      color: Colors.white, // background color
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesDetailsUi(cat),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                cat['nome'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget categoryList(snap, context) {
    // print(snap[0].data()['subcategories'][0]['companies'][0]);
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      // physics: new NeverScrollableScrollPhysics(),
      childAspectRatio: 10 / 4,
      children: List.generate(snap.length, (index) {
        int nextColor = index;
        Map<String, dynamic> cat = snap[index].data();
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          color: Colors.grey[400], // background color
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoriesDetailsUi(cat),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    cat['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                )
              ],
            ),
          ),
        );
      }),
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
          Text('Inicializando configurações...'),
        ],
      ),
    );
  }
}
