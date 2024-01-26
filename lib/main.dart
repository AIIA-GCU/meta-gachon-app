import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/page/main/frame.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/hotload/login.dart';
import 'package:mata_gachon/page/hotload/on_boarding.dart';
// import 'package:mata_gachon/page/main/frame.dart';
// import 'package:mata_gachon/page/services/alarm.dart';
// import 'package:mata_gachon/page/services/my_admission.dart';
// import 'package:mata_gachon/page/services/reservate.dart';

Future<void> main() async {
  debugPrint("called main()");
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("determining initial page");
  late final Widget start;
  try {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool? first = preferences.getBool('firstTime');
    if (first == null) {
      preferences.setBool('firstTime', true);
      start = OnBoarding();
    } else if (first == true) {
      start = OnBoarding();
    } else {
      await new Session().get();
      start = Login();
    }
  } catch(e) {
    debugPrint("token is empty");
    start = Login();
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
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onStateChange: _onStateChange);
  }

  Future<void> _onStateChange(AppLifecycleState state) async {
    if (Platform.isAndroid && state == AppLifecycleState.paused) {
      debugPrint("killed android app");
      await new Session().clear();
      _listener.dispose();
    } else if (Platform.isIOS && state == AppLifecycleState.detached) {
      debugPrint("kiiled ios app");
      await new Session().clear();
      _listener.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    ratio = Size(
      MediaQuery.of(context).size.width  / 390,
      MediaQuery.of(context).size.height / 895
    );
    return MaterialApp(
      title: "메타가천",
      theme: ThemeData(
          scaffoldBackgroundColor: MGcolor.base8,
          appBarTheme: AppBarTheme(
              backgroundColor: MGcolor.base8,
              elevation: 0,
              foregroundColor: MGcolor.base4,
              toolbarHeight: 56,
              scrolledUnderElevation: 0.0
            ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedLabelStyle: TextStyle(
                color: MGcolor.base2,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Ko'
            ),
            selectedIconTheme: IconThemeData(size: 24, color: MGcolor.btn_active),
            unselectedLabelStyle: TextStyle(
                color: MGcolor.base2,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Ko'
            ),
            unselectedIconTheme: IconThemeData(size: 24, color: MGcolor.btn_inactive),
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
          useMaterial3: true,
      ),
      home: widget.start,
      // routerConfig: GoRouter(
      //   routes: [
      //     GoRoute(path: '/', name: 'home', builder: (context, _) => MainFrame()),
      //     GoRoute(path: '/alarm', name: 'alarm', builder: (context, _) => Alarm()),
      //     GoRoute(path: '/reservation', name: 'reservation', builder: (context, _) => Reservation()),
      //     GoRoute(path: '/add_admission', name: 'add_admission', builder: (context, _) => Container()),
      //     GoRoute(path: '/my_admission', name: 'my_admission', builder: (context, _) => MyAdmission())
      //   ]
      // ),
    );
  }
}