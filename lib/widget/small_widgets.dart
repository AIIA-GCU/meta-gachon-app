///
/// 타인 인증 리스트 위젯 (AnotherGuyWidget)
/// 내 인증 리스트 위젯(myReservationWidget)
/// 팝업 위젯 (popUpWidget)
/// 예약 취소 위젯 (CancelPopUp)
///

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mata_gachon/config/server.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widget/popup.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ratio.height * 100,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          width: ratio.width * 40,
          height: ratio.width * 40,
          child: CircularProgressIndicator(color: MGcolor.base6)),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width,
      height: screen.height,
      color: Colors.black.withOpacity(0.25),
      alignment: Alignment.center,
      child: SizedBox(
          width: ratio.width * 48,
          height: ratio.width * 48,
          child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}
class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(children: [
        Icon(AppinIcon.not, color: MGcolor.base4, size: 24),
        // 읽지 않은 알림이 있을 때, 보이기
        FutureBuilder<bool?>(
          future: RestAPI.hasUnopendNotice(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return Positioned(
                  top: 1,
                  left: 1,
                  child: CircleAvatar(
                      radius: 4,
                      backgroundColor: MGcolor.base9,
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: MGcolor.system_error,
                      )
                  )
              );
            } else {
              return SizedBox.shrink();
            }
          }
        )
      ]),
    );
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem({
    required this.uid,
    required this.name,
    required this.stuNum,
    required this.room,
    required this.date,
    required this.time,
    // required this.membersInfo,
    this.review,
    this.photo
  }) {
    isReservation = photo == null;
  }

  final int uid;
  final String name;
  final int stuNum;
  final String room;
  final String date;
  final String time;
  final String? review;
  final Uint8List? photo;

  late final bool isReservation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCard(context),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ratio.height * 4),
        padding: EdgeInsets.symmetric(
            horizontal: ratio.width * 16, vertical: ratio.height * 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room, style: KR.subtitle1),
                SizedBox(height: ratio.height * 8),
                Text(date, style: KR.parag2.copyWith(color: MGcolor.base3)),
                Text(time, style: KR.parag2.copyWith(color: MGcolor.base3))
              ],
            ),
            if (isReservation)
              Transform.translate(
                offset: Offset(0, -(ratio.height * 21)),
                child: Transform.rotate(
                  angle: pi,
                  child: Icon(
                    AppinIcon.back,
                    size: 24,
                    color: MGcolor.base3,
                  ),
                ),
              )
            else
              Container(
                  width: ratio.height * 74,
                  height: ratio.height * 74,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(photo!),
                      fit: BoxFit.fill
                    )
                  )
              )
          ],
        ),
      ),
    );
  }

  void showCard(BuildContext ctx) => showDialog(
      context: ctx,
      builder: (context) {
        if (photo == null) {
          return ReservationPopup(
              Reservate(uid, '$stuNum $name', room, date, time));
        } else {
          return AdmissionPopup(
              Admit(uid, '$stuNum $name', room, date, time, review!, photo!));
        }
      }
  );
}

class TileButtonCard extends StatelessWidget {
  const TileButtonCard({
    super.key,
    this.background,
    this.shape,
    this.margin,
    this.padding,
    required this.items
  });

  final Color? background;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<TileButton> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin != null ? margin!
          : EdgeInsets.symmetric(vertical: ratio.height * 8),
      child: Material(
        color: background != null ? background: Colors.white,
        shape: shape != null ? shape
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: padding != null ? padding!
              : EdgeInsets.symmetric(vertical: ratio.height * 8),
          child: Column(children: items),
        ),
      ),
    );
  }
}

class TileButton extends StatelessWidget {
  const TileButton({
    super.key,
    this.onTap,
    this.alignment,
    this.padding,
    this.borderRadius,
    required this.child
  });

  final VoidCallback? onTap;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        alignment: alignment,
        child: child,
      ),
    );
  }
}
