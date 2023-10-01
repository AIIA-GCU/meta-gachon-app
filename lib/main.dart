import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "메타-가천",
      home: LoginPage(),
    );
  }
}

// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String id = "";
  String pw = "";
  List<String> error = ["ID/PW를 입력하세요", "존재하지 않는 ID 입니다", "PW가 틀렸습니다"];

  int valid = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Form(
                      key: formKey,
                      child: Column(children: [
                        // ID
                        renderTextFormField(
                            label: "ID",
                            onSave: (val) => id = val!,
                            validator: (val) =>
                                val!.isEmpty ? "ID를 입력하세요" : null),
                        // PW
                        renderTextFormField(
                            label: "PW",
                            onSave: (val) => pw = val!,
                            validator: (val) =>
                                val!.isEmpty ? "PW를 입력하세요" : null),
                        // 로그인
                        ElevatedButton(
                          onPressed: () {
                            // 수정 필요
                            if (formKey.currentState?.validate() == true) {
                              print("valid");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Info(
                                          name: "",
                                          stu_number: "",
                                          depart: "")));
                            } else
                              print("not valid");
                          },
                          child: Text("로그인"),
                        ),
                        // 오류 상황
                        Text(error[valid])
                      ]),
                    )))));
  }

  renderTextFormField(
      {required String label,
      required void Function(String?)? onSave,
      required String? Function(String?)? validator}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w700)),
        TextFormField(
          onSaved: onSave,
          validator: validator,
          obscureText: label == "PW" ? true : false,
        )
      ]),
    );
  }
}

// 정보 페이지
class Info extends StatelessWidget {
  const Info(
      {super.key,
      required this.name,
      required this.stu_number,
      required this.depart});

  final String name;
  final String stu_number;
  final String depart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
              width: 300,
              height: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 이름
                    Row(children: [
                      Text('이름', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(width: 10),
                      Text(name)
                    ]),
                    SizedBox(height: 10),
                    // 학번
                    Row(children: [
                      Text('학번', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(width: 10),
                      Text(name)
                    ]),
                    SizedBox(height: 10),
                    // 학과
                    Row(children: [
                      Text('학과', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(width: 10),
                      Text(name)
                    ])
                  ])),
        ),
      ),
    );
  }
}
