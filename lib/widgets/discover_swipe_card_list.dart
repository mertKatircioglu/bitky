import 'package:bitky/widgets/swipe_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals/globals.dart';
import '../l10n/app_localizations.dart';

class DiscoverSwipteCardList extends StatefulWidget {
  const DiscoverSwipteCardList({Key? key}) : super(key: key);

  @override
  State<DiscoverSwipteCardList> createState() => _DiscoverSwipteCardListState();
}

class _DiscoverSwipteCardListState extends State<DiscoverSwipteCardList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
          'discover')
          .snapshots(),
      builder: (ctx, recentSnapshot) {
        if (recentSnapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator(
            color: Colors.transparent,
          );
        } else if (recentSnapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "No Data",
                    style: GoogleFonts.sourceSansPro(),
                  ),
                ],
              ),
            ),
          );
        }
        final recentDocs = recentSnapshot.data!.docs;

        return FutureBuilder(
          builder: (ctx, futureSnap) {
            return ListView.builder(
                itemCount: recentDocs.length,
                itemBuilder: (context, index) {

                  return DiscoverSwipeCard(
                    title: recentDocs[index]["title"],
                    subTile: recentDocs[index]["subtitle"],
                    imgUrl: recentDocs[index]["imgUrl"],
                    dateTame: "16.01.1989",
                  );
                });
          },
        );
      },
    );
  }
}
