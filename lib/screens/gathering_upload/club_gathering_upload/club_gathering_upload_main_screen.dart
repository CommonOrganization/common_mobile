import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_category_screen.dart';
import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_title_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import 'club_gathering_capacity_screen.dart';
import 'club_gathering_content_screen.dart';
import 'club_gathering_recruit_screen.dart';
import 'club_gathering_tag_screen.dart';

class ClubGatheringUploadMainScreen extends StatefulWidget {
  const ClubGatheringUploadMainScreen({Key? key}) : super(key: key);

  @override
  State<ClubGatheringUploadMainScreen> createState() =>
      _ClubGatheringUploadMainScreenState();
}

class _ClubGatheringUploadMainScreenState
    extends State<ClubGatheringUploadMainScreen> {
  int _pageIndex = 0;

  late CommonCategory _gatheringMainCategory;
  late String _gatheringDetailCategory;
  late String _gatheringTitle;
  late String _gatheringContent;
  late String _gatheringMainImageUrl;
  late List<String> _gatheringImageUrlList;
  late RecruitWay _gatheringRecruitWay;
  late String _gatheringRecruitQuestion;
  late int _gatheringCapacity;
  late List<String> _gatheringTagList;

  Future<void> previewPressed(List<String> tagList) async {
    _gatheringTagList = tagList;
    Map<String, dynamic> clubGatheringDataMap = {
      'category': _gatheringMainCategory.name,
      'detailCategory': _gatheringDetailCategory,
      'title': _gatheringTitle,
      'content': _gatheringContent,
      'mainImageUrl': _gatheringMainImageUrl,
      'gatheringImageUrlList': _gatheringImageUrlList,
      'recruitWay': _gatheringRecruitWay.name,
      'recruitQuestion': _gatheringRecruitQuestion,
      'capacity': _gatheringCapacity,
      'tagList': _gatheringTagList,
    };
    print(clubGatheringDataMap);
  }

  Widget getScreen() {
    switch (_pageIndex) {
      case 0:
        return ClubGatheringCategoryScreen(
          nextPressed: (CommonCategory category, String detailCategory) {
            setState(() {
              _pageIndex++;
              _gatheringMainCategory = category;
              _gatheringDetailCategory = detailCategory;
            });
          },
        );
      case 1:
        return ClubGatheringTitleScreen(
          nextPressed: (String title) {
            setState(() {
              _pageIndex++;
              _gatheringTitle = title;
            });
          },
        );
      case 2:
        return ClubGatheringContentScreen(
          nextPressed:
              (String content, String mainImageUrl, List<String> imageUrlList) {
            setState(() {
              _pageIndex++;
              _gatheringContent = content;
              _gatheringMainImageUrl = mainImageUrl;
              _gatheringImageUrlList = imageUrlList;
            });
          },
        );
      case 3:
        return ClubGatheringRecruitScreen(
          nextPressed: (RecruitWay recruitWay, String recruitQuestion) {
            setState(() {
              _pageIndex++;
              _gatheringRecruitWay = recruitWay;
              _gatheringRecruitQuestion = recruitQuestion;
            });
          },
        );
      case 4:
        return ClubGatheringCapacityScreen(
          nextPressed: (int capacity) {
            setState(() {
              _pageIndex++;
              _gatheringCapacity = capacity;
            });
          },
        );
      case 5:
        return ClubGatheringTagScreen(
            previewPressed: (List<String> tagList) => previewPressed(tagList));
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
