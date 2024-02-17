import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/widgets/button.dart';
import 'package:mata_gachon/widgets/text_field.dart';

import '../widgets/popup_widgets.dart';
import '../widgets/small_widgets.dart';

enum _FindProcess { certificateStudent, findingId, foundId, changePw }

class FindIdPwFrame extends StatefulWidget {
  const FindIdPwFrame({
    super.key,
    required this.isFindingId
  });

  final bool isFindingId;

  @override
  State<FindIdPwFrame> createState() => _FindIdPwFrameState();
}
class _FindIdPwFrameState extends State<FindIdPwFrame> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageCtr = PageController();
  final TextEditingController
  _idEditCtr = TextEditingController(),
  _pwEditCtr = TextEditingController();

  late List<Widget> _items;
  late int _index;
  late bool _canNext, _loading;
  late _FindProcess _current;

  String? _aiiaId, _aiiaPw, _gachonId, _gachonPw;

  @override
  void initState() {
    _index = 0;
    _canNext = _loading = false;

    if (widget.isFindingId) {
      _current = _FindProcess.certificateStudent;
      _items = [
        _CertificateStudentPage(
          idEditCtr: _idEditCtr,
          pwEditCtr: _pwEditCtr,
          allowToMovePage: _allowToMovePage
        ),
        _FoundIdPage(aiiaId: _aiiaId),
        _ChangePwPage(
          aiiaId: _aiiaId,
          pwEditCtr: _pwEditCtr,
          allowToMovePage: _allowToMovePage
        )
      ];
    } else {
      _current = _FindProcess.certificateStudent;
      _items = [
        _FindingIdPage(
            idEditCtr: _idEditCtr,
            allowToMovePage: _allowToMovePage
        ),
        _CertificateStudentPage(
            idEditCtr: _idEditCtr,
            pwEditCtr: _pwEditCtr,
            allowToMovePage: _allowToMovePage
        ),
        _ChangePwPage(
            aiiaId: _aiiaId,
            pwEditCtr: _pwEditCtr,
            allowToMovePage: _allowToMovePage
        )
      ];
    }

    super.initState();
  }

  @override
  void dispose() {
    _pageCtr.dispose();
    _idEditCtr.dispose();
    _pwEditCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late double containerHeight;
    late String buttonText;

    if (_current == _FindProcess.foundId) {
      containerHeight = 112;
      buttonText = '로그인';
    } else {
      containerHeight = 48;
      buttonText = '확인';
    }

    return Stack(
      children: [
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
                    AnimatedContainer(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 500),
                      height: containerHeight,
                      margin: EdgeInsets.only(
                          top: ratio.height * 10,
                          bottom: ratio.height * 50
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CustomButtons.bottomButton(
                              '비밀번호 찾기',
                              MGColor.brand1Primary,
                              () {
                                setState(() => _current = _FindProcess.changePw);
                                _pageCtr.animateToPage(
                                  ++_index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease
                                );
                              },
                              MGColor.base6
                            )
                          ),
                          
                          Align(
                            alignment: Alignment.topCenter,
                            child: CustomButtons.bottomButton(
                              buttonText,
                              MGColor.brand1Primary,
                              () => _canNext ? _moveToPage() : null,
                              MGColor.base6
                            )
                          )
                        ],
                      ),
                    )
                  ]
              )
          ),
        ),

        if (_loading)
          const ProgressScreen()
      ],
    );
  }

  void _allowToMovePage(bool val) => setState(() => _canNext = val);

  void _moveToPage() {
    if (_formKey.currentState!.validate() == false) {
      setState(() {});
      return;
    }

    switch (_current) {
      case _FindProcess.certificateStudent:
        setState(() => _loading = true);
        _certificateStudent();
        break;
      case _FindProcess.findingId:
        setState(() => _loading = true);
        _certificateAiiaId();
        break;
      case _FindProcess.foundId:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case _FindProcess.changePw:
        setState(() => _loading = true);
        _changePw();
        break;
    }
  }

  void _certificateStudent() async {
    _gachonId = _idEditCtr.text;
    _gachonPw = _pwEditCtr.text;

    if (true) {
      setState(() {
        _loading = false;
        _pageCtr.animateToPage(
          ++_index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease
        );
        _current = widget.isFindingId
            ? _FindProcess.foundId
            : _FindProcess.changePw;
        _idEditCtr.clear();
        _pwEditCtr.clear();
      });
    } else {
      setState(() => _loading = false);
      showDialog(
        context: context,
        barrierColor: MGColor.barrier,
        builder: (context) => CommentPopup(
          title: '확인되지 않은 학생 정보입니다.',
          onPressed: () => Navigator.pop(context)
        )
      );
    }
  }

  void _certificateAiiaId() async {
    _aiiaId = _idEditCtr.text;

    if (true) {
      setState(() {
        _loading = false;
        _pageCtr.animateToPage(
          ++_index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease
        );
        _current = _FindProcess.certificateStudent;
        _idEditCtr.clear();
      });
    } else {
      setState(() => _loading = false);
      showDialog(
          context: context,
          barrierColor: MGColor.barrier,
          builder: (context) => CommentPopup(
              title: '확인되지 않은 아이디입니다.',
              onPressed: () => Navigator.pop(context)
          )
      );
    }
  }

  void _changePw() async {
    if (true) {
      setState(() => _loading = false);
      showDialog(
        context: context,
        barrierColor: MGColor.barrier,
        builder: (context) => CommentPopup(
          title: '비밀번호가 재설정 되었습니다.',
          buttonColor: MGColor.brand1Primary,
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst)
        )
      );
    }
  }
}

class _CertificateStudentPage extends StatefulWidget {
  const _CertificateStudentPage({
    super.key,
    required this.idEditCtr,
    required this.pwEditCtr,
    required this.allowToMovePage
  });

  final TextEditingController idEditCtr, pwEditCtr;
  final void Function(bool) allowToMovePage;

  @override
  State<_CertificateStudentPage> createState() => _CertificateStudentPageState();
}
class _CertificateStudentPageState extends State<_CertificateStudentPage> {

  static String? _tempId, _tempPw;
  static String? _idError, _pwError;
  static bool pw = false;

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
                '본인 인증을 위한\n재학생 인증을 해주세요.',
                style: KR.title2.copyWith(letterSpacing: 0.36)
            ),
          ),

          SizedBox(height: ratio.height * 52),

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
            child:
            LongTextField(
                controller: widget.idEditCtr,
                password: false,
                hint: '가천대학교 아이디 입력',
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
                },
            ),
          ),

          SizedBox(height: ratio.height * 37),

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
              shownPassword: pw,
              hint: '가천대학교 비밀번호 입력',
              error: _pwError,
              onTapToShowPassword: (val) => setState(() => pw = val),
              onChanged: (val) {
                _tempPw = val;
                _allowToMovePage();
              },
              validator: (val) {
                if (!(8 <= val!.length && val.length <= 16)) {
                  return _pwError = "비밀번호는 8 ~ 16자입니다.";
                }  else {
                  return null;
                }
              },
            )
          ),
        ]
    );
  }

  void _allowToMovePage() {
    widget.allowToMovePage(
        _tempId != null && _tempId!.isNotEmpty
        && _tempPw != null && _tempPw!.isNotEmpty
    );
  }
}

class _FindingIdPage extends StatefulWidget {
  const _FindingIdPage({
    super.key,
    required this.idEditCtr,
    required this.allowToMovePage
  });

  final TextEditingController idEditCtr;
  final void Function(bool) allowToMovePage;

  @override
  State<_FindingIdPage> createState() => _FindingIdPageState();
}
class _FindingIdPageState extends State<_FindingIdPage> {
  static String? _tempId;
  static String? _idError;

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
              '비밀번호를 찾고자하는\nAIIA 아이디를 입력해주세요.',
              style: KR.title2.copyWith(letterSpacing: 0.36)
          ),
        ),

        SizedBox(height: ratio.height * 52),

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
              hint: 'AIIA 아이디 입력',
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
      ],
    );
  }

  void _allowToMovePage() {
    widget.allowToMovePage(_tempId != null && _tempId!.isNotEmpty);
  }
}

class _FoundIdPage extends StatelessWidget {
  const _FoundIdPage({super.key, required this.aiiaId});

  final String? aiiaId;

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
              '회원님의 정보와 일치하는\nAIIA 아이디입니다.',
              style: KR.title2.copyWith(letterSpacing: 0.36)
          ),
        ),

        SizedBox(height: ratio.height * 85),

        /// Id
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: ratio.width * 16),
          padding: EdgeInsets.symmetric(
            horizontal: ratio.width * 16,
            vertical: ratio.height * 10
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MGColor.base5)
          ),
          child: Text(
            aiiaId ?? 'hello world',
            style: EN.subtitle1.copyWith(color: MGColor.brand1Primary)
          )
        ),
      ],
    );
  }
}

class _ChangePwPage extends StatefulWidget {
  const _ChangePwPage({
    super.key,
    required this.aiiaId,
    required this.pwEditCtr,
    required this.allowToMovePage
  });

  final String? aiiaId;
  final TextEditingController pwEditCtr;
  final void Function(bool) allowToMovePage;

  @override
  State<_ChangePwPage> createState() => _ChangePwPageState();
}
class _ChangePwPageState extends State<_ChangePwPage> {
  String? _tempPw, _tempPwCheck;
  String? _pwError;
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
                '안전한 비밀번호로\n변경해주세요.',
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
            child: Text('아이디', style: KR.subtitle3),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(
                ratio.width * 16,
                ratio.height * 14,
                ratio.width * 16,
                0
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: ratio.width * 16,
                  vertical: ratio.height * 10
              ),
              decoration: BoxDecoration(
                  color: MGColor.base8,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MGColor.base5)
              ),
              child: Text(
                  widget.aiiaId ?? 'hello world',
                  style: EN.subtitle1.copyWith(color: MGColor.base4)
              )
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
              shownPassword: pw1,
              hint: '새 비밀번호',
              error: _pwError,
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
              shownPassword: pw2,
              hint: '새 비밀번호 재입력',
              error: _pwError,
              onTapToShowPassword: (val) => setState(() => pw2 = val),
              onChanged: (val) {
                _tempPwCheck = val;
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
        ]
    );
  }

  void _allowToMovePage() {
    widget.allowToMovePage(
        _tempPw != null && _tempPw!.isNotEmpty
        && _tempPwCheck != null && _tempPwCheck!.isNotEmpty
    );
  }
}