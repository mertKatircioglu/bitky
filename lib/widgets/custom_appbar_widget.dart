import 'package:bitky/globals/globals.dart';
import 'package:bitky/models/weather_data_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

import '../view_models/planet_view_model.dart';

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => const Size.fromHeight(100);

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
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      _bitkyViewModel!.getWeatherFromUi(value.latitude, value.longitude).then((value) {
        _weatherDataModel = value;
        print(_weatherDataModel.toJson().toString());
      });
    });
  }



  Widget _appBarContent() {
    return Container(
      height: 195,
      width: 400,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          //_header(),
          const SizedBox(
            height: 20,
          ),
          _userInfo()
        ],
      ),
    );
  }

  Widget _userInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _weatherIcon(),
        Column(
          children: [
            Text("${authUser.currentUser!.displayName.toString()}",
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSansPro(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),

          ],
        ),
        _userPersonalInfo(),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      children: [
        CachedNetworkImage(
          height: 45,
          width: 45,
          fit: BoxFit.cover,
          imageUrl:"http://openweathermap.org/img/w/${_weatherDataModel.icon}.png",
          placeholder: (context, url) =>
          const CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fadeOutDuration: const Duration(seconds: 1),
          fadeInDuration: const Duration(seconds: 2),
        ),
        Row(
          children: [
            const Icon(
              CupertinoIcons.location_solid,
              color: Colors.black54,
              size: 10,
            ),
            Text(_weatherDataModel.placeName.toString(),
                style: GoogleFonts.sourceSansPro(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        Text("${_weatherDataModel.wthr.toString().toCapitalized()}",
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(
                color: Colors.black54,
                fontSize: 10,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _userPersonalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${_weatherDataModel.temp.toString().substring(0, 4) ?? ""}°C",
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 35,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  )),
              Text("Hissedilen: ${_weatherDataModel.feels.toString().substring(0, 4) ?? ""}°C",
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 14,
                    color: Colors.black54,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.wind,
                    color: Colors.black54,
                    size: 12,
                  ),
                  Text(_weatherDataModel.wind.toString(),
                      style: GoogleFonts.sourceSansPro(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 2,
                  ),
                  const Icon(
                    Icons.water_drop_outlined,
                    color: Colors.black54,
                    size: 12,
                  ),
                  Text("${_weatherDataModel.hummudity.toString()}",
                      style: GoogleFonts.sourceSansPro(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return CustomPaint(
        painter: LogoPainter(),
        size: const Size(400, 195),
        child: _appBarContent());
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromARGB(255, 176, 236, 170),
        Color.fromARGB(255, 255, 255, 255),
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(size.width / 1.2, size.height, size.width,
        size.height - size.height / 8, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawShadow(path, const Color.fromARGB(255, 0, 0, 0), 3, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
