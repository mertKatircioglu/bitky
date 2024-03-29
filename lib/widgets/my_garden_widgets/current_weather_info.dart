import 'package:bitky/models/weather_data_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentWeatherInfoWidget extends StatelessWidget {
  WeatherDataModel? dataModel;
   CurrentWeatherInfoWidget({Key? key, this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            dataModel!.location!.name.toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(
                color:Colors.white70,
                fontSize: 55,
               
                fontWeight: FontWeight.bold)),
        Text(
            "${dataModel!.current!.tempC.toString()}°C",
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(
                color:Colors.white70,
                fontSize: 55,
              
                fontWeight: FontWeight.bold)),
        Text(
            dataModel!.current!.condition!.text.toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(
                color:Colors.white70,
                fontSize: 25,
               
                fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.water_drop, color: Colors.white70, size: 16,),
              Text(
                  "%${dataModel!.current!.humidity.toString()}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color:Colors.white70,
                      fontSize: 16,

                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10,),
              const Icon(Icons.wind_power, color: Colors.white70, size: 16,),
              Text(
                  "${dataModel!.current!.windKph.toString()} km/h",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color:Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10,),
              Text(
                  "Max: ${dataModel!.forecast!.forecastday![0].day!.maxtempC.toString()}°C",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color:Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10,),
              Text(
                  "Min: ${dataModel!.forecast!.forecastday![0].day!.mintempC.toString()}°C",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                      color:Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10,),
            ],
          ),
        ),
      ],
    );
  }
}
