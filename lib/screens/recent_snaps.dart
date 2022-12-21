import 'package:bitky/globals/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

class RecentSnapsScreen extends StatelessWidget {
   RecentSnapsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: kPrymaryColor,
        centerTitle: true,
        title: Text("Recent Snaps",style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                      'users/${authUser.currentUser!.uid}/recent_search').orderBy("createdAt",descending: true)
                  .snapshots(),
              builder: (ctx, recentSnapshot) {
                if (recentSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                final recentDocs = recentSnapshot.data!.docs;
                return FutureBuilder(
                  builder: (context, futureSnapshot) {
                    return ListView.builder(
                        itemCount: recentDocs.length,
                        itemBuilder: (context, index) {
                         // print(recentDocs[index]['uploadedImages'].toString());
                          var imagesJson = (recentDocs[index]['uploadedImages'] as List);
                          List<String> images =[];
                          imagesJson.forEach((element) {
                            images.add(element["url"]);
                          });
                       return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 190,
                              child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Reasons: ",
                                        style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text("${recentDocs[index]['problemName']
                                            [0].toString().toCapitalized()}, ${recentDocs[index]['problemName']
                                            [1].toString().toCapitalized()}, ${recentDocs[index]['problemName']
                                            [2].toString().toCapitalized()}.",style: GoogleFonts.sourceSansPro( fontWeight: FontWeight.w600) ),
                                          ),
                                        ],
                                      ),
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
                                            "Healthy: ",
                                            style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600),
                                          ),
                                          Image.asset(recentDocs[index]['isHealty'] == true?
                                          "images/smile.png":"images/sad.png", width: 15,height: 15, )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: kPrymaryColor,
                                      ),
                                       Text(
                                        "Uploads",
                                        style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: GridView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: images.length,
                                            gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1,
                                                crossAxisSpacing: 1,
                                                mainAxisSpacing: 1),
                                            itemBuilder: (ctx, index) {
                                              return Card(
                                                shadowColor: kPrymaryColor,
                                                elevation: 0.5,
                                                shape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10.0)),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: InkWell(
                                                      onTap: (){
                                                        final imageProvider = Image.network(images[index]).image;
                                                        showImageViewer(context, imageProvider, onViewerDismissed: () {
                                                          print("dismissed");
                                                        });
                                                      },
                                                      child: Image
                                                          .network(
                                                        images[index],
                                                        height:
                                                        20,
                                                        width:
                                                        20,
                                                        fit: BoxFit
                                                            .cover,
                                                      ),
                                                    )),
                                              );
                                            }),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                );
              }),
        ),
      ),
    );
  }


}
