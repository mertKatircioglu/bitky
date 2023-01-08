import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/globals/globals.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../restart_app.dart';

class FlowItem extends StatefulWidget {
  const FlowItem({Key? key}) : super(key: key);

  @override
  State<FlowItem> createState() => _FlowItemState();
}

class _FlowItemState extends State<FlowItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFA5EFB0),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(3.0, 2.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  Text(
                    'Flow',
                    style: GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                ],
              ),
              const SizedBox(
                height: 40,
              ),
              isLoading == true
                  ?    Center(
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CupertinoActivityIndicator(color: kPrymaryColor,),
                        WavyAnimatedTextKit(
                          textStyle: GoogleFonts.sourceSansPro(
                              fontSize: 18,
                              color: kPrymaryColor
                          ),
                          text: const [
                            "Please wait..."
                          ],
                          isRepeatingAnimation: true,
                          speed: const Duration(milliseconds: 150),
                        ),
                      ],
                    ),
                  )
              ):StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(
                      'blog').orderBy("createdAt",descending: true)
                      .snapshots(),
                  builder: (ctx, recentSnapshot) {
                    if (recentSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    final recentDocs = recentSnapshot.data!.docs;
                    return Expanded(
                      child: FutureBuilder(
                        builder: (context, futureSnapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                              itemCount: recentDocs.length,
                              itemBuilder: (context, index) {
                                // print(recentDocs[index]['uploadedImages'].toString());
                                var imagesJson = (recentDocs[index]['images'] as List);
                                List<String> images =[];
                                imagesJson.forEach((element) {
                                  images.add(element);
                                });
                                return Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: SizedBox(
                                    height: 520,
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                              child: Container(
                                                height: 200,
                                                width: MediaQuery.of(context).size.width,
                                                child: CarouselSlider.builder(
                                                  itemCount: images.length,
                                                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                                      ClipRRect(
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),

                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          child: InkWell(
                                                              onTap: (){
                                                                final imageProvider = Image.network(images[itemIndex]).image;
                                                                showImageViewer(context, imageProvider, onViewerDismissed: () {
                                                                });
                                                              },
                                                              child: Image.network(images[itemIndex], fit: BoxFit.cover,)),
                                                        ),
                                                      ),
                                                  options: CarouselOptions(
                                                    height: 200,
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
                                                    enlargeFactor: 1.0,
                                                    scrollDirection: Axis.horizontal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [       Text("${recentDocs[index]['title']}",style: GoogleFonts.sourceSansPro(fontSize: 22, fontWeight: FontWeight.w600) ),
                                                  Text("${recentDocs[index]['subTitle']}",style: GoogleFonts.sourceSansPro( fontWeight: FontWeight.w600, color: Colors.grey) ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Divider(
                                                    height: 2,
                                                    color: kPrymaryColor,
                                                  ),
                                                  Text("${recentDocs[index]['description']}",style: GoogleFonts.sourceSansPro()),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Divider(
                                                    height: 2,
                                                    color: kPrymaryColor,
                                                  ),
                                                  Row(

                                                    children: [
                                                      Text(
                                                        "Author: ",
                                                        style: GoogleFonts.sourceSansPro(color: kPrymaryColor,fontSize: 10, fontWeight: FontWeight.w600),
                                                      ),
                                                      Text("${recentDocs[index]['author']}",style: GoogleFonts.sourceSansPro()),

                                                      Text(
                                                        "Date: ",
                                                        style: GoogleFonts.sourceSansPro(color: kPrymaryColor,fontSize: 10, fontWeight: FontWeight.w600),
                                                      ),
                                                      Text((recentDocs[index]['createdAt']
                                                      as Timestamp)
                                                          .toDate()
                                                          .day
                                                          .toString(),style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600,fontSize: 10,)),
                                                      const Text("-", style: TextStyle(fontSize: 10),),
                                                      Text((recentDocs[index]['createdAt']
                                                      as Timestamp)
                                                          .toDate()
                                                          .month
                                                          .toString(),style: GoogleFonts.sourceSansPro( fontWeight: FontWeight.w600,fontSize: 10,)),
                                                      const Text("-", style: TextStyle(fontSize: 10)),
                                                      Text((recentDocs[index]['createdAt']
                                                      as Timestamp)
                                                          .toDate()
                                                          .year
                                                          .toString(),style: GoogleFonts.sourceSansPro( fontWeight: FontWeight.w600,fontSize: 10,)),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Hour: ",
                                                        style: GoogleFonts.sourceSansPro(color: kPrymaryColor,fontSize: 10, fontWeight: FontWeight.w600),
                                                      ),
                                                      Text((recentDocs[index]['createdAt']
                                                      as Timestamp)
                                                          .toDate()
                                                          .day
                                                          .toString(),style: GoogleFonts.sourceSansPro( fontWeight: FontWeight.w600,fontSize: 10,)),
                                                      const Text(":", style: TextStyle(fontSize: 10)),
                                                      Text((recentDocs[index]['createdAt']
                                                      as Timestamp)
                                                          .toDate()
                                                          .second
                                                          .toString(),style: GoogleFonts.sourceSansPro( fontWeight: FontWeight.w600,fontSize: 10,)),
                                                    ],
                                                  ),],
                                              ),
                                            ),
                                            const SizedBox(height: 10,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
