import 'package:common/constants/constants_enum.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_category_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_content_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_title_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_type_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class OneDayGatheringUploadMainScreen extends StatefulWidget {
  const OneDayGatheringUploadMainScreen({Key? key}) : super(key: key);

  @override
  State<OneDayGatheringUploadMainScreen> createState() =>
      _OneDayGatheringUploadMainScreenState();
}

class _OneDayGatheringUploadMainScreenState
    extends State<OneDayGatheringUploadMainScreen> {
  int _pageIndex = 0;

  late GatheringType _gatheringType;
  late CommonCategory _gatheringMainCategory;
  late String _gatheringDetailCategory;
  late String _gatheringTitle;
  late String _gatheringContent;
  late String _gatheringMainImageUrl;
  late List<String> _gatheringImageUrlList;

  Widget getScreen() {
    switch (_pageIndex) {
      case 0:
        return OneDayGatheringTypeScreen(
          nextPressed: (GatheringType gatheringType) {
            setState(() {
              _pageIndex++;
              _gatheringType = gatheringType;
            });
          },
        );
      case 1:
        return OneDayGatheringCategoryScreen(
          nextPressed: (CommonCategory category, String detailCategory) {
            setState(() {
              _pageIndex++;
              _gatheringMainCategory = category;
              _gatheringDetailCategory = detailCategory;
            });
          },
        );
      case 2:
        return OneDayGatheringTitleScreen(
          nextPressed: (String title) {
            setState(() {
              _pageIndex++;
              _gatheringTitle = title;
            });
          },
        );
      case 3:
        return OneDayGatheringContentScreen(
          nextPressed: (String content,String mainImageUrl,List<String> imageUrlList) {
            setState(() {
              _pageIndex++;
              _gatheringContent = content;
              _gatheringMainImageUrl=mainImageUrl;
              _gatheringImageUrlList = imageUrlList;
            });
          },
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
        foregroundColor: kGrey363639Color,
        backgroundColor: kWhiteColor,
        leading: GestureDetector(
          onTap: () {
            if (_pageIndex == 0) {
              Navigator.pop(context);
              return;
            }
            setState(() => _pageIndex--);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: kGrey363639Color,
          ),
        ),
        elevation: 0,
      ),
      body: getScreen(),
    );
  }
}
