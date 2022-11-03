import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Authentication/Login/ui/loginscreen.dart';
import '../Const/const_color.dart';
import '../data/repositories/user_repositories.dart';

class TitleApp extends StatelessWidget {
  final String title;
  final bool isLogout;
  const TitleApp(this.title, this.isLogout, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 5, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, // 'Daftar Anggota UMKM',
                  style: GoogleFonts.lato(
                      color: ConstColor.textDatalab,
                      fontSize: 24,
                      fontWeight: FontWeight.w700))
            ],
          ),
          (isLogout)
              ? IconButton(
                  onPressed: () async {
                    await UserRepository.signOut().then((user) {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => new LoginScreen()));
                    });
                  },
                  icon: Icon(Icons.logout_outlined,
                      color: ConstColor.secondaryTextDatalab),
                )
              : SizedBox(height: 0),
        ],
      ),
    );
  }
}
