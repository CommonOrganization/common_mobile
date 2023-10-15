import 'package:common/constants/constants_enum.dart';
import 'package:common/models/notice/notice.dart';
import 'package:common/screens/setting/notice_detail_screen.dart';
import 'package:common/services/notice_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';

class NoticeScreen extends StatelessWidget {
  final NoticeType type;
  const NoticeScreen({Key? key, required this.type}) : super(key: key);

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
      body: FutureBuilder(
        future: NoticeService.getNoticeList(type: type.name),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Notice>? noticeList = snapshot.data;
            if (noticeList == null) return Container();
            return ListView(
              children: noticeList
                  .map(
                    (notice) => kNoticeCard(context, notice),
                  )
                  .toList(),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget kNoticeCard(BuildContext context, Notice notice) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoticeDetailScreen(
            type: type,
            notice: notice,
          ),
        ),
      ),
      child: Container(
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
        child: Row(
          children: [
            Expanded(
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
            SvgPicture.asset('assets/icons/svg/arrow_more_22px.svg'),
          ],
        ),
      ),
    );
  }
}
