import 'package:bitky/models/weather_data_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FutureWeatherInfoWidget extends StatelessWidget {
  WeatherDataModel? dataModel;
   FutureWeatherInfoWidget({Key? key, this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      decoration:  BoxDecoration(
          color:Colors.black54,
          borderRadius: BorderRadius.circular(20.0)
      ),
      padding: const EdgeInsets.all(12.00),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(DateFormat('EEEE').format(DateTime.parse(dataModel!.forecast!.forecastday![1].date.toString())),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const Divider(height: 1,color: Colors.white,thickness: 1,),
                    CachedNetworkImage(
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      imageUrl:
                      "https:${dataModel!.forecast!.forecastday![1].day!.condition!.icon}",
                      placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 2),
                    ),
                    Text("${dataModel!.forecast!.forecastday![1].day!.condition!.text}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                          color:Colors.white,
                          fontSize: 8,
                        )),
                    Text("Max: ${dataModel!.forecast!.forecastday![1].day!.maxtempC}°C",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    Text("Min: ${dataModel!.forecast!.forecastday![1].day!.mintempC}°C",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),

                    Text("Nem: ${dataModel!.forecast!.forecastday![1].day!.avghumidity}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),

                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(DateFormat('EEEE').format(DateTime.parse(dataModel!.forecast!.forecastday![2].date.toString())),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const Divider(height: 1,color: Colors.white,thickness: 1,),
                    CachedNetworkImage(
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      imageUrl:
                      "https:${dataModel!.forecast!.forecastday![2].day!.condition!.icon}",
                      placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 2),
                    ),
                    Text("${dataModel!.forecast!.forecastday![2].day!.condition!.text}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 8)),
                    Text("Max: ${dataModel!.forecast!.forecastday![2].day!.maxtempC}°C",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    Text("Min: ${dataModel!.forecast!.forecastday![2].day!.mintempC}°C",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),

                    Text("Nem: ${dataModel!.forecast!.forecastday![2].day!.avghumidity}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(DateFormat('EEEE').format(DateTime.parse(dataModel!.forecast!.forecastday![3].date.toString())),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const Divider(height: 1,color: Colors.white,thickness: 1,),
                    CachedNetworkImage(
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      imageUrl:
                      "https:${dataModel!.forecast!.forecastday![3].day!.condition!.icon}",
                      placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 2),
                    ),
                    Text("${dataModel!.forecast!.forecastday![3].day!.condition!.text}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                          color:Colors.white,
                          fontSize: 8,)),
                    Text("Max: ${dataModel!.forecast!.forecastday![3].day!.maxtempC}°C",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    Text("Min: ${dataModel!.forecast!.forecastday![3].day!.mintempC}°C",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),

                    Text("Nem: ${dataModel!.forecast!.forecastday![3].day!.avghumidity}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            color:Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
