import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/hotload/splash.dart';
import 'package:mata_gachon/page/main/frame.dart';
import 'package:mata_gachon/page/services/alarm.dart';
import 'package:mata_gachon/page/services/my_admission.dart';
import 'package:mata_gachon/page/services/reservation.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

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
              toolbarHeight: 56
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
                fontFamily: 'Ko'),
            unselectedIconTheme: IconThemeData(size: 24, color: MGcolor.btn_inactive),
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
          useMaterial3: true
      ),
      home: Splash(),
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