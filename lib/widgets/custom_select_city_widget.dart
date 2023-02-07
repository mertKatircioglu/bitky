import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/globals.dart';
import '../l10n/app_localizations.dart';
import '../restart_app.dart';


class CustomSelectCityWidget extends StatefulWidget {
  const CustomSelectCityWidget({Key? key}) : super(key: key);

  @override
  State<CustomSelectCityWidget> createState() => _CustomSelectCityWidgetState();
}

class _CustomSelectCityWidgetState extends State<CustomSelectCityWidget> {
  String? countryValue;
  String? stateValue;
  String? cityValue;
  bool visibleButton = false;

  saveCity(String city)async{
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("city", city);
    await sharedPreferences!.setBool("cityBool", true);
   //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const AuthScreen()));
    Navigator.pop(context,true);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
            Column(
              children: [
                Text(AppLocalizations.of(context)!.selectcountry,
                    textAlign: TextAlign.center,
                    style:GoogleFonts.sourceSansPro()
                ),
                SelectState(
                  // style: TextStyle(color: Colors.red),
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged:(value) {
                    setState(() {
                      stateValue = value;
                      visibleButton= true;
                    });
                  }, onCityChanged: (String value) {  },

                ),
                const SizedBox(height: 25,),
                Visibility(
                  visible: visibleButton,
                  child: InkWell(
                      onTap:(){
                        saveCity(stateValue.toString().trim());
                      },
                      child: Container(
                          margin: const EdgeInsets.all(3.0),
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPrymaryColor)
                          ),
                          child: Text(AppLocalizations.of(context)!.continuee, style:GoogleFonts.sourceSansPro()))
                  ),
                )
              ],
            )
        ),
      ),
    ));
  }
}
