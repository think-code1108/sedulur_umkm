// ------------------------------------------ //
// Template from : TheAlphamerc               //
// Github : TheAlphamerc/flutter_login_signup //
// ------------------------------------------ //

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:umkm_application/Const/const_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/title.dart';

class CoachingPage extends StatefulWidget {
  CoachingPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CoachingPageState createState() => _CoachingPageState();
}

class _CoachingPageState extends State<CoachingPage> {
  Widget _coachingButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [ConstColor.darkDatalab, ConstColor.darkDatalab])),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.blueGrey,
            onTap: () async {
              openLink();
            },
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text('Ikuti Coaching Clinic',
                    style: TextStyle(
                        fontSize: 20, color: ConstColor.secondaryTextDatalab))),
          )),
    );
  }

  void openLink() async {
    final Uri _url = Uri.parse('https://sadulur.site/');
    // if (!await launchUrl(_url)) {
    //   throw 'Could not launch $_url';
    // }

    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      print('There was a problem to open the url: $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color(0xfffbfbfb),
                  Color(0xfff7f7f7),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TitleApp('UMKM Coaching Clinic', false),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Ikuti Coaching Clinic bersama mentor-mentor terbaik dari Sekolah Bisnis dan Manajemen ITB. Segera atur jadwalnya dan dapatkan ilmu baru untuk membuat UMKM anda melesat.',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: ConstColor.darkDatalab,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image(
                        image: AssetImage('assets/conference.png'),
                      ),
                    ),
                    _coachingButton(context),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
