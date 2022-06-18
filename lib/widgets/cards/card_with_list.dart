import 'package:clube_vantagens/ui/companies/company_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class CardWithList extends StatelessWidget {
  final List listItems;
  final String title;

  const CardWithList({
    Key? key,
    required this.listItems,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cardComplete(context);
  }

  Widget cardComplete(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        itemTitle(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List<Widget>.generate(
            this.listItems.length,
            (index) => itemCard(listItems[index], context),
          ).toList(),
        ),
        Divider(
          color: Colors.white,
          height: 5,
        )
      ],
    );
  }

  Widget itemTitle() {
    return Container(
      child: Text(
        this.title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    );
  }

  Widget itemCard(item, context) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {
          if (item['pago'] == 1 && item['foto'] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyUi(item),
              ),
            );
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
