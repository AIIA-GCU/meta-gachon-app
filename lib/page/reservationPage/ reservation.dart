///추호성이꺼

import 'package:flutter/material.dart';
import 'package:mata_gachon/page/reservationPage/reservationPage.dart';

class Reservation extends StatelessWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.yellow,
        child: Center(
          child: Container(
            child: TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(
                  PageRouteBuilder(
                    transitionsBuilder:
                        // secondaryAnimation: 화면 전화시 사용되는 보조 애니메이션효과
                        // child: 화면이 전환되는 동안 표시할 위젯을 의미(즉, 전환 이후 표시될 위젯 정보를 의미)
                        (context, animation, secondaryAnimation, child) {
                      // Offset에서 x값 1은 오른쪽 끝 y값 1은 아래쪽 끝을 의미한다.
                      // 애니메이션이 시작할 포인트 위치를 의미한다.
                      var begin = const Offset(1.0, 0);
                      var end = Offset.zero;
                      // Curves.ease: 애니메이션이 부드럽게 동작하도록 명령
                      var curve = Curves.ease;
                      // 애니메이션의 시작과 끝을 담당한다.
                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(
                        CurveTween(
                          curve: curve,
                        ),
                      );
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    // 함수를 통해 Widget을 pageBuilder에 맞는 형태로 반환하게 해야한다.
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        // (DetailScreen은 Stateless나 Stateful 위젯으로된 화면임)
                        ReservationPage(),
                    // 이것을 true로 하면 dialog로 취급한다.
                    // 기본값은 false
                    fullscreenDialog: false,
                  ),
                );
              },
              child: Text('Test Page, Press this text to return'),
            ),
          ),
        ),
      ),
    );
  }
}
