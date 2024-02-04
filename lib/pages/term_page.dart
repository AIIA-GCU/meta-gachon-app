import 'package:flutter/material.dart';

import 'package:mata_gachon/config/variable.dart';

class TermPage extends StatelessWidget {
  TermPage({super.key, required Term term}) {
    switch (term) {
      case Term.usingService:
        this.title = "이용약관 동의 전문";
        this.content = USING_SERVICE_TERM;
        break;
      case Term.personalInfomationCollection:
        this.title = "개인정보 수집 및 이용 동의 전문";
        this.content = PERSONAL_INFORMATION_COLLECTION_TERM;
        break;
    }
  }

  late final String title, content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 42,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                  AppinIcon.back,
                  size: ratio.width * 24,
                  color: MGcolor.base4
              ),
            )
        ),
        body: Column(
            children: [
              /// Title
              Text(title, style: KR.subtitle0),

              SizedBox(height: ratio.height * 23),

              /// Content
              Expanded(
                child: ShaderMask(
                  shaderCallback: hazySide,
                  blendMode: BlendMode.dstOut,
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: ratio.width * 36,
                        vertical: ratio.height * 63
                    ),
                    child: Text(
                        content,
                        style: KR.parag2.copyWith(color: MGcolor.base3),
                        softWrap: true
                    ),
                  ),
                ),
              ),

              SizedBox(height: ratio.height * 23),
            ]
        )
    );
  }
}
