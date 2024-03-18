import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';

class TermPage extends StatelessWidget {
  TermPage({super.key, required Term term}) {
    switch (term) {
      case Term.usingService:
        title = "이용약관 동의 전문";
        content = usingServiceTerm;
        break;
      case Term.personalInfomationCollection:
        title = "개인정보 수집 및 이용 동의 전문";
        content = personalInformationCollectionTerm;
        break;
    }
  }

  late final String title, content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 48,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                  MGIcon.back,
                  size: ratio.width * 24,
                  color: MGColor.base4
              ),
            )
        ),
        body: SafeArea(
          child: Column(
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
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: ratio.width * 36,
                          vertical: ratio.height * 63
                      ),
                      child: Text(
                          content,
                          style: KR.parag2.copyWith(color: MGColor.base3),
                          softWrap: true
                      ),
                    ),
                  ),
                ),

                SizedBox(height: ratio.height * 23),
              ]
          ),
        )
    );
  }
}
