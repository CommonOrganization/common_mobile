import 'package:common/constants/constants_enum.dart';
import 'package:common/models/notice/notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';

class NoticeDetailScreen extends StatelessWidget {
  final NoticeType type;
  final Notice notice;
  const NoticeDetailScreen({
    Key? key,
    required this.type,
    required this.notice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          type.title,
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: kFontGray50Color,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${type.shortTitle} ${notice.title}',
                  style: TextStyle(
                    fontSize: 16,
                    height: 20 / 16,
                    letterSpacing: -0.5,
                    color: kFontGray800Color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    DateTime noticeDateTime =
                    DateTime.parse(notice.timeStamp);
                    return Text(
                      '${noticeDateTime.year}.${noticeDateTime.month.toString().padLeft(2, '0')}.${noticeDateTime.day.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: -0.5,
                        color: kFontGray600Color,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(notice.content.replaceAll('/ul', '\n')),
          ),
        ],
      ),
    );
  }
}
