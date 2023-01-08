import 'package:bitky/globals/globals.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/bitky_data_model.dart';

class IdentifyResultScreen extends StatefulWidget {
  BitkyDataModel? dataModel;
   IdentifyResultScreen({Key? key, this.dataModel}) : super(key: key);
  @override
  State<IdentifyResultScreen> createState() => _IdentifyResultScreenState();
}

class _IdentifyResultScreenState extends State<IdentifyResultScreen> {
  List<String>? images=[];


  @override
  Widget build(BuildContext context) {
    widget.dataModel!.suggestions![0].plantDetails!.wikiImages!.forEach((element) {
      images!.add(element.value!);
    });
    print(images.toString());
    return Scaffold(
      body:Stack(
        children: [
        SizedBox(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            itemCount: images!.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                      onTap: (){
                        final imageProvider = Image.network(images![itemIndex]).image;
                        showImageViewer(context, imageProvider, onViewerDismissed: () {
                        });
                      },
                      child: Image.network(images![itemIndex], fit: BoxFit.cover,)),
                ),
            options: CarouselOptions(
              height: 400,
              pauseAutoPlayOnManualNavigate: true,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 1500),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.0,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 30),
            child: SizedBox(
              height: 35,
              width: 35,
              child: Card(
                color: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                    onPressed: (){
                      images!.clear();
                    Navigator.pop(context);
                    }, icon: const Icon(Icons.arrow_back, size: 25, color: kPrymaryColor,)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.7,
              decoration:const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.dataModel!.suggestions!.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.dataModel!.suggestions![index].plantDetails!.commonNames![0].toCapitalized().toString(),
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, fontSize: 22),),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.greenAccent[100]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Scientific Names: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                          fontSize: 12
                                          ),),
                                          Text(widget.dataModel!.suggestions![index].plantDetails!.scientificName!.toCapitalized().toString(),
                                            style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text("Description",
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w500, fontSize: 20),),
                            Text(widget.dataModel!.suggestions![index].plantDetails!.wikiDescription!.value!.toCapitalized().toString(),
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.sourceSansPro( fontSize: 14),),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.greenAccent[100]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Taxonomy", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                      fontSize: 16
                                      ),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Kingdom: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                              fontSize: 12
                                          ),),
                                          Text(widget.dataModel!.suggestions![index].plantDetails!.taxonomy!.kingdom!.toCapitalized().toString(),
                                            style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Phylum: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                              fontSize: 12
                                          ),),
                                          Text(widget.dataModel!.suggestions![index].plantDetails!.taxonomy!.phylum!.toCapitalized().toString(),
                                            style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Class: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                              fontSize: 12
                                          ),),
                                          Text(widget.dataModel!.suggestions![index].plantDetails!.taxonomy!.clasS!.toCapitalized().toString(),
                                            style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Order: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                              fontSize: 12
                                          ),),
                                          Text(widget.dataModel!.suggestions![index].plantDetails!.taxonomy!.order!.toCapitalized().toString(),
                                            style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Family: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                              fontSize: 12
                                          ),),
                                          Text(widget.dataModel!.suggestions![index].plantDetails!.taxonomy!.family!.toCapitalized().toString(),
                                            style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Genus: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                              fontSize: 12
                                          ),),
                                          Text(widget.dataModel!.suggestions![index].plantDetails!.taxonomy!.genus!.toCapitalized().toString(),
                                            style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 20, color: kPrymaryColor,)
                          ],
                        ),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
