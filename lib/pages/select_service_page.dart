import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/main_frame.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

class SelectingServicePage extends StatefulWidget {
  const SelectingServicePage({super.key});

  @override
  State<SelectingServicePage> createState() => _SelectingServicePageState();
}
class _SelectingServicePageState extends State<SelectingServicePage> {
  late bool _loading;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이용하실 예약 서비스를\n선택해주세요.',
                  style: KR.title3,
                ),

                SizedBox(height: ratio.height * 68),

                _button(ServiceType.lectureRoom),

                SizedBox(height: ratio.height * 20),

                _button(ServiceType.aiSpace),

                SizedBox(height: ratio.height * 20),

                _button(ServiceType.computer)
              ]
            ),
          ),
        ),

        if (_loading)
          const ProgressScreen()
      ],
    );
  }

  Widget _button(ServiceType type) {
    late String path, name;
    switch (type) {
      case ServiceType.aiSpace:
        path = ImgPath.aiSpace;
        name = "AI 스페이스";
        break;
      case ServiceType.lectureRoom:
        path = ImgPath.lecture;
        name = "강의실";
        break;
      case ServiceType.computer:
        path = ImgPath.computer;
        name = "GPU 컴퓨터";
        break;
    }
    return InkWell(
      onTap: () => _onTap(type),
      splashColor: Colors.white.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: ratio.height * 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.fitWidth
            )
        ),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Ko',
              color: Colors.white,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
      ),
    );
  }

  void _onTap(ServiceType type) async {
    setState(() => _loading = true);
    service = type;
    reservates = await RestAPI.getAllReservation() ?? [];
    admits = await RestAPI.getAllAdmission() ?? [];
    myAdmits = await RestAPI.getMyAdmission() ?? [];
    setState(() {
      _loading = false;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainFrame()));
    });
  }
}
