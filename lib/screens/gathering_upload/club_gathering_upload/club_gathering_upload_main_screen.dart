import 'dart:developer';

import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_detail_screen.dart';
import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_category_screen.dart';
import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_location_screen.dart';
import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_title_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/local_utils.dart';
import 'club_gathering_capacity_screen.dart';
import 'club_gathering_content_screen.dart';
import 'club_gathering_recruit_screen.dart';
import 'club_gathering_tag_screen.dart';

class ClubGatheringUploadMainScreen extends StatefulWidget {
  final ClubGathering? gathering;
  const ClubGatheringUploadMainScreen({Key? key, this.gathering})
      : super(key: key);

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
  late List _gatheringImageUrlList;
  late RecruitWay _gatheringRecruitWay;
  late String _gatheringRecruitQuestion;
  late List<City> _gatheringCityList;
  late int _gatheringCapacity;
  late List _gatheringTagList;

  Future<void> previewPressed(List tagList) async {
    _gatheringTagList = tagList;
    String? userId = context.read<UserController>().user?.id;
    if (userId == null) return;
    Map<String, dynamic> clubGatheringDataMap = {
      'category': _gatheringMainCategory.name,
      'detailCategory': _gatheringDetailCategory,
      'title': _gatheringTitle,
      'content': _gatheringContent,
      'mainImage': _gatheringMainImageUrl,
      'gatheringImage': _gatheringImageUrlList,
      'recruitWay': _gatheringRecruitWay.name,
      'recruitQuestion': _gatheringRecruitQuestion,
      'cityList': _gatheringCityList.map((city) => city.name).toList(),
      'capacity': _gatheringCapacity,
      'tagList': _gatheringTagList,
      'memberList': [userId],
      'applicantList': [],
    };
    ClubGathering gathering = ClubGathering.fromJson({
      'id': 'preview',
      'organizerId': userId,
      ...clubGatheringDataMap,
      'timeStamp': DateTime.now().toString(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClubGatheringDetailScreen(gathering: gathering, isPreview: true),
      ),
    );
  }

  Future<void> updatePressed(List tagList) async {
    try {
      _gatheringTagList = tagList;
      String? userId = context.read<UserController>().user?.id;
      if (userId == null || widget.gathering == null) return;
      Map<String, dynamic> clubGatheringDataMap = {
        'category': _gatheringMainCategory.name,
        'detailCategory': _gatheringDetailCategory,
        'title': _gatheringTitle,
        'content': _gatheringContent,
        'mainImage': _gatheringMainImageUrl,
        'gatheringImage': _gatheringImageUrlList,
        'recruitWay': _gatheringRecruitWay.name,
        'recruitQuestion': _gatheringRecruitQuestion,
        'cityList': _gatheringCityList.map((city) => city.name).toList(),
        'capacity': _gatheringCapacity,
        'tagList': _gatheringTagList,
        'memberList': widget.gathering!.memberList,
        'applicantList': widget.gathering!.applicantList,
      };

      ClubGathering gathering = ClubGathering.fromJson({
        'id': widget.gathering!.id,
        'organizerId': userId,
        ...clubGatheringDataMap,
        'timeStamp': DateTime.now().toString(),
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClubGatheringDetailScreen(
            gathering: gathering,
            isPreview: true,
            isEdit: true,
          ),
        ),
      );
    } catch (e) {
      log('updatePressed failed : $e');
      showMessage(context, message: '입력한 정보를 다시 한번 확인해 주세요.');
    }
  }

  Widget getScreen() {
    switch (_pageIndex) {
      case 0:
        return ClubGatheringCategoryScreen(
          gathering: widget.gathering,
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
          gathering: widget.gathering,
          nextPressed: (String title) {
            setState(() {
              _pageIndex++;
              _gatheringTitle = title;
            });
          },
        );
      case 2:
        return ClubGatheringContentScreen(
          gathering: widget.gathering,
          nextPressed:
              (String content, String mainImageUrl, List imageUrlList) {
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
          gathering: widget.gathering,
          nextPressed: (RecruitWay recruitWay, String recruitQuestion) {
            setState(() {
              _pageIndex++;
              _gatheringRecruitWay = recruitWay;
              _gatheringRecruitQuestion = recruitQuestion;
            });
          },
        );
      case 4:
        return ClubGatheringLocationScreen(
          gathering: widget.gathering,
          nextPressed: (List<City> cityList) {
            setState(() {
              _pageIndex++;
              _gatheringCityList = cityList;
            });
          },
        );
      case 5:
        return ClubGatheringCapacityScreen(
          gathering: widget.gathering,
          nextPressed: (int capacity) {
            setState(() {
              _pageIndex++;
              _gatheringCapacity = capacity;
            });
          },
        );
      case 6:
        return ClubGatheringTagScreen(
          gathering: widget.gathering,
          previewPressed: (List tagList) => widget.gathering != null
              ? updatePressed(tagList)
              : previewPressed(tagList),
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
          behavior: HitTestBehavior.opaque,
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
            child: SvgPicture.asset(
              'assets/icons/svg/arrow_left_28px.svg',
              colorFilter: ColorFilter.mode(kFontGray800Color, BlendMode.srcIn),
            ),
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
