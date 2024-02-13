import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widgets/popup_widgets.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

enum FindProcess { certificateStudent, findingId, foundId, changePw }

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
  late FindProcess _current;

  String? _aiiaId, _aiiaPw, _gachonId, _gachonPw;

  @override
  void initState() {
    _index = 0;
    _canNext = _loading = false;

    if (widget.isFindingId) {
      _current = FindProcess.certificateStudent;
      _items = [
        CertificateStudentPage(
          idEditCtr: _idEditCtr,
          pwEditCtr: _pwEditCtr,
          allowToMovePage: _allowToMovePage
        ),
        FoundIdPage(aiiaId: _aiiaId),
        ChangePwPage(
          aiiaId: _aiiaId,
          pwEditCtr: _pwEditCtr,
          allowToMovePage: _allowToMovePage
        )
      ];
    } else {
      _current = FindProcess.certificateStudent;
      _items = [
        FindingIdPage(
            idEditCtr: _idEditCtr,
            allowToMovePage: _allowToMovePage
        ),
        CertificateStudentPage(
            idEditCtr: _idEditCtr,
            pwEditCtr: _pwEditCtr,
            allowToMovePage: _allowToMovePage
        ),
        ChangePwPage(
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

    if (_current == FindProcess.foundId) {
      containerHeight = 112;
      buttonText = '로그인';
    } else {
      containerHeight = 48;
      buttonText = '확인';
    }

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
                            AppinIcon.back,
                            size: ratio.width * 24,
                            color: MGcolor.base4
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
                          physics: NeverScrollableScrollPhysics(),
                          children: _items
                      )),
                    ),

                    /// 버튼
                    AnimatedContainer(
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 500),
                      height: containerHeight,
                      margin: EdgeInsets.only(
                          top: ratio.height * 10,
                          bottom: ratio.height * 50
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => _current = FindProcess.changePw);
                                _pageCtr.animateToPage(
                                  ++_index,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MGcolor.brand1Secondary,
                                disabledBackgroundColor: MGcolor.base6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                minimumSize: Size(ratio.width * 358, 48),
                              ),
                              child: Text(
                                '비밀번호 찾기',
                                style: EN.subtitle2.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          
                          Align(
                            alignment: Alignment.topCenter,
                            child: ElevatedButton(
                              onPressed: _canNext ? _moveToPage : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MGcolor.brand1Primary,
                                disabledBackgroundColor: MGcolor.base6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                minimumSize: Size(ratio.width * 358, 48),
                              ),
                              child: Text(
                                buttonText,
                                style: EN.subtitle2.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]
              )
          ),
        ),

        ///
        if (_loading)
          ProgressScreen()
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
      case FindProcess.certificateStudent:
        setState(() => _loading = true);
        _certificateStudent();
        break;
      case FindProcess.findingId:
        setState(() => _loading = true);
        _certificateAiiaId();
        break;
      case FindProcess.foundId:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case FindProcess.changePw:
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
          duration: Duration(milliseconds: 300),
          curve: Curves.ease
        );
        _current = widget.isFindingId
            ? FindProcess.foundId
            : FindProcess.changePw;
        _idEditCtr.clear();
        _pwEditCtr.clear();
      });
    } else {
      setState(() => _loading = false);
      showDialog(
        context: context,
        barrierColor: MGcolor.barrier,
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
          duration: Duration(milliseconds: 300),
          curve: Curves.ease
        );
        _current = FindProcess.certificateStudent;
        _idEditCtr.clear();
      });
    } else {
      setState(() => _loading = false);
      showDialog(
          context: context,
          barrierColor: MGcolor.barrier,
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
        barrierColor: MGcolor.barrier,
        builder: (context) => CommentPopup(
          title: '비밀번호가 재설정 되었습니다.',
          buttonColor: MGcolor.brand1Primary,
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst)
        )
      );
    }
  }
}

class CertificateStudentPage extends StatefulWidget {
  const CertificateStudentPage({
    super.key,
    required this.idEditCtr,
    required this.pwEditCtr,
    required this.allowToMovePage
  });

  final TextEditingController idEditCtr, pwEditCtr;
  final void Function(bool) allowToMovePage;

  @override
  State<CertificateStudentPage> createState() => _CertificateStudentPageState();
}
class _CertificateStudentPageState extends State<CertificateStudentPage> {

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
                    style: KR.label2.copyWith(color: MGcolor.systemError)
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
            child: TextFormField(
                controller: widget.idEditCtr,
                style: KR.subtitle1,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: ratio.width * 16,
                      vertical: ratio.height * 12
                  ),
                  hintText: '가천대학교 아이디 입력',
                  hintStyle: KR.parag2.copyWith(color: MGcolor.base5),
                  errorText: _pwError,
                  errorStyle: TextStyle(fontSize: 0),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: MGcolor.base5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: MGcolor.base6, width: 2)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: MGcolor.systemError)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: MGcolor.systemError, width: 2)),
                ),
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
                    style: KR.label2.copyWith(color: MGcolor.systemError)
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
            child: Stack(
              children: [
                TextFormField(
                  controller: widget.pwEditCtr,
                  obscureText: pw,
                  style: KR.subtitle1,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: ratio.width * 16,
                        vertical: ratio.height * 12
                    ),
                    hintText: '가천대학교 비밀번호 입력',
                    hintStyle: KR.parag2.copyWith(color: MGcolor.base5),
                    errorText: _pwError,
                    errorStyle: TextStyle(fontSize: 0),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.base5)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.base5, width: 2)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.systemError)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.systemError, width: 2)),
                  ),
                  onChanged: (val) {
                    _tempPw = val;
                    _allowToMovePage();
                  },
                  validator: (val) {
                    if (!(8 <= val!.length && val.length <= 16)) {
                      return _pwError = "비밀번호는 8 ~ 16자입니다.";
                    }  else return null;
                  },
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTapDown: (tapDetails) => setState(() => pw = true),
                    onTapUp: (tapDetails) => setState(() => pw = false),
                    onTapCancel: () => setState(() => pw = false),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ratio.width * 12,
                          vertical: 14
                      ),
                      child: Icon(pw
                          ? AppinIcon.eye_on
                          : AppinIcon.eye_off,
                        color: MGcolor.base4,
                        size: ratio.width * 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

class FindingIdPage extends StatefulWidget {
  const FindingIdPage({
    super.key,
    required this.idEditCtr,
    required this.allowToMovePage
  });

  final TextEditingController idEditCtr;
  final void Function(bool) allowToMovePage;

  @override
  State<FindingIdPage> createState() => _FindingIdPageState();
}
class _FindingIdPageState extends State<FindingIdPage> {
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
                  style: KR.label2.copyWith(color: MGcolor.systemError)
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
          child: TextFormField(
              controller: widget.idEditCtr,
              style: KR.subtitle1,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: ratio.width * 16,
                    vertical: ratio.height * 12
                ),
                hintText: 'AIIA 아이디 입력',
                hintStyle: KR.parag2.copyWith(color: MGcolor.base5),
                errorText: _idError,
                errorStyle: TextStyle(fontSize: 0),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: MGcolor.base5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: MGcolor.base5, width: 2)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: MGcolor.systemError)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: MGcolor.systemError, width: 2)),
              ),
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

class FoundIdPage extends StatelessWidget {
  const FoundIdPage({super.key, required this.aiiaId});

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
            border: Border.all(color: MGcolor.base5)
          ),
          child: Text(
            aiiaId ?? 'hello world',
            style: EN.subtitle1.copyWith(color: MGcolor.brand1Primary)
          )
        ),
      ],
    );
  }
}

class ChangePwPage extends StatefulWidget {
  const ChangePwPage({
    super.key,
    required this.aiiaId,
    required this.pwEditCtr,
    required this.allowToMovePage
  });

  final String? aiiaId;
  final TextEditingController pwEditCtr;
  final void Function(bool) allowToMovePage;

  @override
  State<ChangePwPage> createState() => _ChangePwPageState();
}
class _ChangePwPageState extends State<ChangePwPage> {
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
            duration: Duration(milliseconds: 300),
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
                  color: MGcolor.base8,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MGcolor.base5)
              ),
              child: Text(
                  widget.aiiaId ?? 'hello world',
                  style: EN.subtitle1.copyWith(color: MGcolor.base4)
              )
          ),

          AnimatedSize(
            curve: Curves.ease,
            duration: Duration(milliseconds: 300),
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
                    style: KR.label2.copyWith(color: MGcolor.systemError)
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
            child: Stack(
              children: [
                TextFormField(
                  controller: widget.pwEditCtr,
                  obscureText: !pw1,
                  style: KR.subtitle1,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: ratio.width * 16,
                        vertical: ratio.height * 12
                    ),
                    hintText: '새 비밀번호',
                    hintStyle: KR.parag2.copyWith(color: MGcolor.base5),
                    errorText: _pwError,
                    errorStyle: TextStyle(fontSize: 0),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.base5)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.base5, width: 2)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.systemError)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MGcolor.systemError, width: 2)),
                  ),
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
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTapDown: (tapDetails) => setState(() => pw1 = true),
                    onTapUp: (tapDetails) => setState(() => pw1 = false),
                    onTapCancel: () => setState(() => pw1 = false),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ratio.width * 12,
                          vertical: 14
                      ),
                      child: Icon(pw1
                          ? AppinIcon.eye_on
                          : AppinIcon.eye_off,
                        color: MGcolor.base4,
                        size: ratio.width * 20,
                      ),
                    ),
                  ),
                ),
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
            child: Stack(
              children: [
                TextFormField(
                    obscureText: !pw2,
                    style: KR.subtitle1,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: ratio.width * 16,
                          vertical: ratio.height * 12
                      ),
                      hintText: '새 비밀번호 재입력',
                      hintStyle: KR.parag2.copyWith(color: MGcolor.base5),
                      errorText: _pwError,
                      errorStyle: TextStyle(fontSize: 0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: MGcolor.base5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: MGcolor.base5, width: 2)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: MGcolor.systemError)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: MGcolor.systemError, width: 2)),
                    ),
                    onChanged: (val) => setState(() {
                      _tempPwCheck = val;
                      _allowToMovePage();
                    }),
                    validator: (val) {
                      if (!(8 <= val!.length && val.length <= 16)) {
                        return _pwError = "비밀번호는 8 ~ 16자입니다.";
                      } else if (_tempPw != _tempPwCheck) {
                        debugPrint("$_tempPw != $_tempPwCheck");
                        return _pwError = "비밀번호가 동일하지 않습니다.";
                      } else {
                        return null;
                      }
                    }
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTapDown: (tapDetails) => setState(() => pw2 = true),
                    onTapUp: (tapDetails) => setState(() => pw2 = false),
                    onTapCancel: () => setState(() => pw2 = false),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ratio.width * 12,
                          vertical: 14
                      ),
                      child: Icon(pw2
                          ? AppinIcon.eye_on
                          : AppinIcon.eye_off,
                        color: MGcolor.base4,
                        size: ratio.width * 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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