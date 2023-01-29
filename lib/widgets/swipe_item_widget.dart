import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class ExampleCard extends StatelessWidget {
  String? title;
  String? subTile;
  String? dateTame;
  String? imgUrl;
  String? descrip;
  String? user;
  String? approveCount;

  ExampleCard(
      {Key? key,
      this.title,
      this.dateTame,
      this.imgUrl,
      this.subTile,
      this.user,
        this.approveCount,
      this.descrip})
      : super(key: key);

  ScrollController scrollController = ScrollController();

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
                      Stack(children: [

                        ClipRRect(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height/1.6,
                            fit: BoxFit.cover,
                            imageUrl: imgUrl!,
                            placeholder: (context, url) =>
                            const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 1),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),

                                color: Colors.black54,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children:  [
                                  const Icon(Icons.label_important_outline_sharp,size: 24, color: kPrymaryColor,),
                                  Text(title!, style:GoogleFonts.sourceSansPro(fontSize: 18,fontWeight: FontWeight.w600, color: Colors.white) ,),
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children:  [
                                  const Icon(Icons.done,size: 24, color: kPrymaryColor,),
                                  Text("${approveCount!} ${AppLocalizations.of(context)!.approved}", style:GoogleFonts.sourceSansPro(fontStyle: FontStyle.italic, color: Colors.white) ,),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],),

                     const Icon(Icons.arrow_drop_down, color: kPrymaryColor, size: 36,)
                    ],
                  ),
                ),
                expanded: Column(children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                  image: NetworkImage(imgUrl!),
                                  fit: BoxFit.cover)),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                color: Colors.black54,
                              ),
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children:  [
                                  const Icon(Icons.label,size: 14, color: kPrymaryColor,),
                                  Text(title!, style:GoogleFonts.sourceSansPro(fontSize: 12,fontWeight: FontWeight.w600, color: Colors.white) ,),
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                              ),
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children:  [
                                  const Icon(Icons.done,size: 9, color: kPrymaryColor,),
                                  Text("${approveCount} ${AppLocalizations.of(context)!.approved}", style:GoogleFonts.sourceSansPro(fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                      color: Colors.white) ,),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],),



                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          subTile.toString(),
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 16
                          )),
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
                                  descrip.toString(),
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.sourceSansPro(

                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(height: 5, color: kPrymaryColor, thickness: 0.1,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person, color: kPrymaryColor, size: 12,),
                                Text(
                                  user!,
                                  style: GoogleFonts.sourceSansPro(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${dateTame!} ${AppLocalizations.of(context)!.daysago}",
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
                    child: const Icon(Icons.arrow_drop_up, color: kPrymaryColor, size: 36,),
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
