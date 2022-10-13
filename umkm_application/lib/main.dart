import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:umkm_application/Authentication/Login/ui/loginscreen.dart';
import 'package:umkm_application/Authentication/bloc/auth_bloc.dart';
import 'package:umkm_application/BottomNav/ui/bottomnav.dart';
import 'package:umkm_application/data/repositories/shared_pref_repositories.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await sharedPrefs.init();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(
    MaterialApp(
      title: 'Sadulur UMKM Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyApp(),
        '/login': (context) => LoginScreen(),
        '/bottomnav': (context) => BottomNavigation(
              menuScreenContext: context,
            )
      },
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (context) => AuthBloc()..add(AppLoaded()),
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      if (state is UnAuthenticateState) {
        Navigator.pushNamed(context, '/login');
      } else if (state is AuthenticateState) {
        // return MaterialPageRoute(builder: (_) => BottomNavigation());
        pushNewScreen(context,
            screen: BottomNavigation(menuScreenContext: context));
      }
    }, child: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container();
      },
    ));
  }
}
