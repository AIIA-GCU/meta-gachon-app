import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import 'pages/on_boarding_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/select_service_page.dart';

Future<void> main() async {

  debugPrint("called main()\n");

  today = stdFormat3.format(DateTime.now());

  debugPrint("initializing flutter binding");

  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("determining initial page");

  late final Widget start;
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final bool? first = preferences.getBool('firstTime');

  if (first == null) {
    preferences.setBool('firstTime', true);
    start = OnBoarding();
  } else if (first == true) {
    start = OnBoarding();
  } else {
    try {
      await FCM.initialize();
      final fcmToken = await FCM.getToken();
      myInfo = (await RestAPI.signIn(id: 'already', pw: 'signedIn', token: fcmToken))!;
      start = const SelectingServicePage();
    } catch(_) {
      debugPrint('No token');
      start = const SignInPage();
    }
  }

  debugPrint("complete camera setting");

  camera = await availableCameras().then((value) {
    debugPrint(value.length.toString());
    return value.first;
  });

  debugPrint("start to run app");

  runApp(MataGachon(start: start));
}

class MataGachon extends StatefulWidget {
  const MataGachon({super.key, required this.start});

  final Widget start;

  @override
  State<MataGachon> createState() => _MataGachonState();
}
class _MataGachonState extends State<MataGachon> {

  @override
  Widget build(BuildContext context) {
    ratio = Size(
      MediaQuery.of(context).size.width  / 390,
      MediaQuery.of(context).size.height / 895
    );
    return MaterialApp(
      title: "메타가천",
      theme: ThemeData(
          scaffoldBackgroundColor: MGColor.base9,
          appBarTheme: const AppBarTheme(
              backgroundColor: MGColor.base9,
              elevation: 0,
              foregroundColor: MGColor.base4,
              toolbarHeight: 56,
              scrolledUnderElevation: 0.0
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedLabelStyle: KR.label3.copyWith(color: MGColor.base3),
            unselectedLabelStyle: KR.label3.copyWith(color: MGColor.base1),
            unselectedIconTheme: const IconThemeData(size: 24, color: MGColor.base4),
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
          useMaterial3: true,
      ),
      builder: FToastBuilder(),
      home: widget.start,
    );
  }
}