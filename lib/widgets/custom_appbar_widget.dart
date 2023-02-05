import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/models/weather_data_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../view_models/planet_view_model.dart';

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(90);
  WeatherDataModel? dataModel;
   CustomAppBarWidget({Key? key, this.dataModel}) : super(key: key);

  @override
  State<CustomAppBarWidget> createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {

  Widget _appBarContent() {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      child: Column(
        children: [

          _userInfo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                    imageUrl: authUser.currentUser!.photoURL.toString(),
                    placeholder: (context, url) =>
                    const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fadeOutDuration: const Duration(seconds: 1),
                    fadeInDuration: const Duration(seconds: 1),
                  ),
                ),
              ),
              Text(authUser.currentUser!.displayName.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _userInfo() {
    return Column(

      children: [
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _weatherInfo(),
            _weatherIcon(),
          ],
        ),


      ],
    );
  }

  Widget _weatherIcon() {
    return CachedNetworkImage(
      height: 35,
      width: 35,
      fit: BoxFit.cover,
      imageUrl:"https:${widget.dataModel!.current!.condition!.icon.toString()}",
      placeholder: (context, url) =>
      const CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fadeOutDuration: const Duration(seconds: 1),
      fadeInDuration: const Duration(seconds: 2),
    );
  }

  Widget _weatherInfo() {
    return  Text("${widget.dataModel!.current!.tempC.toString()}°C",
        style: GoogleFonts.sourceSansPro(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ));
  }

/*  Future<String> changeBackGorund(String code) async{

    switch(code){

      case
    }

  }*/

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        decoration:  BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
                image:  AssetImage(widget.dataModel!.current!.isDay==0?'images/night.png':'images/day.png',),alignment: Alignment.bottomCenter),
            color: Colors.black,
            borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)
            )
        ),
        child: _appBarContent(),),
    );
  }


}



