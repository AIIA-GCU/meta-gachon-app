import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mata_gachon/pages/cube_page.dart';
import 'package:mata_gachon/pages/sign_in_page.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app/_export.dart';

import '../config/server/controller.dart';
import '../widgets/button.dart';
import '../widgets/small_widgets.dart';

/////////////////////////////////////////////////////////////////////////

class SignUpFrame extends StatefulWidget {
  const SignUpFrame({super.key});

  @override
  State<SignUpFrame> createState() => _SignUpFrameState();
}

class _SignUpFrameState extends State<SignUpFrame> {
  final _pageCtr = PageController();
  final picker = ImagePicker();
  List<XFile?> images = [];

  String buttonText = "다음 단계";
  bool nextStep = false;
  bool loading = false;
  int index = 0;

  String studentIdCardImage = "";
  String name = '김가천', stuNum = '202400001', major = '소프트웨어학과', phoneNumber = '01012345678';
  final pwCtr = TextEditingController();
  final pwCheckCtr = TextEditingController();
  bool discordant = false;

  @override
  void dispose() {
    _pageCtr.dispose();
    pwCtr.dispose();
    pwCheckCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (MediaQuery.of(context).viewInsets.bottom > 0) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 16),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: ratio.width * 8,
                        right: ratio.width * 16
                      ),
                      alignment: Alignment.centerLeft,
                      child: Icon(MGIcon.back),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageCtr,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TermAgreementPage(buttonActive: buttonActive),
                        PhoneCertifyPage(nextPage: (val, phoneNum){
                          onPressed(certificationNumber: val, phoneNumber: phoneNum);
                        }),
                        StudentCertifyPage(
                          selected: studentIdCardImage.isNotEmpty,
                          changeImage: openGallery
                        ),
                        CreateAccountPage(
                          openKeyboard: MediaQuery.of(context).viewInsets.bottom > 0,
                          discordant: discordant,
                          name: name,
                          id: stuNum,
                          pwCtr: pwCtr,
                          pwCheckCtr: pwCheckCtr,
                          textFieldChanged: () {
                            print(pwCtr.text);
                            print(pwCheckCtr.text);
                            if (pwCtr.text.isNotEmpty & pwCheckCtr.text.isNotEmpty) {
                              setState(() => nextStep = true);
                            }
                          },
                        ),
                        CubePage(
                            title: "회원가입이 완료되었습니다!",
                            content: "메타가천에 오신것을\n환영합니다!",
                            buttonText: buttonText,
                            nextPage: const SignInPage()
                        )
                      ]
                    )
                  ),
                  if (index != 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: CustomButtons.bottomButton(
                        buttonText,
                        MGColor.brandPrimary,
                        nextStep ? onPressed : null,
                        disableBackground: MGColor.base4
                      )
                    )
                ]
              ),
            ),
          ),
        ),
    
        if (loading)
          const ProgressScreen()
      ],
    );
  }

  onPressed({String? certificationNumber, String? phoneNumber}) async {
    switch (index) {
      case 0:
        setState(() => index++);
        await _pageCtr.animateToPage(1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease
        );
        break;
      case 1:
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
        }
        await RestAPI.cerifyCode(phoneNumber: phoneNumber!, certificationNumber: certificationNumber!);
        setState(() {
          index++;
          buttonText = "이미지 첨부하기";
          this.phoneNumber = phoneNumber;
        });
        await _pageCtr.animateToPage(2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease
        );
        break;
      case 2:
        if (studentIdCardImage.isEmpty) {
          openGallery();
        } else {
          try {
            final expension = studentIdCardImage.substring(studentIdCardImage.lastIndexOf('.'));
            final bytes = await File(studentIdCardImage).readAsBytes();
            Map<String, dynamic> response = await RestAPI.verifyStudent(imageFormat: expension, encodedImage: base64Encode(bytes));
            await _pageCtr.animateToPage(3,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease
            );
            setState(() {
              index++;
              name = response['name'];
              stuNum = response['studentNum'];
              major = response['major'];
              nextStep = false;
            });
          }
          catch(e) {
            rethrow;
          }
        }
        break;
      case 3:
        if (pwCtr.text.compareTo(pwCheckCtr.text) != 0) {
          setState(() => discordant = true);
        } else {
          await RestAPI.signUp(studentNum: stuNum, password: pwCtr.text, studentName: name, phoneNumber: this.phoneNumber, major: major);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const CubePage(
                title: "회원가입이 완료되었습니다!",
                content: "메타가천에 오신 것을\n환영합니다!",
                buttonText: "로그인하기",
                doPoppingPage: true,
              )
            )
          );
        }
    }
  }

  buttonActive(val) => setState(() => nextStep = val);
  Future<void> openGallery() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        studentIdCardImage = pickedFile.path;
        buttonText = "다음 단계";
      });
    }
  }
}

/////////////////////////////////////////////////////////////////////////

class TermAgreementPage extends StatefulWidget {
  const TermAgreementPage({
    super.key,
    required this.buttonActive
  });

  final Function(bool) buttonActive;

  @override
  _TermAgreementPageState createState() => _TermAgreementPageState();
}

class _TermAgreementPageState extends State<TermAgreementPage> {
  bool isChecked = false;
  bool isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 88),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ratio.width * 16),
            child: Text(
              "AIIA 서비스 이용약관에\n동의해주세요.",
              style: KR.title2,
            ),
          ),

          const Spacer(),

          TileButton(
              onTap: () {
                if (isChecked) {
                  widget.buttonActive(isChecked = false);
                } else {
                  _showTerms(Term.usingService);
                }
              },
              // padding: EdgeInsets.symmetric(
              //     horizontal: ratio.width * 16, vertical: 15),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      if (isChecked) {
                        setState(() => widget.buttonActive(isChecked = false));
                      } else {
                        _showTerms(Term.usingService);
                      }
                    },
                    activeColor: Color(0xff1762DB),
                  ),
                  Text('서비스 이용 약관 동의 (필수)', style: KR.subtitle4),
                ],
              )
          ),

          TileButton(
              onTap: () {
                if (isChecked2) {
                  widget.buttonActive(isChecked2 = false);
                } else {
                  _showTerms(Term.personalInfomationCollection);
                }
              },
              // padding: EdgeInsets.symmetric(
              //     horizontal: ratio.width * 16, vertical: 15),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked2,
                    onChanged: (bool? value) {
                      if (isChecked2) {
                        setState(() => widget.buttonActive(isChecked2 = false));
                      } else {
                        _showTerms(Term.personalInfomationCollection);
                      }
                    },
                    activeColor: MGColor.brandPrimary,
                  ),
                  Text('서비스 이용 약관 동의 (필수)', style: KR.subtitle4),
                ],
              )
          ),

          const Divider(
            color: MGColor.base6,
            height: 10,
            indent: 12,
            endIndent: 12,
            thickness: 1,
          ),

          TileButton(
              onTap: () async {
                if (isChecked & isChecked2) {
                  setState(() => widget.buttonActive(isChecked = isChecked2 = false));
                } else {
                  if (!isChecked) await _showTerms(Term.usingService);
                  if (!isChecked2) await _showTerms(Term.personalInfomationCollection);
                }
              },
              // padding: EdgeInsets.symmetric(
              //     horizontal: ratio.width * 16, vertical: 15),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked & isChecked2,
                    onChanged: (bool? value) async {
                      if (isChecked & isChecked2) {
                        setState(() => widget.buttonActive(isChecked = isChecked2 = false));
                      } else {
                        if (!isChecked) await _showTerms(Term.usingService);
                        if (!isChecked2) await _showTerms(Term.personalInfomationCollection);
                      }
                    },
                    activeColor: MGColor.brandPrimary,
                  ),
                  Text('전체 동의', style: KR.subtitle4),
                ],
              )
          )
        ],
      ),
    );
  }

  Future<void> _showTerms(Term term) async {
    switch (term) {
      case Term.usingService:
        await showModalBottomSheet(
            context: context,
            enableDrag: false,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
            barrierColor: Colors.black.withOpacity(0.25),
            backgroundColor: Colors.white,
            constraints: BoxConstraints(maxHeight: ratio.height * 612),
            builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(
                      ratio.width * 20, 30,
                      ratio.width * 20, 10
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title
                          Text('이용약관 동의 전문', style: KR.subtitle0),

                          /// Content
                          Expanded(
                            child: ShaderMask(
                              shaderCallback: hazySide,
                              blendMode: BlendMode.dstOut,
                              child: SizedBox(
                                height: ratio.height * 425,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ratio.height * 40),
                                  child: Text(
                                      usingServiceTerm,
                                      style: KR.parag2.copyWith(
                                          color: MGColor.base3),
                                      softWrap: true
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// Button
                          CustomButtons.bottomButton(
                            '확인',
                            MGColor.brandPrimary,
                            disableBackground: MGColor.base4,
                            () {
                              setState(() => isChecked = true);
                              Navigator.pop(context);
                            }
                          )
                        ]
                    )
                )
        ).then((value) => widget.buttonActive(isChecked & isChecked2));
        break;
      case Term.personalInfomationCollection:
        await showModalBottomSheet(
            context: context,
            enableDrag: false,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
            barrierColor: Colors.black.withOpacity(0.25),
            backgroundColor: Colors.white,
            constraints: BoxConstraints(maxHeight: ratio.height * 290),
            builder: (context) =>
                Padding(
                    padding: EdgeInsets.fromLTRB(
                      ratio.width * 20, 30,
                      ratio.width * 20, 10
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title
                          Text('개인정보 수집 및 이용 동의 전문', style: KR.subtitle0),

                          SizedBox(height: ratio.height * 40),

                          /// Content
                          Expanded(
                            child: Text(
                                personalInformationCollectionTerm,
                                style: KR.parag2.copyWith(color: MGColor.base3),
                                softWrap: true
                            ),
                          ),

                          // SizedBox(height: ratio.height * 30),

                          /// Button
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() => isChecked2 = true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: MGColor.brandPrimary,
                                  foregroundColor: Colors.white,
                                  fixedSize: Size(ratio.width * 358, 48),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))
                              ),
                              child: Text('확인', style: KR.subtitle4)
                          )
                        ]
                    )
                )
        ).then((value) => widget.buttonActive(isChecked & isChecked2));
        break;
    }
  }
}

/////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////

class PhoneCertifyPage extends StatefulWidget {
  const PhoneCertifyPage({super.key, required this.nextPage});

  final void Function(String, String) nextPage;

  @override
  State<PhoneCertifyPage> createState() => _PhoneCertifyPageState();
}

class _PhoneCertifyPageState extends State<PhoneCertifyPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String? phoneNumber, certificationNumber;
  bool validPhoneNumber = false, validCertificationNumber = false;

  String? buttonText1;
  int requestable = -1;
  int leftTime = -1;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        /// title
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 24),
          child: Text(
            "핸드폰으로 본인 인증을\n진행해주세요.",
            style: KR.title2,
          ),
        ),

        /// cellphone
        Container(
          width: ratio.width * 358,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MGColor.brandPrimary),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: ratio.width * 16, vertical: 13),
              hintText: '전화번호를 입력해주세요',
              hintStyle: KR.subtitle4.copyWith(
                color: MGColor.base4,
              ),
              border: InputBorder.none,
            ),
            onChanged: (val) {
              phoneNumber = val;
              setState(() {
                if (val.isNotEmpty) requestable = 1;
                else if (leftTime == -1) requestable = -1;
                else requestable = 0;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: requestable != 1 ? null : requestCertificationNumber,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: MGColor.brandPrimary,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: requestable == 0
                ? MGColor.brandTertiary : MGColor.base5,
            side: requestable != 0 ? null
                : const BorderSide(color: MGColor.brandPrimary),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            minimumSize: Size(ratio.width * 358, 48),
          ),
          child: Text(
            buttonText1 ?? "인증번호 발송",
            style: EN.subtitle3.copyWith(
              fontWeight: FontWeight.w700,
              color: requestable == 0
                  ? MGColor.brandPrimary : Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 32),

        /// certification
        if (requestable != -1 && leftTime != -1)
          Column(children: [
            Container(
              width: ratio.width * 358,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MGColor.brandPrimary),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: ratio.width * 16, vertical: 13),
                  hintText: '인증번호를 입력해주세요',
                  hintStyle: KR.subtitle4.copyWith(
                    color: MGColor.base4,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  certificationNumber = val;
                  setState(() {
                    validCertificationNumber = val.isNotEmpty;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            CustomButtons.bottomButton(
                '다음 단계',
                MGColor.brandPrimary,
                disableBackground: MGColor.base5,
                !validCertificationNumber ? null : () {
                  if (timer != null) timer!.cancel();
                  widget.nextPage(certificationNumber!, phoneNumber!);
                }
            )
          ])
      ]),
    );
  }

  requestCertificationNumber() {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
    }
    setState(() => requestable = 0);
    RestAPI.cerifyPhoneNumber(phoneNumber:phoneNumber!);
    leftTime = 300;
    buttonText1 = "인증번호 재전송 (${leftTime ~/ 60}분 ${leftTime % 60}초)";
    Timer.periodic(const Duration(seconds: 1), (timer) {
      this.timer = timer;
      if (--leftTime == 0) {
        requestable = 1;
        buttonText1 = "인증번호 재전송";
        timer.cancel();
      } else {
        buttonText1 = "인증번호 재전송 (${leftTime ~/ 60}분 ${leftTime % 60}초)";
      }
      setState(() {});
    });
  }
}

/////////////////////////////////////////////////////////////////////////

class StudentCertifyPage extends StatefulWidget {
  const StudentCertifyPage({
    super.key,
    required this.selected,
    required this.changeImage
  });

  final bool selected;
  final VoidCallback changeImage;

  @override
  State<StudentCertifyPage> createState() => _StudentCertifyPageState();
}

class _StudentCertifyPageState extends State<StudentCertifyPage> {
  final explain1 = "메타가천의 여러 기능들은\n가천대학교 학생만 사용할 수 있습니다!\n재학생 인증을 해주세요!";
  final explain2 = "[카카오워크 > 바로가기 > 모바일 신분증]으로\n이동해서 가천대학교 포탈에 접속하여\n해당 화면을 캡쳐하고, 위에 첨부해주세요";

  String imageName = "unselected";

  @override
  void didUpdateWidget(covariant StudentCertifyPage oldWidget) {
    if (widget.selected) imageName = "selected";
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("가천대학교 재학생 인증", style: KR.subtitle2),

          const SizedBox(height: 28),

          Text(explain1,
            textAlign: TextAlign.center,
            style: KR.parag2.copyWith(color: MGColor.base4)),

          const SizedBox(height: 44),

          Image.asset(
            "assets/images/$imageName.png",
            width: ratio.width * 232,
            height: ratio.height * 132,
          ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: widget.changeImage,
            child: Text("이미지 수정하기",
              style: KR.subtitle4.copyWith(
                decoration: TextDecoration.underline,
                color: widget.selected
                    ? MGColor.brandPrimary
                    : Colors.transparent,
                decorationColor: widget.selected
                    ? MGColor.brandPrimary
                    : Colors.transparent
              ),
            )
          ),

          const SizedBox(height: 45),

          Text(explain2,
            textAlign: TextAlign.center,
            style: KR.parag2.copyWith(color: MGColor.base4))
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({
    super.key,
    required this.openKeyboard,
    this.discordant = false,
    required this.name,
    required this.id,
    required this.pwCtr,
    required this.pwCheckCtr,
    required this.textFieldChanged
  });

  final bool openKeyboard;
  final bool discordant;
  final String name;
  final String id;
  final TextEditingController pwCtr;
  final TextEditingController pwCheckCtr;
  final VoidCallback textFieldChanged;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  var explain = "영문 대문자와 소문자, 숫자, 특수문자 중 2가지 이상을 조합하여\n6~20자로 입력해주세요.";

  bool openKeyboard = false;
  bool discordant = false;

  @override
  void didUpdateWidget(covariant CreateAccountPage oldWidget) {
    openKeyboard = widget.openKeyboard;
    if (discordant = widget.discordant) {
      explain = "비밀번호를 확인해주세요.";
    } else {
      explain = "영문 대문자와 소문자, 숫자, 특수문자 중 2가지 이상을 조합하여\n6~20자로 입력해주세요.";
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
      children: [
        /// title
        AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(
              top: openKeyboard ? 0 : 50,
              bottom: 12
          ),
          child: Text(
            "비밀번호를 설정해주세요.",
            style: KR.title2,
          ),
        ),

        /// 이름
        Text("이름", style: KR.parag1.copyWith(color: MGColor.base3)),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16, vertical: 13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MGColor.brandPrimary)
          ),
          alignment: Alignment.centerLeft,
          child: Text(widget.name, style: KR.subtitle4),
        ),

        AnimatedSize(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 150),
            child: SizedBox(
                height: openKeyboard ? 4 : 12
            )
        ),

        /// 학번 (ID)
        Text("학번(ID)", style: KR.parag1.copyWith(color: MGColor.base3)),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16, vertical: 13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MGColor.brandPrimary)
          ),
          alignment: Alignment.centerLeft,
          child: Text(widget.id, style: KR.subtitle4),
        ),

        AnimatedSize(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            height: openKeyboard ? 20 : 45
          )
        ),

        /// PW
        Container(
          width: ratio.width * 358,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MGColor.brandPrimary),
          ),
          child: TextField(
            controller: widget.pwCtr,
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: ratio.width * 16, vertical: 13),
              hintText: '비밀번호를 입력해주세요',
              hintStyle: KR.subtitle4.copyWith(
                color: MGColor.base4,
              ),
              border: InputBorder.none,
            ),
            onTap: () {
              setState(() => openKeyboard = true);
            },
            onChanged: (val) => widget.textFieldChanged(),
          ),
        ),

        const SizedBox(height: 10),

        /// PW 확인
        Container(
          width: ratio.width * 358,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: discordant
                ? MGColor.systemError : MGColor.brandPrimary
            ),
          ),
          child: TextField(
            controller: widget.pwCheckCtr,
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: ratio.width * 16, vertical: 13),
              hintText: '비밀번호를 다시 입력해주세요.',
              hintStyle: KR.subtitle4.copyWith(
                color: MGColor.base4,
              ),
              border: InputBorder.none,
            ),
            onTap: () {
              setState(() => openKeyboard = true);
            },
            onChanged: (val) {
              if (discordant) setState(() => discordant = false);
              widget.textFieldChanged();
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ratio.width * 16,
            vertical: 4
          ),
          child: Text(explain,
            style: KR.label2.copyWith(
              color: discordant
                  ? MGColor.systemError
                  : MGColor.brandPrimary
            ),
          ),
        )
      ]
    );
  }
  Future<void> trySignUp() async {

  }
}
