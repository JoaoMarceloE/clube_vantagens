import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CupomUi extends StatelessWidget {
  final String title;
  final String description;
  final List<String> carouselMenu = [
    'Anuncie aqui',
    'Programa de indicação',
    'Lugares. Comércio. Experiências.',
    'Cupons e Descontos',
    'Diversas instituições beneficiadas'
  ];

  CupomUi({
    Key? key,
    this.title = '',
    this.description = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.black),),
        backgroundColor: Color(0xfffeca57),
        iconTheme: IconThemeData(color: Colors.black),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // CarouselSlider.builder(
            //   itemBuilder: (_, index, realIndex) => GestureDetector(
            //     onTap: () {
            //       print('toque');
            //     },
            //     child: Container(
            //       width: MediaQuery.of(context).size.width - 50,
            //       margin: EdgeInsets.symmetric(horizontal: 10),
            //       padding: EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(15),
            //         ),
            //         color: Colors.black,
            //       ),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             this.carouselMenu[index],
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 17,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            //   options: CarouselOptions(
            //     height: 150,
            //     initialPage: 0,
            //     autoPlay: true,
            //     // viewportFraction: 0.7,
            //   ),
            //   itemCount: this.carouselMenu.length,
            // ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
