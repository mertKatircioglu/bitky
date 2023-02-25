import 'dart:async';

import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/widgets/swipecard_map_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DiscoverSwipeCard extends StatefulWidget {
  String? title;
  String? subTile;
  String? dateTame;
  String? imgUrl;
  String? descrip;
  String? user;
  String? userAvatarUrl;
  double? lat;
  double? long;
  String? approveCount;
  int? iD;

  DiscoverSwipeCard(
      {Key? key,
      this.title,
      this.dateTame,
      this.imgUrl,
      this.userAvatarUrl,
      this.iD,
      this.lat,
      this.long,
      this.subTile,
      this.user,
      this.approveCount,
      this.descrip})
      : super(key: key);

  @override
  State<DiscoverSwipeCard> createState() => _DiscoverSwipeCardState();
}

class _DiscoverSwipeCardState extends State<DiscoverSwipeCard> {
  ScrollController scrollController = ScrollController();

  Widget _dialog(BuildContext context, double lat, double long){
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      content: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(20))),
          child:  SwipeCardMapWdiget(long: long, lat: lat),
        ),
      ),

    );
  }

  void _scaleDialog(Widget dialog) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "go",
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child:dialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: CupertinoColors.white,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ExpandableNotifier(
        child: Column(
          children: [
            Expandable(
                collapsed: ExpandableButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            child: CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.6,
                              fit: BoxFit.cover,
                              imageUrl: widget.imgUrl!,
                              placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 1),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.label_important_outline_sharp,
                                      size: 24,
                                      color: kPrymaryColor,
                                    ),
                                    Text(
                                      widget.title!.toCapitalized(),
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.done,
                                      size: 24,
                                      color: kPrymaryColor,
                                    ),
                                    Text(
                                      "${widget.approveCount!} ${AppLocalizations.of(context)!.approved}",
                                      style: GoogleFonts.sourceSansPro(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_drop_up,
                        color: kPrymaryColor,
                        size: 20,
                      )
                    ],
                  ),
                ),
                expanded: Column(children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.label,
                                      size: 14,
                                      color: kPrymaryColor,
                                    ),
                                    Text(
                                      widget.title!,
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.done,
                                      size: 9,
                                      color: kPrymaryColor,
                                    ),
                                    Text(
                                      "${widget.approveCount} ${AppLocalizations.of(context)!.approved}",
                                      style: GoogleFonts.sourceSansPro(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      ClipRRect(
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 6,
                          fit: BoxFit.cover,
                          imageUrl: widget.imgUrl!,
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fadeOutDuration: const Duration(seconds: 1),
                          fadeInDuration: const Duration(seconds: 1),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(widget.subTile.toString().toCapitalized(),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: CupertinoScrollbar(
                            thumbVisibility: true,
                            controller: scrollController,
                            thickness: 8,
                            child: ListView(
                              controller: scrollController,
                              padding: const EdgeInsets.all(2),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                Text(
                                  widget.descrip.toString(),
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.sourceSansPro(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Visibility(
                                  visible: widget.lat! == 1.1 ? false : true,
                                  child: InkWell(
                                    onTap: (){
                                      _scaleDialog(_dialog(context, widget.lat!, widget.long!));
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(3.0),
                                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.black87)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset('images/map.png', width: 25, height: 25,),
                                            const SizedBox(width: 5,),
                                            Text("Konum Göster",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.sourceSansPro(fontSize: 14, fontWeight: FontWeight.w600)),
                                          ],
                                        )),
                                  ),
                                ),


                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(
                          height: 5,
                          color: kPrymaryColor,
                          thickness: 0.1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.cover,
                                      imageUrl: widget.userAvatarUrl!,
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fadeOutDuration:
                                          const Duration(seconds: 1),
                                      fadeInDuration:
                                          const Duration(seconds: 1),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.user!,
                                  style: GoogleFonts.sourceSansPro(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            Text(
                              "${widget.dateTame!} ${AppLocalizations.of(context)!.daysago}",
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  ExpandableButton(
                    // <-- Collapses when tapped on
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: kPrymaryColor,
                      size: 20,
                    ),
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}

class MyClip extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 100, 100, 100);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
