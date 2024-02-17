import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/widgets/text_field.dart';

import '../widgets/button.dart';
import '../widgets/popup_widgets.dart';
import '../widgets/small_widgets.dart';

/// 회원가입 프로세스를 위한 프레임
class SignUpFrame extends StatefulWidget {
  const SignUpFrame({super.key});

  @override
  State<SignUpFrame> createState() => _SignUpFrameState();
}
class _SignUpFrameState extends State<SignUpFrame> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageCtr = PageController();
  final TextEditingController
  _nameEditCtr = TextEditingController(),
  _idEditCtr = TextEditingController(),
  _pwEditCtr = TextEditingController();

  late List<Widget> _items;
  late int _index;
  late bool _canNext, _loading;

  @override
  void initState() {
    super.initState();
    _index = 0;
    _canNext = _loading = false;
    _items = [
      _AgreePge(allowToMovePage: (valid)
      => setState(() => _canNext = valid)),
      _EnterNamePage(
        nameEditCtr: _nameEditCtr,
        allowToMovePage: (valid) => setState(() => _canNext = valid)
      ),
      _EnterIdPwPage(
        idEditCtr: _idEditCtr,
        pwEditCtr: _pwEditCtr,
        allowToMovePage: (valid) {
          debugPrint(valid.toString());
          setState(() => _canNext = valid);
        },
      )
    ];
  }

  @override
  void dispose() {
    _pageCtr.dispose();
    _nameEditCtr.dispose();
    _idEditCtr.dispose();
    _pwEditCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///
        GestureDetector(
          onTap: () {
            if (MediaQuery.of(context).viewInsets.bottom > 0) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size(
                  double.infinity,
                  ratio.height * 100
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                    bottom: ratio.height * 22),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                      MGIcon.back,
                      size: ratio.width * 24,
                      color: MGColor.base4
                  ),
                )
              )
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                /// 메인 콘텐츠
                Form(
                  key: _formKey,
                  child: Expanded(child: PageView(
                    controller: _pageCtr,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _items
                  )),
                ),

                /// 버튼
                Padding(
                  padding: EdgeInsets.only(
                    top: ratio.height * 10,
                    bottom: ratio.height * 50
                  ),
                  child: CustomButtons.bottomButton(
                    '다음 단계',
                    MGColor.brand1Primary,
                    () => _canNext ? _moveToPage() : null,
                    MGColor.base6
                  )
                )
              ]
            )
          ),
        ),

        ///
        if (_loading)
          const ProgressScreen()
      ],
    );
  }

  void _moveToPage() async {
    debugPrint("current page: $_index");
    if ((_index + 1) < _items.length) {
      setState(() {
        _pageCtr.animateToPage(
            ++_index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease
        );
        _canNext = false;
      });
    } else {
      try {
        /// 로딩 중에 하는 일
        /// - ID & PW 유효성 검사
        /// - 회원가입 시도
        setState(() => _loading = true);
        if (_formKey.currentState!.validate() == false) {
          throw Exception("\n[Error] failed validating!");
        }
        if (await RestAPI.signUp(
            name: _nameEditCtr.text,
            id: _idEditCtr.text,
            pw: _pwEditCtr.text) == false) {
          throw Exception("\n[Error] failed Creating Account!");
        }
        
        
        /// 성공하면 다음 페이지로 이동함
        setState(() {
          _loading = false;
          Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  fullscreenDialog: false,
                  transitionsBuilder: slideRigth2Left,
                  pageBuilder: (context, anime, secondAnime) => const _FirstCompleteSignUpPage()
              )
          );
        });
      } catch(e) {
        /// 실패하면 팝업으로 알려줌
        setState(() {
          _loading = false;
          if (e.toString().contains("Account")) {
            showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.25),
                builder: (context) => CommentPopup(
                    title: "계정 생성 중 오류가 발생했습니다!",
                    onPressed: () => Navigator.pop(context)
                )
            );
          }
        });
      }
    }
  }
}

/// 약관 & 개인정보 수집 동의 페이지
class _AgreePge extends StatefulWidget {
  const _AgreePge({required this.allowToMovePage});

  final Function(bool) allowToMovePage;

  @override
  State<_AgreePge> createState() => _AgreePgeState();
}
class _AgreePgeState extends State<_AgreePge> {
  late List<bool> _list;

  @override
  void initState() {
    super.initState();
    _list = [false, false];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Padding(
          padding: EdgeInsets.only(left: ratio.width * 16),
          child: Text(
            'AIIA 서비스 이용약관에\n동의해주세요.',
            style: KR.title2.copyWith(letterSpacing: 0.36)
          ),
        ),
        
        /// Checkboxs
        Padding(
          padding: EdgeInsets.only(
            left: ratio.width * 2.6,
            right: ratio.width * 8.4
          ),
          child: IntrinsicWidth(
            stepWidth: double.infinity,
            child: Column(
              children: [
                /// 이용약관
                TileButton(
                  onTap: () {
                    if (_list[0]) {
                      setState(() => widget.allowToMovePage(_list[0] = false));
                    } else {
                      _showTerms(Term.usingService);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _list[0],
                        activeColor: MGColor.brand1Primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: const BorderSide(width: 1.6, color: MGColor.base6)),
                        onChanged: (val) {}
                      ),
                      Expanded(child: Text('이용약관 동의', style: KR.subtitle2)),
                      Transform.rotate(
                        angle: pi,
                        child: const Icon(MGIcon.back, size: 24),
                      )
                    ]
                  )
                ),

                /// 개인정보 수집 및 이용
                TileButton(
                  onTap: () {
                    if (_list[1]) {
                      setState(() => widget.allowToMovePage(_list[1] = false));
                    } else {
                      _showTerms(Term.personalInfomationCollection);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: _list[1],
                          activeColor: MGColor.brand1Primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(width: 1.6, color: MGColor.base6)),
                          onChanged: (val) {}
                      ),
                      Expanded(child: Text(
                          '개인정보 수집 및 이용 동의', style: KR.subtitle2)),
                      Transform.rotate(
                        angle: pi,
                        child: const Icon(MGIcon.back, size: 24),
                      )
                    ]
                  ),
                ),

                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 13,
                  endIndent: 5,
                  color: MGColor.base6,
                ),

                /// 전체 동의
                TileButton(
                  onTap: () {
                    if (_list[0] & _list[1]) {
                      setState(() => widget.allowToMovePage(_list[0] = _list[1] = false));
                    } else if (!_list[0] & !_list[1]) {
                      _showTerms(null);
                    }
                    else if (!_list[0]) {
                      _showTerms(Term.usingService);
                    }
                    else {
                      _showTerms(Term.personalInfomationCollection);
                    }
                  },
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                            value: _list[0] && _list[1],
                            activeColor: MGColor.brand1Primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: const BorderSide(width: 1.6, color: MGColor.base6)),
                            onChanged: (val) {}
                        ),
                        Expanded(child: Text('전체 동의', style: KR.subtitle2)),
                        Transform.rotate(
                          angle: pi,
                          child: const Icon(MGIcon.back, size: 24),
                        )
                      ]
                  ),
                )
              ]
            ),
          ),
        )
      ]
    );
  }

  Future<void> _showTerms(Term? term) async {
    switch (term) {
      case Term.usingService:
        showModalBottomSheet(
            context: context,
            enableDrag: false,
            isScrollControlled: true,
            barrierColor: Colors.black.withOpacity(0.25),
            backgroundColor: Colors.white,
            constraints: BoxConstraints(maxHeight: ratio.height * 814),
            builder: (context) => Padding(
                padding: EdgeInsets.only(top: ratio.height * 108),
                child: Column(
                    children: [
                      /// Title
                      Text('이용약관 동의 전문', style: KR.subtitle0),

                      SizedBox(height: ratio.height * 29),

                      /// Content
                      ShaderMask(
                        shaderCallback: hazySide,
                        blendMode: BlendMode.dstOut,
                        child: SizedBox(
                          height: ratio.height * 495,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: ratio.width * 61,
                                vertical: ratio.height * 60
                            ),
                            child: Text(
                                usingServiceTerm,
                                style: KR.parag2.copyWith(color: MGColor.base3),
                                softWrap: true
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: ratio.height * 30),

                      /// Button
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => _list[0] = true);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MGColor.brand1Primary,
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
        ).then((value) => widget.allowToMovePage(_list[0] & _list[1]));
        break;
      case Term.personalInfomationCollection:
        showModalBottomSheet(
            context: context,
            enableDrag: false,
            isScrollControlled: true,
            barrierColor: Colors.black.withOpacity(0.25),
            backgroundColor: Colors.white,
            constraints: BoxConstraints(maxHeight: ratio.height * 520),
            builder: (context) => Padding(
                padding: EdgeInsets.only(top: ratio.height * 108),
                child: Column(
                    children: [
                      /// Title
                      Text('개인정보 수집 및 이용 동의 전문', style: KR.subtitle0),

                      SizedBox(height: ratio.height * 60),

                      /// Content
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ratio.width * 61
                        ),
                        child: Text(
                            personalInformationCollectionTerm,
                            style: KR.parag2.copyWith(color: MGColor.base3),
                            softWrap: true
                        ),
                      ),

                      SizedBox(height: ratio.height * 71),

                      /// Button
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => _list[1] = true);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MGColor.brand1Primary,
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
        ).then((value) => widget.allowToMovePage(_list[0] & _list[1]));
        break;
      default:
        showModalBottomSheet(
            context: context,
            enableDrag: false,
            isScrollControlled: true,
            barrierColor: Colors.black.withOpacity(0.25),
            backgroundColor: Colors.white,
            constraints: BoxConstraints(maxHeight: ratio.height * 814),
            builder: (context) => Padding(
                padding: EdgeInsets.only(top: ratio.height * 108),
                child: Column(
                    children: [
                      /// Title
                      Text('이용약관 동의 전문', style: KR.subtitle0),

                      SizedBox(height: ratio.height * 29),

                      /// Content
                      ShaderMask(
                        shaderCallback: hazySide,
                        blendMode: BlendMode.dstOut,
                        child: SizedBox(
                          height: ratio.height * 495,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: ratio.width * 61,
                                vertical: ratio.height * 60
                            ),
                            child: Text(
                                usingServiceTerm,
                                style: KR.parag2.copyWith(color: MGColor.base3),
                                softWrap: true
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: ratio.height * 30),

                      /// Button
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => _list[0] = true);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MGColor.brand1Primary,
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
        ).then((_) {
          return showModalBottomSheet(
              context: context,
              enableDrag: false,
              isScrollControlled: true,
              barrierColor: Colors.black.withOpacity(0.25),
              backgroundColor: Colors.white,
              constraints: BoxConstraints(maxHeight: ratio.height * 520),
              builder: (context) => Padding(
                  padding: EdgeInsets.only(top: ratio.height * 108),
                  child: Column(
                      children: [
                        /// Title
                        Text('개인정보 수집 및 이용 동의 전문', style: KR.subtitle0),

                        SizedBox(height: ratio.height * 60),

                        /// Content
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ratio.width * 61
                          ),
                          child: Text(
                              personalInformationCollectionTerm,
                              style: KR.parag2.copyWith(color: MGColor.base3),
                              softWrap: true
                          ),
                        ),

                        SizedBox(height: ratio.height * 71),

                        /// Button
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() => _list[1] = true);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MGColor.brand1Primary,
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
          ).then((value) => widget.allowToMovePage(_list[0] & _list[1]));
        });
        break;
    }
  }
}

/// 이름 입력 페이지
class _EnterNamePage extends StatelessWidget {
  const _EnterNamePage({
    required this.nameEditCtr,
    required this.allowToMovePage
  });

  final TextEditingController nameEditCtr;
  final Function(bool) allowToMovePage;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Padding(
            padding: EdgeInsets.only(left: ratio.width * 16),
            child: Text(
              'AIIA 서비스 이용약관에\n동의해주세요.',
              style: KR.title2.copyWith(letterSpacing: 0.36)
            ),
          ),

          SizedBox(height: ratio.height * 53),

          /// Name Input
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 18),
            child: Text('이름', style: KR.parag2.copyWith(color: MGColor.base5)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              ratio.width * 16,
              ratio.height * 15,
              ratio.height * 16,
              0
            ),
            child: TextField(
              controller: nameEditCtr,
              cursorColor: Colors.black,
              style: KR.subtitle1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: ratio.width * 12,
                    vertical: ratio.height * 12
                ),
                hintText: '예) 김가천',
                hintStyle: KR.subtitle4.copyWith(color: MGColor.base5),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: MGColor.base5),
                  borderRadius: BorderRadius.circular(8)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: MGColor.base5, width: 2),
                  borderRadius: BorderRadius.circular(8)
                ),

              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]'))
              ],
              onChanged: (val) => allowToMovePage(val.isNotEmpty)
            ),
          ),
        ]
    );
  }
}

/// ID & PW 입력 페이지
class _EnterIdPwPage extends StatefulWidget {
  const _EnterIdPwPage({
    required this.idEditCtr,
    required this.pwEditCtr,
    required this.allowToMovePage
  });

  final TextEditingController idEditCtr, pwEditCtr;
  final Function(bool) allowToMovePage;

  @override
  State<_EnterIdPwPage> createState() => _EnterIdPwPageState();
}
class _EnterIdPwPageState extends State<_EnterIdPwPage> {
  String? _tempId, _tempPw, _tempPwCheck;
  String? _idError, _pwError;
  bool pw1 = false, pw2 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Padding(
            padding: EdgeInsets.only(left: ratio.width * 16),
            child: Text(
                '아이디와 비밀번호를\n입력해주세요.',
                style: KR.title2.copyWith(letterSpacing: 0.36)
            ),
          ),

          AnimatedSize(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
            child: SizedBox(height:
            ratio.height * (MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 52)),
          ),

          /// Id Input
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ratio.width * 18),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('아이디', style: KR.subtitle3),
                Text(
                  _idError ?? '',
                  style: KR.label2.copyWith(color: MGColor.systemError)
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ratio.width * 16,
                ratio.height * 15,
                ratio.height * 16,
                0
            ),
            child: LongTextField(
                controller: widget.idEditCtr,
                password: false,
                hint: '5~20자의 영문 소문자, 숫자와 특수기호 입력',
                error: _idError,
                onChanged: (val) {
                  _tempId = val;
                  _allowToMovePage();
                },
                validator: (val) {
                  if (!(5 <= val!.length && val.length <= 20)) {
                    setState(() => _idError = "아이디는 5 ~ 20자입니다.");
                    return _idError;
                  }
                  RestAPI.checkOverlappingId(id: val).then((valid) {
                    setState(() {
                      if (valid) {
                        _idError = "중복된 아이디입니다.";
                      } else {
                        _idError = null;
                      }
                    });
                    return _idError;
                  });
                }
            ),
          ),

          AnimatedSize(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
            child: SizedBox(height:
            ratio.height * (MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 37)),
          ),

          /// Pw Input
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ratio.width * 18),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('비밀번호', style: KR.subtitle3),
                Text(
                  _pwError ?? '',
                  style: KR.label2.copyWith(color: MGColor.systemError)
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ratio.width * 16,
                ratio.height * 15,
                ratio.height * 16,
                0
            ),
            child: LongTextField(
              controller: widget.pwEditCtr,
              password: true,
              hint: '8~16자의 영문 대/소문자, 숫자, 특수문자 입력 가능',
              error: _pwError,
              shownPassword: !pw1,
              onTapToShowPassword: (val) => setState(() => pw1 = val),
              onChanged: (val) {
                _tempPw = val;
                _allowToMovePage();
              },
              validator: (val) {
                if (!(8 <= val!.length && val.length <= 16)) {
                  return _pwError = "비밀번호는 8 ~ 16자입니다.";
                } else if (_tempPw != _tempPwCheck) {
                  debugPrint("$_tempPw != $_tempPwCheck");
                  return _pwError = "비밀번호가 동일하지 않습니다.";
                } else {
                  return null;
                }
              },
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ratio.width * 16,
                ratio.height * 15,
                ratio.height * 16,
                0
            ),
            child: LongTextField(
              password: true,
              hint: '비밀번호 재입력',
              error: _pwError,
              shownPassword: !pw2,
              onTapToShowPassword: (val) => setState(() => pw2 = val),
                onChanged: (val) => setState(() {
                  _tempPwCheck = val;
                  _allowToMovePage();
                }),
                validator: (val) {
                  if (_tempPw != _tempPwCheck) {
                    return _pwError = "비밀번호가 동일하지 않습니다.";
                  } else {
                    return null;
                  }
                }
            )
          ),
        ]
    );
  }
  
  void _allowToMovePage() {
    widget.allowToMovePage(
      _tempId != null && _tempId!.isNotEmpty
      && _tempPw != null && _tempPw!.isNotEmpty
      && _tempPwCheck != null && _tempPwCheck!.isNotEmpty
    );
  }
}

/// 1차 회원가입 완료 페이지
class _FirstCompleteSignUpPage extends StatelessWidget {
  const _FirstCompleteSignUpPage();

  static late Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [MGColor.base8, MGColor.base9],
                stops: [0.0, 0.5])),
        child: Stack(
          children: [
            /// 배경 이미지
            Positioned(
              child: Image.asset(
                ImgPath.onBoarding,
                width: screenSize.width,
                height: ratio.height * 800,
              ),
            ),

            /// 텍스트
            Positioned(
              bottom: ratio.height * 304,
              width: screenSize.width,
              child: Center(
                child: Text(
                  '회원가입이 거의 다 되었어요!',
                  style: KR.subtitle2,
                ),
              ),
            ),
            Positioned(
              bottom: ratio.height * 247,
              width: screenSize.width,
              child: Center(
                child: Text(
                  '재학생이라면 재학생 인증,\n신입생 및 외부인은 인증되지 않은 회원으로 넘어가주세요.',
                  textAlign: TextAlign.center,
                  style: KR.parag2.copyWith(color: MGColor.base4),
                ),
              ),
            ),

            /// 버튼
            Positioned(
              bottom: ratio.height * 24,
              width: screenSize.width,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _moveToAiiaAuthPage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGColor.brand1Primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: Size(ratio.width * 358, 48),
                    ),
                    child: Text(
                      '재학생 인증',
                      style: EN.subtitle2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: ratio.height * 16),
                  ElevatedButton(
                    onPressed: () => _backToSignInPage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGColor.brand1Secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: Size(ratio.width * 358, 48),
                    ),
                    child: Text(
                      '인증되지 않은 학생입니다.',
                      style: EN.subtitle2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveToAiiaAuthPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const _GachonStudentCertificationPage()));
  }
  
  void _backToSignInPage(BuildContext context) {
    Navigator.pop(context);
  }
}

/// 재학생 인증 페이지
class _GachonStudentCertificationPage extends StatefulWidget {
  const _GachonStudentCertificationPage();

  @override
  State<_GachonStudentCertificationPage> createState() => _GachonStudentCertificationPageState();
}
class _GachonStudentCertificationPageState extends State<_GachonStudentCertificationPage> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  bool _buttonEnabled = false;
  bool isPasswordVisible = false;
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    idController.addListener(updateLoginButtonState);
    pwController.addListener(updateLoginButtonState);
  }

  void updateLoginButtonState() {
    setState(() {
      _buttonEnabled =
          idController.text.isNotEmpty && pwController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          ///
          Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// logo & text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(ImgPath.schoolSymbol),
                      SizedBox(height: ratio.height * 8),
                      Text('재학생 인증', style: TextStyle(
                        height: 2.4,
                        fontSize: ratio.height * 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      )),
                      Text(
                        '가천대학교 계정으로 로그인을 해주세요.',
                        style: KR.label2.copyWith(color: MGColor.base4),
                      ),
                    ],
                  ),

                  AnimatedSize(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(height:
                    ratio.height * (MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 72)),
                  ),

                  /// input
                  Form(
                    key: key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ratio.width * 358,
                          child: LongTextField(
                            controller: idController,
                            password: false,
                            hint: '아이디 입력',
                            error: null,
                            onChanged: (val) {},
                            validator: (val) {
                              return val == null ? '' : null;
                            },
                          )
                        ),
                        SizedBox(height: ratio.height * 10),
                        Container(
                          width: ratio.width * 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: MGColor.base6),
                          ),
                          child: Stack(
                            children: [
                              TextField(
                                controller: pwController,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: '비밀번호 입력',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: ratio.width * 12,
                                      vertical: ratio.height * 12
                                  ),
                                  hintStyle: KR.subtitle3.copyWith(
                                    color: MGColor.base4,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: GestureDetector(
                                  onTapDown: (tapDetails) => setState(() => isPasswordVisible = true),
                                  onTapUp: (tapDetails) => setState(() => isPasswordVisible = false),
                                  onTapCancel: () => setState(() => isPasswordVisible = false),
                                  behavior: HitTestBehavior.translucent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ratio.width * 12,
                                        vertical: 14
                                    ),
                                    child: Icon(isPasswordVisible
                                        ? MGIcon.eyeOn
                                        : MGIcon.eyeOff,
                                      color: MGColor.base4,
                                      size: ratio.width * 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ratio.height * 4),
                        Text(
                            errorMessage,
                            style: KR.label2.copyWith(color: MGColor.systemError)
                        ),
                      ],
                    ),
                  ),

                  AnimatedSize(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(height:
                    ratio.height * (MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 68)),
                  ),

                  /// button
                  ElevatedButton(
                    onPressed: _buttonEnabled ? tryLogin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGColor.school,
                      disabledBackgroundColor: MGColor.base6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: Size(ratio.width * 358, ratio.height * 56),
                    ),
                    child: Text(
                      '로그인',
                      style: EN.subtitle2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          ///
          if (isLoading)
            const ProgressScreen()
        ],
      ),
    );
  }

  /// using api
  Future<void> tryLogin() async {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
    }
    _floatSignUpPage();
  }

  void _floatSignUpPage() {
    Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          fullscreenDialog: false,
          transitionsBuilder: slideRigth2Left,
          pageBuilder: (context, anime, secondAnime) => const _SecondCompleteSignUpPage(),
        )
    );
  }
}

/// 2차 회원가입 완료 페이지
class _SecondCompleteSignUpPage extends StatelessWidget {
  const _SecondCompleteSignUpPage();

  static late Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [MGColor.base8, MGColor.base9],
                stops: [0.0, 0.5])),
        child: Stack(
          children: [
            /// 배경 이미지
            Positioned(
              child: Image.asset(
                ImgPath.onBoarding,
                width: screenSize.width,
                height: ratio.height * 800,
              ),
            ),

            /// 텍스트
            Positioned(
              bottom: ratio.height * 284,
              width: screenSize.width,
              child: Center(
                child: Text(
                  '회원가입이 완료되었습니다!',
                  style: KR.subtitle2,
                ),
              ),
            ),
            Positioned(
              bottom: ratio.height * 247,
              width: screenSize.width,
              child: Center(
                child: Text(
                  '메타 가천에 오신 것을 환영합니다.',
                  textAlign: TextAlign.center,
                  style: KR.parag2.copyWith(color: MGColor.base4),
                ),
              ),
            ),

            /// 버튼
            Positioned(
              bottom: ratio.height * 24,
              width: screenSize.width,
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _backToSignInPage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGColor.brand1Primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: Size(ratio.width * 358, 48),
                  ),
                  child: Text(
                    '로그인',
                    style: EN.subtitle2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _backToSignInPage(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
