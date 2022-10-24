import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:umkm_application/Announcement/ui/announcement_detail.dart';
import 'package:umkm_application/Coaching/ui/coaching.dart';
import 'package:umkm_application/Event/ui/event_detail.dart';
import 'package:umkm_application/ProductDetail/ui/product_detail.dart';
import 'package:umkm_application/Statistic/ui/dummy_statistic.dart';
import 'package:umkm_application/StoreDetail/ui/description_form_page_screen.dart';
import 'package:umkm_application/StoreDetail/ui/store_detail.dart';
import 'package:umkm_application/Const/const_color.dart';
import 'package:umkm_application/Event/ui/event_list.dart';
import 'package:umkm_application/Announcement/ui/announcement_list.dart';
import 'package:umkm_application/Home/ui/home.dart';
import 'package:umkm_application/data/repositories/shared_pref_repositories.dart';

class BottomNavigation extends StatefulWidget {
  final BuildContext menuScreenContext;
  BottomNavigation({Key? key, required this.menuScreenContext})
      : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late PersistentTabController _controller;
  late bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(title: "Home Page"),
      EventPage(),
      CoachingPage(title: "Coaching"),
      // Statistic(uid: _userID),
      DummyStatisticPage(title: 'Statistic'),
      AnnouncementPage(),
      StoreDetail(
        //TODO: Change this
        uid: sharedPrefs.userid,
        isFromProfilePage: true,
        // uid:  '1BxcK5j4ksfUmG3iu694syyNruf1',
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: "Home",
          activeColorPrimary: ConstColor.secondaryTextDatalab,
          inactiveColorPrimary: Colors.blueGrey,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: '/home',
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == StoreDetail.routeName) {
                  var arg = settings.arguments as Map;
                  return MaterialPageRoute(
                      builder: (context) => new StoreDetail(
                            uid: arg['uid'],
                            isFromProfilePage: false,
                          ));
                } else if (settings.name == StoreFormScreen.routeName) {
                  var arg = settings.arguments as Map;
                  return MaterialPageRoute(
                      builder: (context) =>
                          new StoreFormScreen(store: arg['store']));
                } else if (settings.name == ProductDetail.routeName) {
                  var arg = settings.arguments as Map;
                  return MaterialPageRoute(
                      builder: (context) => new ProductDetail(
                          umkmid: arg['umkmid'],
                          productid: arg['productid'],
                          ecommerceName: arg['ecommerceName']));
                }
              })),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.event),
          title: ("Event"),
          activeColorPrimary: ConstColor.secondaryTextDatalab,
          inactiveColorPrimary: Colors.blueGrey,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: '/event',
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == EventDetail.routeName) {
                  var arg = settings.arguments as Map;
                  return MaterialPageRoute(
                      builder: (context) => new EventDetail(
                            eventID: arg['eventID'],
                          ));
                }
              })),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.people),
        title: ("Coaching"),
        activeColorPrimary: ConstColor.secondaryTextDatalab,
        inactiveColorPrimary:  Colors.blueGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.insert_chart_outlined),
        title: ("Statistic"),
        activeColorPrimary: ConstColor.secondaryTextDatalab,
        inactiveColorPrimary:  Colors.blueGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.announcement_outlined),
        title: ("Announce"),
        activeColorPrimary: ConstColor.secondaryTextDatalab,
        inactiveColorPrimary: Colors.blueGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: '/announcement',
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == AnnouncementDetail.routeName) {
                  var arg = settings.arguments as Map;
                  return MaterialPageRoute(
                      builder: (context) => new AnnouncementDetail(
                            announcementID: arg['announcementID'],
                          ));
                }
              })
      ),
      PersistentBottomNavBarItem(
          icon: Icon(MdiIcons.faceManProfile),
          title: ("Profile"),
          activeColorPrimary: ConstColor.secondaryTextDatalab,
          inactiveColorPrimary:Colors.blueGrey,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: '/profile',
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == StoreFormScreen.routeName) {
                  var arg = settings.arguments as Map;
                  return MaterialPageRoute(
                      builder: (context) =>
                          new StoreFormScreen(store: arg['store']));
                }
              })),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : 64,
      hideNavigationBarWhenKeyboardShows: true,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      popActionScreens: PopActionScreensType.all,
      bottomScreenMargin: 0.0,
      hideNavigationBar: _hideNavBar,
      decoration: NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 6))
          ]),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style9, // Choose the nav bar style with this property
    );
  }
}
