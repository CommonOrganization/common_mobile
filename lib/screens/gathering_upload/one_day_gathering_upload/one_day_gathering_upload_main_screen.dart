import 'dart:developer';
import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/screens/gathering_detail/one_day_gathering_detail/one_day_gathering_detail_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_capacity_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_category_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_content_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_recruit_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_schedule_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_tag_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_title_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_type_screen.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../models/one_day_gathering/one_day_gathering.dart';

class OneDayGatheringUploadMainScreen extends StatefulWidget {
  final OneDayGathering? gathering;
  const OneDayGatheringUploadMainScreen({super.key, this.gathering});

  @override
  State<OneDayGatheringUploadMainScreen> createState() =>
      _OneDayGatheringUploadMainScreenState();
}

class _OneDayGatheringUploadMainScreenState
    extends State<OneDayGatheringUploadMainScreen> {
  int _pageIndex = 0;

  late GatheringType _gatheringType;
  late String? _gatheringConnectedClubGatheringId;
  late bool _gatheringShowAllThePeople;
  late CommonCategory _gatheringMainCategory;
  late String _gatheringDetailCategory;
  late String _gatheringTitle;
  late String _gatheringContent;
  late String _gatheringMainImageUrl;
  late List _gatheringImageUrlList;
  late RecruitWay _gatheringRecruitWay;
  late String _gatheringRecruitQuestion;
  late int _gatheringCapacity;
  late DateTime _gatheringOpeningDate;
  late UserPlace _gatheringPlace;
  late String _gatheringPlaceDetail;
  late bool _isHaveEntryFee;
  late String _gatheringEntryFee;
  late List _gatheringTagList;

  Future<void> previewPressed(List tagList) async {
    try {
      _gatheringTagList = tagList;
      String? userId = context.read<UserController>().user?.id;
      if (userId == null) return;
      Map<String, dynamic> oneDayGatheringMap = {
        'type': _gatheringType.name,
        'connectedClubGatheringId': _gatheringConnectedClubGatheringId,
        'showAllThePeople': _gatheringShowAllThePeople,
        'category': _gatheringMainCategory.name,
        'detailCategory': _gatheringDetailCategory,
        'title': _gatheringTitle,
        'content': _gatheringContent,
        'mainImage': _gatheringMainImageUrl,
        'gatheringImage': _gatheringImageUrlList,
        'recruitWay': _gatheringRecruitWay.name,
        'recruitQuestion': _gatheringRecruitQuestion,
        'capacity': _gatheringCapacity,
        'openingDate': _gatheringOpeningDate.toString(),
        'place': {
          ..._gatheringPlace.toJson(),
          'detail': _gatheringPlaceDetail,
        },
        'isHaveEntryFee': _isHaveEntryFee,
        'entryFee': _isHaveEntryFee ? int.parse(_gatheringEntryFee) : 0,
        'tagList': _gatheringTagList,
      };
      /**
       * Map<String, dynamic> oneDayGatheringMap = {
          'type': _gatheringType.name,
          'clubGatheringId': _gatheringConnectedClubGatheringId,
          'showAllThePeople': _gatheringShowAllThePeople,
          'category': _gatheringMainCategory.name,
          'detailCategory': _gatheringDetailCategory,
          'title': _gatheringTitle,
          'content': _gatheringContent,
          'mainImage': _gatheringMainImageUrl,
          'imageList': _gatheringImageUrlList,
          'recruitWay': _gatheringRecruitWay.name,
          'recruitQuestion': _gatheringRecruitQuestion,
          'capacity': _gatheringCapacity,
          'openingDate': DateFormat('yyyy-MM-ddTHH:mm:ss').format(_gatheringOpeningDate),
          'place': {
          ..._gatheringPlace.toJson(),
          'detail': _gatheringPlaceDetail,
          },
          'haveEntryFee': _isHaveEntryFee,
          'entryFee': _isHaveEntryFee ? int.parse(_gatheringEntryFee) : 0,
          'tagList': _gatheringTagList,
          };
       */

      OneDayGathering gathering = OneDayGathering.fromJson({
        'id': 'preview',
        'organizerId': userId,
        ...oneDayGatheringMap,
        'timeStamp': DateTime.now().toString(),
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OneDayGatheringDetailScreen(
            gathering: gathering,
            isPreview: true,
          ),
        ),
      );
    } catch (e) {
      log('previewPressed failed : $e');
      showMessage(context, message: '입력한 정보를 다시 한번 확인해 주세요.');
    }
  }

  Future<void> updatePressed(List tagList) async {
    try {
      _gatheringTagList = tagList;
      String? userId = context.read<UserController>().user?.id;
      if (userId == null || widget.gathering == null) return;
      Map<String, dynamic> oneDayGatheringMap = {
        'type': _gatheringType.name,
        'connectedClubGatheringId': _gatheringConnectedClubGatheringId,
        'showAllThePeople': _gatheringShowAllThePeople,
        'category': _gatheringMainCategory.name,
        'detailCategory': _gatheringDetailCategory,
        'title': _gatheringTitle,
        'content': _gatheringContent,
        'mainImage': _gatheringMainImageUrl,
        'gatheringImage': _gatheringImageUrlList,
        'recruitWay': _gatheringRecruitWay.name,
        'recruitQuestion': _gatheringRecruitQuestion,
        'capacity': _gatheringCapacity,
        'openingDate': _gatheringOpeningDate.toString(),
        'place': {
          ..._gatheringPlace.toJson(),
          'detail': _gatheringPlaceDetail,
        },
        'isHaveEntryFee': _isHaveEntryFee,
        'entryFee': _isHaveEntryFee ? int.parse(_gatheringEntryFee) : 0,
        'tagList': _gatheringTagList,
      };

      OneDayGathering gathering = OneDayGathering.fromJson({
        'id': widget.gathering!.id,
        'organizerId': userId,
        ...oneDayGatheringMap,
        'timeStamp': DateTime.now().toString(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OneDayGatheringDetailScreen(
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
        return OneDayGatheringTypeScreen(
          gathering: widget.gathering,
          nextPressed: (GatheringType gatheringType,
              String? connectedClubGatheringId, bool showAllThePeople) {
            setState(() {
              _pageIndex++;
              _gatheringType = gatheringType;
              _gatheringConnectedClubGatheringId = connectedClubGatheringId;
              _gatheringShowAllThePeople = showAllThePeople;
            });
          },
        );
      case 1:
        return OneDayGatheringCategoryScreen(
          gathering: widget.gathering,
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
          gathering: widget.gathering,
          nextPressed: (String title) {
            setState(() {
              _pageIndex++;
              _gatheringTitle = title;
            });
          },
        );
      case 3:
        return OneDayGatheringContentScreen(
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
      case 4:
        return OneDayGatheringRecruitScreen(
          gathering: widget.gathering,
          nextPressed: (RecruitWay recruitWay, String recruitQuestion) {
            setState(() {
              _pageIndex++;
              _gatheringRecruitWay = recruitWay;
              _gatheringRecruitQuestion = recruitQuestion;
            });
          },
        );
      case 5:
        return OneDayGatheringCapacityScreen(
          gathering: widget.gathering,
          nextPressed: (int capacity) {
            setState(() {
              _pageIndex++;
              _gatheringCapacity = capacity;
            });
          },
        );
      case 6:
        return OneDayGatheringScheduleScreen(
          gathering: widget.gathering,
          nextPressed: (DateTime dateTime,
              UserPlace gatheringPlace,
              String gatheringPlaceDetail,
              bool isHaveEntryFee,
              String gatheringEntryFee) {
            setState(() {
              _pageIndex++;
              _gatheringOpeningDate = dateTime;
              _gatheringPlace = gatheringPlace;
              _gatheringPlaceDetail = gatheringPlaceDetail;
              _isHaveEntryFee = isHaveEntryFee;
              _gatheringEntryFee = gatheringEntryFee;
            });
          },
        );
      case 7:
        return OneDayGatheringTagScreen(
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
