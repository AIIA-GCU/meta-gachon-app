///
/// main.dart
/// 2024.03.07
/// by. @protaku
///
/// <br>
///
/// Changes
/// - Added comment
///
/// Content
/// [*] Function
///   - main()
/// [*] Class
///   - MetaGachonApp
///
///

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mata_gachon/pages/main_frame.dart';
import 'package:mata_gachon/pages/reserve_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import 'pages/cube_page.dart';
import 'pages/sign_in_page.dart';

Future<void> main() async {

  debugPrint("called main()");

  debugPrint("initializing flutter binding");
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("initializing local date time");
  await initializeDateFormatting();
  today = stdFormat3.format(DateTime.now());

  debugPrint("determining initial page");
  late final Widget start;
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final bool? first = preferences.getBool('firstTime');

  if (first == null) {
    preferences.setBool('firstTime', true);
    start = const CubePage(
      title: "교내 공간을 간편하게 예약하세요",
      content: "언제 어디서든\n비어있는 회의실 및 강의실,\n컴퓨터를 예약하고 확인하세요.",
      buttonText: "시작하기",
      nextPage: SignInPage(),
    );
  } else if (first == true) {
    start = const CubePage(
      title: "교내 공간을 간편하게 예약하세요",
      content: "언제 어디서든\n비어있는 회의실 및 강의실,\n컴퓨터를 예약하고 확인하세요.",
      buttonText: "시작하기",
      nextPage: SignInPage(),
    );
  } else {
    try {
      // await FCM.initialize();
      // final fcmToken = await FCM.getToken();
      myInfo = (await RestAPI.signIn(id: 'already', pw: 'signedIn', token: 'fcmToken'))!;
      reserves = await RestAPI.getRemainReservation() ?? [];
      admits = await RestAPI.getAllAdmission() ?? [];
      myAdmits = await RestAPI.getMyAdmission() ?? [];
      start = const MainFrame();
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
  runApp(MataGachonApp(start: start));
}

///
/// MetaGachonApp
///
/// The root widget of app, including MaterialApp()
///
/// Parameters
/// - start(Widget):
///   The displayed screen when running app.
///   If app is installed for the first time, then display [OnBoardingPage]
///   If remaining the session, then display [MainFrame]
///   If not both, display [SignInPage]
///
class MataGachonApp extends StatefulWidget {
  const MataGachonApp({super.key, required this.start});

  final Widget start;

  @override
  State<MataGachonApp> createState() => _MataGachonAppState();
}
class _MataGachonAppState extends State<MataGachonApp> {

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
      ),
      builder: FToastBuilder(),   // for <fluttertost> package
      home: widget.start,
    );
  }
}