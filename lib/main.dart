import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mata_gachon/pages/select_service_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:mata_gachon/pages/on_boarding_page.dart';

Future<void> main() async {

  debugPrint("called main()\n");

  today = std3_format.format(DateTime.now());

  debugPrint("initializing flutter binding");

  await WidgetsFlutterBinding.ensureInitialized();

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
      start = SelectingServicePage();
    } catch(_) {
      debugPrint('No token');
      start = SignInPage();
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
          scaffoldBackgroundColor: MGcolor.base9,
          appBarTheme: AppBarTheme(
              backgroundColor: MGcolor.base9,
              elevation: 0,
              foregroundColor: MGcolor.base4,
              toolbarHeight: 56,
              scrolledUnderElevation: 0.0
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedLabelStyle: KR.label3.copyWith(color: MGcolor.base3),
            unselectedLabelStyle: KR.label3.copyWith(color: MGcolor.base1),
            unselectedIconTheme: IconThemeData(size: 24, color: MGcolor.base4),
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