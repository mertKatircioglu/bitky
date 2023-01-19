import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:bitky/widgets/swipe_item_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../l10n/app_localizations.dart';
import '../screens/open_blog_item.dart';

class DiscoverItemScreen extends StatefulWidget {
  const DiscoverItemScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverItemScreen> createState() => _DiscoverItemScreenState();
}

class _DiscoverItemScreenState extends State<DiscoverItemScreen> {
  final AppinioSwiperController controller = AppinioSwiperController();

  bool isLoading = false;
  List<ExampleCard> cards = [];
  bool? isOkey;
  bool showOkey= false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('discover')
        .snapshots()
        .listen((event) {
      final data = event.docs;
      for (var doc in data) {
        var date = DateTime.now().day - DateTime.parse(doc.data()["createDate"].toDate().toString()).day;

        cards.add(ExampleCard(
          title: doc.data()["title"],
          subTile: doc.data()["subtitle"],
          dateTame: date.toString(),
          imgUrl: doc.data()["imgUrl"],
          descrip: doc.data()["description"],
          user: doc.data()["user"],
        ));
      }
      setState(() {});
    });
  }


  void _swipe(int index, AppinioSwiperDirection direction) {
    if(direction == AppinioSwiperDirection.right){
      showDialog(context: context, builder: (c){
        Future.delayed(const Duration(milliseconds: 1450), () {
          Navigator.of(context, rootNavigator: true).pop("Discard");
        });
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          content: Container(
            color: Colors.transparent,
              height: 80,
              width: 80,
              child: Lottie.asset("images/done.json", repeat: false)),
        );
      });

    }else if(direction == AppinioSwiperDirection.left){
      showDialog(context: context, builder: (c){
        Future.delayed(const Duration(milliseconds: 1450), () {
          Navigator.of(context, rootNavigator: true).pop("Discard");
        });
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          content: Container(
              color: Colors.transparent,
              height: 80,
              width: 80,
              child: Lottie.asset("images/cancel.json", repeat: false)),
        );
      });
    }
    log("the card was swiped to the: ${direction.name}");
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      setState(() {
        showOkey = false;
      });
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        body:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/banner.png'),
                alignment: Alignment.topCenter),
            gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFA5EFB0),
                ],
                begin: FractionalOffset(0.1, 1.0),
                end: FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: [

              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.discover,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),

                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              isLoading == true
                  ? Center(
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CupertinoActivityIndicator(
                        ),
                        WavyAnimatedTextKit(
                          textStyle: GoogleFonts.sourceSansPro(
                              fontSize: 18),
                          text: [AppLocalizations.of(context)!.plswait],
                          isRepeatingAnimation: true,
                          speed: const Duration(milliseconds: 150),
                        ),
                      ],
                    ),
                  )):

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: AppinioSwiper(
                  duration: const Duration(milliseconds: 600),
                  unlimitedUnswipe: true,
                  controller: controller,
                  unswipe: _unswipe,
                  cards: cards,
                  onSwipe: _swipe,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 30,
                    bottom: 40,
                  ),
                ),
              ),
            ],
          ),
        ) );
  }
}