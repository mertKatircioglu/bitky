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
decoration:  BoxDecoration(
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //     image:  AssetImage(widget.dataModel!.current!.isDay==0?'images/tp_banner_night.png':'images/tp_banner.png',)),
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)
            )
        ),      height: 105,
      width: MediaQuery.of(context).size.width,
      child: Padding(padding: const EdgeInsets.only(left: 8,right: 8, top: 55),
      child: Column(
        children: [

          //_userInfo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             _weatherInfo(),
              Row(
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
            _weatherIcon(),

            ],
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 0),
        decoration:  BoxDecoration(
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //     image:  AssetImage(widget.dataModel!.current!.isDay==0?'images/tp_banner_night.png':'images/tp_banner.png',)),
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)
            )
        ),
        child: _appBarContent(),),
    );
  }


}



