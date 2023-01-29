import 'package:bitky/globals/globals.dart';
import 'package:bitky/helpers/notification_service.dart';
import 'package:bitky/nav_bar_items/discover_item.dart';
import 'package:bitky/nav_bar_items/flow_item.dart';
import 'package:bitky/nav_bar_items/my_garden_item.dart';
import 'package:bitky/nav_bar_items/reminders_item.dart';
import 'package:bitky/nav_bar_items/search_item.dart';
import 'package:bitky/widgets/custom_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../l10n/app_localizations.dart';
import '../nav_bar_items/diagnose_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController? _controller;
  bool? _hideBar=false;
  late final LocalNotificationService service;






  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);

  }

  List<Widget> _buildScreens() {
    return [
      const DiagnosePage(),
      const Search(),
      const DiscoverItemScreen(),
      const FlowItem(),
      const MyGarden(),
      // const SettingsItem()
    ];
  }



  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.waveform_path_ecg, size: 24),
        title: (AppLocalizations.of(context)!.diagnosetitle),
        textStyle: GoogleFonts.sourceSansPro(fontSize: 12),

        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.search, size: 24,),
        title: (AppLocalizations.of(context)!.searchtitle),
        textStyle: GoogleFonts.sourceSansPro(fontSize: 12),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.paperplane, size: 24),
        title: (AppLocalizations.of(context)!.discover),
        textStyle: GoogleFonts.sourceSansPro(fontSize: 12),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.flowchart, size: 24,),
        title: (AppLocalizations.of(context)!.flowtitle),
        textStyle: GoogleFonts.sourceSansPro(fontSize: 12),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.leaf_arrow_circlepath, size: 24),
        title: (AppLocalizations.of(context)!.mygardentitle),
        textStyle: GoogleFonts.sourceSansPro(fontSize: 12),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
/*     PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings, size: 20),
        title: ("Settings"),
        textStyle: GoogleFonts.sourceSansPro(fontSize: 12),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),*/
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: const CustomAppBarWidget(),
      resizeToAvoidBottomInset: false,
      body: PersistentTabView(
        context,
        controller: _controller,
        hideNavigationBar: _controller!.index.isNegative,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
       /* onItemSelected: (int)async{

        },*/
        handleAndroidBackButtonPress: true,
        navBarStyle: NavBarStyle.style9,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2), // changes position of shadow
            )
          ] ,
          borderRadius: const BorderRadius.only(topLeft:Radius.circular( 20.0), topRight:Radius.circular( 20.0)),
          colorBehindNavBar: Colors.white,

        ),
        screenTransitionAnimation:const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.bounceIn,
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
