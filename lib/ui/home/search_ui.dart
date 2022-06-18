import 'dart:convert';

import 'package:clube_vantagens/ui/companies/company_ui.dart';
import 'package:clube_vantagens/widgets/cards/widget_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchUi extends StatefulWidget {
  @override
  _SearchUiState createState() => _SearchUiState();
}

class _SearchUiState extends State<SearchUi> {
  TextEditingController textController = TextEditingController();
  List listItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffeca57),
        title: WidgetTextFormField(
          textController: textController,
          hintText: 'Digite sua busca',
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              if (textController.text.isNotEmpty)
                await search();
              else
                Get.snackbar(
                  'Nada digitado',
                  '',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List<Widget>.generate(
            this.listItems.length,
            (index) => itemCard(listItems[index]),
          ).toList(),
        ),
      ),
    );
  }

  search() async {
    http.Response response = await http.get(Uri.parse(
        'http://joao.esquilodigital.com.br/public/empresas/consulta/${textController.text}'));

    setState(() {
      listItems = jsonDecode(response.body);

      if (listItems.length == 0)
        Get.snackbar(
          'Nenhum item encontrado',
          '',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
    });
  }

  Widget itemCard(item) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (item['pago'] == 1 && item['foto'] != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CompanyUi(item)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CachedNetworkImage(
                  imageUrl: item['foto'] ?? '',
                  errorWidget: (_, __, ___) =>
                      Icon(Icons.image_not_supported_sharp),
                  width: 70,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nome'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      child: Text(
                        item['resumo'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Icon(Icons.info_outline)
            ],
          ),
        ),
      ),
    );
  }
}
