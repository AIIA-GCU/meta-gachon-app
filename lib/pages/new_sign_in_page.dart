
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';


class NewSign extends StatefulWidget {
  const NewSign({Key? key}) : super(key: key);

  @override
  _NewSignState createState() => _NewSignState();
}

class _NewSignState extends State<NewSign> {
  bool _isChecked = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ratio.height*88,
                      ),
                      Text("AIIA 서비스 이용약관에\n동의해주세요.", style: KR.title2,),
                      SizedBox(
                        height: ratio.height*400,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                                activeColor: Color(0xff1762DB),
                              ),
                              Text('서비스 이용 약관 동의 (필수)',
                                  style: KR.subtitle4 ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked2,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked2 = value!;
                                  });
                                },
                                activeColor: Color(0xff1762DB),
                              ),
                              Text('개인정보 수집 및 이용 동의 (필수)',
                                  style: KR.subtitle4 ),
                            ],
                          ),
                          Container(
                            child: Divider(
                              color: Color(0xffCDCDCD),
                              height: 20,
                              thickness: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked3,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked3 = value!;
                                    _isChecked = _isChecked2 = _isChecked3;

                                  });
                                },
                                activeColor: Color(0xff1762DB),
                              ),
                              Text('전체 동의',
                                  style: KR.subtitle4 ),
                            ],
                          ),
                          SizedBox(
                            height: ratio.height*15,
                          ),
                          ElevatedButton(

                            onPressed: _isChecked && _isChecked2
                                ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignNext()),
                              );
                            }
                                : null,
                            child: Text('다음 단계',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff1762DB),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              minimumSize: Size(ratio.width * 358, 48),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
        );
  }
}

class SignNext extends StatefulWidget {
  const SignNext({super.key});

  @override
  State<SignNext> createState() => _SignNextState();
}

class _SignNextState extends State<SignNext> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class FindId extends StatelessWidget {
  const FindId({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FindPw extends StatelessWidget {
  const FindPw({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
