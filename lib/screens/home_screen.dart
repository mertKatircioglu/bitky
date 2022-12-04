
import 'package:bitky/globals/globals.dart';
import 'package:bitky/nav_bar_items/my_garden_item.dart';
import 'package:bitky/nav_bar_items/reminders_item.dart';
import 'package:bitky/nav_bar_items/search_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../nav_bar_items/diagnose_item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  PersistentTabController? _controller;
  bool? _hideNavBar;


  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark
    ));
  }

  List<Widget> _buildScreens() {
    return [
      const DiagnosePage(),
        const Search(),
      const Reminder(),
      const MyGarden()
    ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.waveform_path_ecg),
        title: ("Diagnose"),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.search),
          title: ("Search"),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell),
        title: ("Reminders"),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.leaf_arrow_circlepath),
        title: ("My Garden"),
        activeColorPrimary: kPrymaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),


    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true,
        navBarStyle: NavBarStyle.style6,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(20.0),
          colorBehindNavBar: Colors.white,

        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.bounceIn,
          duration: Duration(milliseconds: 200),
        ),

      ),


    );
  }


}

