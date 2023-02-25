import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:bitky/globals/globals.dart';
import 'package:bitky/widgets/custom_appbar_widget.dart';
import 'package:bitky/widgets/swipe_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../l10n/app_localizations.dart';
import '../models/weather_data_model.dart';


class DiscoverItemScreen extends StatefulWidget {
  WeatherDataModel? dataModel;
  List<DiscoverSwipeCard>? cards;
   DiscoverItemScreen({Key? key,this.dataModel, this.cards}) : super(key: key);

  @override
  State<DiscoverItemScreen> createState() => _DiscoverItemScreenState();
}

class _DiscoverItemScreenState extends State<DiscoverItemScreen> {
  final AppinioSwiperController controller = AppinioSwiperController();

  bool isLoading = false;
  bool? isOkey;
  List<DiscoverSwipeCard> _list = [];
  bool showOkey= false;


  @override
  void initState() {
    super.initState();
    widget.cards!.forEach((element) {
      _list.add(element);
    });
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    if(direction == AppinioSwiperDirection.right){
      FirebaseFirestore.instance.collection("discover").doc(widget.cards![index].iD.toString()).update({
      "approve":FieldValue.increment(1),
        "approveUsers":FieldValue.arrayUnion([{"id":authUser.currentUser!.uid,"approveType":1}]),
      }).whenComplete(() {
        widget.cards!.removeAt(index);
      });

      showDialog(context: context,
          barrierDismissible: false,
          builder: (c){
        Future.delayed(const Duration(milliseconds: 1450), () {
          Navigator.of(context, rootNavigator: true).pop("Discard");
        });
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          content: Container(
            color: Colors.transparent,
              height: 200,
              width: 200,
              child: Lottie.asset("images/done.json", repeat: false)),
        );
      });
    }else if(direction == AppinioSwiperDirection.left){
      FirebaseFirestore.instance.collection("discover").doc(widget.cards![index].iD.toString()).update({
        "approveUsers":FieldValue.arrayUnion([{"id":authUser.currentUser!.uid,"approveType":0}]),
      }).whenComplete(() {
        widget.cards!.removeAt(index);
      });
      showDialog(context: context,
          barrierDismissible: false,
          builder: (c){
        Future.delayed(const Duration(milliseconds: 1450), () {
          Navigator.of(context, rootNavigator: true).pop("Discard");
        });
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          content: Container(
              color: Colors.transparent,
              height: 200,
              width: 200,
              child: Lottie.asset("images/cancel.json", repeat: false)),
        );
      });
    }
    log("the card was swiped to the: ${direction.name}");
  }

 void _onEnd(){

 }

  void _unswipe(bool unswiped) {
    if (unswiped) {

      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
      appBar: CustomAppBarWidget(dataModel: widget.dataModel,),
        body:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration:  BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image:  AssetImage(widget.dataModel!.current!.isDay==0?'images/night.png':'images/day.png',),alignment: Alignment.bottomCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 100+10),
            child: Column(
              children: [
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
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: AppinioSwiper(
                    duration: const Duration(milliseconds: 600),
                    threshold: 100,
                    unlimitedUnswipe: true,
                    controller: controller,
                    unswipe: _unswipe,
                    cards: _list,
                    onSwipe: _swipe,
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                      top: 40,
                      bottom: 0,
                    ),
                  ),
                ),



              ],
            ),
          ),
        ) );
  }
}
