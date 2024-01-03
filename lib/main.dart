import 'package:flutter/material.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/hotload/splash.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ratio = MediaQuery.of(context).size.width / 390;
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
    );
  }
}