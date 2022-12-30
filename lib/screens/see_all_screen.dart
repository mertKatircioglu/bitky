import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals/globals.dart';
import '../models/bitky_health_data_model.dart';

class SeeAllScreen extends StatelessWidget {
  List<String>? responseImages;
  HealthDataModel? diseases = HealthDataModel();
   SeeAllScreen({Key? key, this.responseImages, this.diseases}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: kPrymaryColor,
        centerTitle: true,
        title: Text("All Response",style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount:responseImages!.length,
            gridDelegate:
             SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.4),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (ctx, index) {
            //  print(diseases!.healthAssessment!.diseases![index].similarImages![0].similarity);
              return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: responseImages!.length,
                  duration:const Duration(milliseconds: 375) ,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Bounce(
                        duration: const Duration(milliseconds: 200),
                        onPressed: () {
                          final imageProvider = Image.network(responseImages![index]).image;
                          showImageViewer(context, imageProvider, onViewerDismissed: () {
                            print("dismissed");
                          });
                        },
                        child: Card(
                          shadowColor: kPrymaryColor,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15.0)),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(
                                      15),
                                  child: Container(
                                    decoration:  BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                                            image: NetworkImage(responseImages![index].toString()))
                                    ),

                                  )),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      diseases!.healthAssessment!.diseases![index].name.toString().toCapitalized(),
                                      textAlign: TextAlign.center,
                                      style:  GoogleFonts.sourceSansPro(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "Similarity: %${diseases!.healthAssessment!.diseases![index].similarImages![0].similarity.toString().substring(0,1)}0",
                                      textAlign: TextAlign.center,
                                      style:  GoogleFonts.sourceSansPro(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            }),
      ),
    );
  }
}
