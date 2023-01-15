import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/bitky_data_model.dart';

// ignore: must_be_immutable
class OpenBlogItemDetailScreen extends StatefulWidget {
  List? images;
  String? title;
  String? subTitle;
  String? description;
  String? author;
  String? date;
  String? category;
   OpenBlogItemDetailScreen({Key? key, this.images, this.date, this.author, this.title,this.description,this.category,this.subTitle}) : super(key: key);
  @override
  State<OpenBlogItemDetailScreen> createState() => _OpenBlogItemDetailScreenState();
}

class _OpenBlogItemDetailScreenState extends State<OpenBlogItemDetailScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Stack(
        children: [
        SizedBox(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            itemCount: widget.images!.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                      onTap: (){
                        final imageProvider = Image.network(widget.images![itemIndex]).image;
                        showImageViewer(context, imageProvider, onViewerDismissed: () {
                        });
                      },
                      child: Image.network(widget.images![itemIndex], fit: BoxFit.cover,)),
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
            padding: const EdgeInsets.only(left: 8.0, top: 50),
            child: SizedBox(
              height: 45,
              width: 45,
              child: Card(
                elevation: 4,
                color: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                    onPressed: (){
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
                child:ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title!.toCapitalized().toString(),
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
                                        Text("${AppLocalizations.of(context)!.category}: ", style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: kPrymaryColor,
                                            fontSize: 12
                                        ),),
                                        Text(widget.category!.toCapitalized().toString(),
                                          style: GoogleFonts.sourceSansPro( fontSize: 12),),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(widget.subTitle!,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600,color: Colors.grey, fontSize: 18),),
                          const Divider(height: 10, color: kPrymaryColor,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.author!,
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black
                                ),),
                              Text("${widget.date} ${AppLocalizations.of(context)!.daysago}",
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black
                                ),),
                            ],
                          ),
                          const SizedBox(height: 10,),

                          Text(widget.description!.toCapitalized().toString(),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.sourceSansPro( fontSize: 14),),
                          const SizedBox(height: 10,),

                          const Divider(height: 20, color: kPrymaryColor,),

                        ],
                      ),
                    )
                  ],
                ),

                    ),
              ),
            ),

        ],
      ),
    );
  }
}
