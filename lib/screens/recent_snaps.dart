import 'package:bitky/globals/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class RecentSnapsScreen extends StatelessWidget {
   RecentSnapsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: kPrymaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                      'users/${authUser.currentUser!.uid}/recent_search')
                  .snapshots(),
              builder: (ctx, recentSnapshot) {
                if (recentSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                final recentDocs = recentSnapshot.data!.docs;
               // print(recentDocs[0]['uploadedImages'].toString());
                var imagesJson = (recentDocs[0]['uploadedImages'] as List);
                List<String> images =[];
                imagesJson.forEach((element) {
               images.add(element["url"]);
                });
                return FutureBuilder(
                  builder: (context, futureSnapshot) {
                    return ListView.builder(
                        itemCount: recentDocs.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 180,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Date: ",
                                              style:
                                              TextStyle(color: kPrymaryColor),
                                            ),
                                            Text((recentDocs[index]['createdAt']
                                                    as Timestamp)
                                                .toDate()
                                                .day
                                                .toString()),
                                            const Text("-"),
                                            Text((recentDocs[index]['createdAt']
                                                    as Timestamp)
                                                .toDate()
                                                .month
                                                .toString()),
                                            const Text("-"),
                                            Text((recentDocs[index]['createdAt']
                                                    as Timestamp)
                                                .toDate()
                                                .year
                                                .toString()),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              "Hour: ",
                                              style:
                                              TextStyle(color: kPrymaryColor),
                                            ),
                                            Text((recentDocs[index]['createdAt']
                                                    as Timestamp)
                                                .toDate()
                                                .day
                                                .toString()),
                                            Text(":"),
                                            Text((recentDocs[index]['createdAt']
                                                    as Timestamp)
                                                .toDate()
                                                .second
                                                .toString()),
                                          ],
                                        ),
                                        const Divider(
                                          height: 2,
                                          color: kPrymaryColor,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Reasons: ",
                                              style:
                                                  TextStyle(color: kPrymaryColor),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text((recentDocs[index]['problemName']
                                                    [0].toUpperCase())+","),
                                                Text((recentDocs[index]['problemName']
                                                [1].toUpperCase())+","),
                                                Text((recentDocs[index]['problemName']
                                                [2].toUpperCase())),
                                              ],
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "Uploads: ",
                                          style:
                                          TextStyle(color: kPrymaryColor),
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
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10),
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
                                                       // _scaleDialog(_dialog(context,images[index]), context);

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

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ));
                  },
                );
              }),
        ),
      ),
    );
  }
}
