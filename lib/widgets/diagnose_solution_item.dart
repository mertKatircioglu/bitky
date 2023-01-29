import 'package:bitky/globals/globals.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/bitky_health_data_model.dart';

class DiagnoseSolutionItemWidget extends StatefulWidget {
  String? imgUrl;
  String? title;
  List<String>? biological;
  List<String>? prevention;
  DiagnoseSolutionItemWidget({Key? key, this.imgUrl, this.title, this.biological, this.prevention}) : super(key: key);

  @override
  State<DiagnoseSolutionItemWidget> createState() => _DiagnoseSolutionItemWidgetState();
}

class _DiagnoseSolutionItemWidgetState extends State<DiagnoseSolutionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration:   BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
              image: AssetImage('images/bt_banner.png'),alignment: Alignment.bottomCenter),
          ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                final imageProvider = Image.network(widget.imgUrl.toString()).image;
                showImageViewer(context, imageProvider, onViewerDismissed: () {
                  print("dismissed");
                });
              },
              child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                      15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.imgUrl.toString()))
                    ),

                  )),
            ),
            const SizedBox(height: 30,),
            Column(
              children: [
                Text("Problem", style: GoogleFonts.sourceSansPro(
                  color: kPrymaryColor,
                  shadows: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 2), // changes position of shadow
                    )
                  ]
                )),
                Text(widget.title.toString().toCapitalized(),textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro()),
              ],
            ),
            const SizedBox(height: 5,),
            Column(
              children: [
                Text("Solution", style: GoogleFonts.sourceSansPro(color: kPrymaryColor,shadows: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
                  )
                ])),
                Text(widget.biological![0].toString().toCapitalized(),textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro(
                )),
              ],
            ),
            const SizedBox(height: 5,),
            Column(
              children: [
                Text("Prevention", style: GoogleFonts.sourceSansPro(
                  color: kPrymaryColor,
                  shadows: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(0, 2), // changes position of shadow
                    )
                  ]
                )),
                Text(widget.prevention![0].toString().toCapitalized(),textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro()),
              ],
            ),
            const SizedBox(height: 100,),

          ],
        ),
      ),
    );
  }
}
