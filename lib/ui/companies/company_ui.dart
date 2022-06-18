import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:url_launcher/url_launcher.dart';


class CompanyUi extends StatefulWidget {
  CompanyUi(this.data);

  final Map<String, dynamic> data;

  @override
  _CompanyUiState createState() => _CompanyUiState();
}

class _CompanyUiState extends State<CompanyUi> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data['nome'] ?? '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfffeca57),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PinchZoomImage(
              zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
              image: CachedNetworkImage(
                imageUrl: widget.data['foto'] ?? '',
                errorWidget: (context, url, error) => Icon(
                  Icons.error_outline,
                  size: 80,
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                fit: BoxFit.fill,
                // height: 420,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.data['beneficiario'] ?? '',
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      size: 20,
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    fit: BoxFit.fitWidth,
                    height: 25,
                  ),
                ],
              ),
            ),
            //========== ABOUT =================================
            itemTitle(title: 'Quem Somos'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.data['descricao'] ?? ''),
            ),
            //=============== END ABOUT ====================

            //==================== BENEFITED ===========================
            SizedBox(
              height: 10,
            ),
            itemTitle(title: 'Benefícios, Cupons de desconto'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.data['descontos'] ?? 'Nenhum beneficio existente',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            //====================  END BENEFITED ===========================

            //====================== GOOGLE MAPS ============================
            itemTitle(title: 'Localização'),
            widget.data['localizacao'] != null
                ? Container(
                    height: 500,
                    child:  WebView(
                      // initialUrl: 'https://goo.gl/maps/sUNih5JAf1CtGeJ26',
                      initialUrl: 'https://www.google.com/maps/@${widget.data['localizacao'].split(',')[0]},${widget.data['localizacao'].split(',')[1]},15z',
                      javascriptMode: JavascriptMode.unrestricted,

                    )
                    // GoogleMap(
                    //   myLocationEnabled: true,
                    //   initialCameraPosition: CameraPosition(
                    //     target: LatLng(
                    //       // -29.9126708,-51.1689972
                    //       double.parse(
                    //         widget.data['localizacao'].split(',')[0],
                    //       ),
                    //       double.parse(
                    //         widget.data['localizacao'].split(',')[1],
                    //       ),
                    //     ), // todo: pegar a localização do usuário
                    //     zoom: 15,
                    //   ),
                    //   zoomControlsEnabled: true,
                    //   mapToolbarEnabled: true,
                    //   markers: <Marker>[
                    //     Marker(
                    //       markerId: MarkerId('markers'),
                    //       position: LatLng(
                    //         double.parse(
                    //             widget.data['localizacao'].split(',')[0]),
                    //         double.parse(
                    //             widget.data['localizacao'].split(',')[1]),
                    //       ),
                    //     ),
                    //   ].toSet(),
                    // ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Localização não informada'),
                  ),

            //======================= END GOOGLE MAPS =======================

            //================= REDE SOCIAL ===========================
            SizedBox(
              height: 10,
            ),
            itemTitle(title: 'Contatos e Mídias Sociais'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.data['site'] != null,
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(widget.data['site'])) {
                            await launch(widget.data['site']);
                          }
                        },
                        child: Image.asset(
                          'assets/site.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.data['instagram'] != null,
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(widget.data['instagram'])) {
                            await launch(widget.data['instagram']);
                          }
                        },
                        child: Image.asset(
                          'assets/instagram.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.data['facebook'] != null,
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(widget.data['facebook'])) {
                            await launch(widget.data['facebook']);
                          }
                        },
                        child: Image.asset(
                          'assets/facebook.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.data['whatsapp'] != null,
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(widget.data['whatsapp'])) {
                            await launch(widget.data['whatsapp']);
                          }
                        },
                        child: Image.asset(
                          'assets/whatsapp.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.data['telefone'] != null,
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(widget.data['telefone'])) {
                            // await launch(data['telefone']);
                            await launch(widget.data['telefone']);
                          }
                        },
                        child: Image.asset(
                          'assets/telefone.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.data['email'] != null,
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (await canLaunch(widget.data['email'])) {
                            await launch(widget.data['email']);
                          }
                        },
                        child: Image.asset(
                          'assets/email.jpeg',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //=================== END REDE SOCIAL =======================
          ],
        ),
      ),
    );
  }

  Widget itemTitle({required String title}) {
    return Container(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    );
  }
}
