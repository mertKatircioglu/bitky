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
  Size get preferredSize => const Size.fromHeight(80);

  const CustomAppBarWidget({Key? key}) : super(key: key);

  @override
  State<CustomAppBarWidget> createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  double? lat, lon;
  BitkyViewModel? _bitkyViewModel;
  WeatherDataModel _weatherDataModel = WeatherDataModel();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(AppLocalizations.of(context)!.locationservicesaredisable);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(AppLocalizations.of(context)!.locationpermissionaredenied);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          AppLocalizations.of(context)!.locationpermissionpermanetly);
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
  //  print("kullanıcı: ${authUser.currentUser!}");
    _determinePosition().then((value) {
      _bitkyViewModel!.getWeatherFromUi(value.latitude, value.longitude, context).then((value) {
        _weatherDataModel = value;
        print(_weatherDataModel.toJson().toString());
      });
    });
  }



  Widget _appBarContent() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      child: Column(

        children: [
          //_header(),
          const SizedBox(
            height: 10,
          ),
          _userInfo()
        ],
      ),
    );
  }

  Widget _userInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _weatherInfo(),
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
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            _weatherIcon(),
          ],
        ),


      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      children: [
        CachedNetworkImage(
          height: 30,
          width: 40,
          fit: BoxFit.cover,
          imageUrl:"http://openweathermap.org/img/wn/${_weatherDataModel.icon}@4x.png",
          placeholder: (context, url) =>
          const CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fadeOutDuration: const Duration(seconds: 1),
          fadeInDuration: const Duration(seconds: 2),
        ),
        Column(children: [
          Text(_weatherDataModel.placeName.toString().toCapitalized(),
            style: GoogleFonts.sourceSansPro(
                color: Colors.black54,
                fontSize: 10,
                fontWeight: FontWeight.w600
            ),),
          Text("${_weatherDataModel.wthr.toString().toCapitalized()}",
              textAlign: TextAlign.center,
              style: GoogleFonts.sourceSansPro(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ],),
      ],
    );
  }

  Widget _weatherInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${_weatherDataModel.temp.toString().substring(0, 4)}°C",
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  )),
              Text("${AppLocalizations.of(context)!.feelslike} ${_weatherDataModel.feels.toString().substring(0, 4) ?? ""}°C",
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 9,
                    color: Colors.black54,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.wind,
                    color: Colors.black54,
                    size: 9,
                  ),
                  Text(_weatherDataModel.wind.toString(),
                      style: GoogleFonts.sourceSansPro(
                          color: Colors.black54,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 2,
                  ),
                  const Icon(
                    Icons.water_drop_outlined,
                    color: Colors.black54,
                    size: 9,
                  ),
                  Text(_weatherDataModel.hummudity.toString(),
                      style: GoogleFonts.sourceSansPro(
                          color: Colors.black54,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                ],
              ),


            ],
          ),
        ),

      ],
    );
  }

/*  Future<String> changeBackGorund(String code) async{

    switch(code){

      case
    }

  }*/

  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFA5EFB0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.1, 1.0),
                stops: [0.0, 0.1],
                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)
            )
        ),
        child: _appBarContent(),),
    );
  }


}



