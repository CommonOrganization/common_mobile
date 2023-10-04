import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/daily_upload/daily_upload_category_screen.dart';
import 'package:common/screens/daily_upload/daily_upload_content_screen.dart';
import 'package:common/screens/daily_upload/daily_upload_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants_colors.dart';
import 'daily_upload_image_screen.dart';
import 'daily_upload_tag_screen.dart';

class DailyUploadMainScreen extends StatefulWidget {
  const DailyUploadMainScreen({Key? key}) : super(key: key);

  @override
  State<DailyUploadMainScreen> createState() => _DailyUploadMainScreenState();
}

class _DailyUploadMainScreenState extends State<DailyUploadMainScreen> {
  int _pageIndex = 0;

  late CommonCategory _dailyMainCategory;
  late String _dailyDetailCategory;
  late DailyType _dailyType;
  late String? _dailyConnectedClubGatheringId;
  late String _dailyMainImage;
  late List _dailyImageList;
  late String _dailyContent;
  late List _dailyTagList;

  Widget getScreen() {
    switch (_pageIndex) {
      case 0:
        return DailyUploadCategoryScreen(
          nextPressed: (CommonCategory category, String detailCategory) =>
              setState(() {
            _dailyMainCategory = category;
            _dailyDetailCategory = detailCategory;
            _pageIndex++;
          }),
        );
      case 1:
        return DailyUploadTypeScreen(
          nextPressed:
              (DailyType dailyType, String? dailyConnectedClubGatheringId) =>
                  setState(() {
            _dailyType = dailyType;
            _dailyConnectedClubGatheringId = dailyConnectedClubGatheringId;
            _pageIndex++;
          }),
        );
      case 2:
        return DailyUploadImageScreen(
          nextPressed: (String dailyMainImage, List dailyImageList) =>
              setState(() {
            _dailyMainImage = dailyMainImage;
            _dailyImageList = dailyImageList;
            _pageIndex++;
          }),
        );
      case 3:
        return DailyUploadContentScreen(
          nextPressed: (String dailyContent) =>
              setState(() {
                _dailyContent = dailyContent;
                _pageIndex++;
              }),
        );
      case 4:
        return DailyUploadTagScreen(
          nextPressed: (List tagList) =>
              setState(() {
                _dailyTagList = tagList;
              }),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () {
            if (_pageIndex == 0) {
              Navigator.pop(context);
              return;
            }
            setState(() => _pageIndex--);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset('assets/icons/svg/close_28px.svg'),
          ),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      ),
      body: getScreen(),
    );
  }
}
