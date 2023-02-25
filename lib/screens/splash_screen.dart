import 'dart:async';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/widgets/custom_select_city_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals/globals.dart';
import '../helpers/notification_service.dart';
import '../locator.dart';
import '../models/weather_data_model.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/custom_error_dialog.dart';
import '../widgets/swipe_item_widget.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'package:timezone/timezone.dart' as tz;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  WeatherDataModel _weatherDataModel = WeatherDataModel();
  final BitkyViewModel _bitkyViewModel = BitkyViewModel();
  String prefCity = "";
  bool prefBool = false;
  bool prefReminderBool = false;
  List<DiscoverSwipeCard> cards = [];
  late final LocalNotificationService service;

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      content: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: const CustomSelectCityWidget()),
        ),
      ),
    );
  }

  getUserReminderData() async {
    print("çalıştı");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(authUser.currentUser!.uid.toString())
        .collection('gardens')
        .get()
        .then((value) async {
      final data = value.docs;
      for (var doc in data) {
        print(doc.data()['roomName']);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authUser.currentUser!.uid.toString())
            .collection('gardens')
            .doc(doc.data()['roomId'].toString())
            .collection(doc.data()['roomName'])
            .get()
            .then((value) {
          for (var doc in value.docs) {
           // print(doc.data()["plantName"]);
            if (doc.data()["scheduleType"] == "daily") {
              var tzTime = tz.TZDateTime.parse(tz.local, doc.data()["tzTime"]);
              service.showSchelduledNotificationDaily(
                  id: doc.data()["scheduleId"],
                  title: doc.data()["plantName"],
                  body: doc.data()["content"],
                  time: tzTime);
            } else if (doc.data()["scheduleType"] == "weekly") {
            //  print("Haftalık: " + doc.data()["plantName"]);
              var tzTime = tz.TZDateTime.parse(tz.local, doc.data()["tzTime"]);
              service.showSchelduledNotificationWeakly(
                  id: doc.data()["scheduleId"],
                  title: doc.data()["plantName"],
                  body: doc.data()["content"],
                  time: tzTime,
                  day: doc.data()["reminderDay"]);
            } else if (doc.data()["scheduleType"] == "monthly") {
              //print("Aylık: " + doc.data()["plantName"]);
              var tzTime = tz.TZDateTime.parse(tz.local, doc.data()["tzTime"]);
              service.showSchelduledNotificationmonthly(
                  id: doc.data()["scheduleId"],
                  title: doc.data()["plantName"],
                  body: doc.data()["content"],
                  time: tzTime,
                  day: doc.data()["reminderDay"]);
            }
          }
        }).whenComplete(() async {
          sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences!.setBool("reminderBool", true);
        });
      }
    });
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('discover')
        .where("approveUsers",
            whereNotIn: ["${authUser.currentUser!.uid.toString()}"])
        .orderBy("approveUsers", descending: true)
        .get()
        .then((event) {
          final data = event.docs;
          for (var doc in data) {
            var date = DateTime.now().day -
                DateTime.parse(doc.data()["createDate"].toDate().toString())
                    .day;
            cards.add(DiscoverSwipeCard(
              title: doc.data()["title"],
              iD: doc.data()["id"],
              subTile: doc.data()["subTitle"],
              dateTame: date.toString(),
              imgUrl: doc.data()["imgUrl"],
              descrip: doc.data()["description"],
              user: doc.data()["user"],
              lat: doc.data()["lat"],
              long: doc.data()["long"],
              userAvatarUrl: doc.data()["userAvatarUrl"],
              approveCount: doc.data()["approve"].toString(),
            ));
          }
        });
  }

  void _scaleDialog(Widget dialog) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "go",
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: dialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ).whenComplete(() {
      getPref().whenComplete(() {
        _bitkyViewModel
            .getWeatherFromUi(121.121, 121.121, prefCity, context)
            .then((value) {
          _weatherDataModel = value;
        }).whenComplete(() => startTimer(context));
      });
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChangeNotifierProvider<BitkyViewModel>(
            create: (context) => locator<BitkyViewModel>(),
            child: HomeScreen(
              dataModel: _weatherDataModel,
              cards: cards,
            ));
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteAuth() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AuthScreen(
        dataModel: _weatherDataModel,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  startTimer(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      Timer(const Duration(seconds: 1), () async {
        if (authUser.currentUser != null) {
          Navigator.of(context).pushReplacement(_createRoute());
        } else {
          Navigator.of(context).pushReplacement(_createRouteAuth());
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return CustomErrorDialog(message: "No Internet connection.");
          });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          AppLocalizations.of(context)!.locationservicesaredisable);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _scaleDialog(_dialog(context));
        return Future.error(
            AppLocalizations.of(context)!.locationpermissionaredenied);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _scaleDialog(_dialog(context));
      return Future.error(
          AppLocalizations.of(context)!.locationpermissionpermanetly);
    }
    return await Geolocator.getCurrentPosition()
        .whenComplete(() => startTimer(context));
  }

  Future getPref() async {



    setState(() {
      prefCity = sharedPreferences!.getString("city") ?? "";
      prefBool = sharedPreferences!.getBool("cityBool") ?? false;
      prefReminderBool = sharedPreferences!.getBool("reminderBool") ?? false;
    });
  }



  @override
  void initState() {
    super.initState();
    service = LocalNotificationService();
    getPref();
    if(authUser.currentUser != null){
      getData();
      prefReminderBool == false ? getUserReminderData() : null;

    }
    if (prefBool == true) {
      _bitkyViewModel
          .getWeatherFromUi(121.121, 121.121, prefCity, context)
          .then((value) {
        _weatherDataModel = value;
      }).whenComplete(() => startTimer(context));
    } else {
      _determinePosition().then((value) {
        _bitkyViewModel
            .getWeatherFromUi(
                value.latitude, value.longitude, prefCity, context)
            .then((value) {
          _weatherDataModel = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/banner.png'),
                alignment: Alignment.topCenter),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("images/splashLottie2.json",
                  width: 400, height: 400),
              Text(
                "Bitky",
                style: GoogleFonts.sourceSansPro(
                    color: kPrymaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Text(AppLocalizations.of(context)!.splashtitle,
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.black54, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
