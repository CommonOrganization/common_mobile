import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_connected_daily_contents.dart';
import 'package:common/screens/gathering_detail/club_gathering_detail/club_gathering_connected_gathering_contents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/recruit_answer/recruit_answer.dart';
import '../../../services/club_gathering_service.dart';
import '../../../services/gathering_service.dart';
import '../../../services/recruit_answer_service.dart';
import '../../../utils/local_utils.dart';
import '../../../widgets/bottom_sheets/recruit_question_bottom_sheet.dart';
import '../components/gathering_button.dart';
import '../components/gathering_sliver_appbar.dart';
import '../gathering_applicant_screen.dart';
import 'club_gathering_basic_contents.dart';

class ClubGatheringDetailScreen extends StatefulWidget {
  final ClubGathering gathering;
  final bool isPreview;
  final bool isEdit;
  const ClubGatheringDetailScreen({
    Key? key,
    required this.gathering,
    this.isPreview = false,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<ClubGatheringDetailScreen> createState() =>
      _ClubGatheringDetailScreenState();
}

class _ClubGatheringDetailScreenState extends State<ClubGatheringDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _showAppbarBlack = false;
  int _headerIndex = 0;

  final int _size = 300;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onUpdate);
  }

  void onUpdate() async {
    if (_scrollController.offset < _size && _showAppbarBlack) {
      setState(() => _showAppbarBlack = false);
    }
    if (_scrollController.offset > _size && !_showAppbarBlack) {
      setState(() => _showAppbarBlack = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(onUpdate);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> applyPressed() async {
    String? userId = context.read<UserController>().user?.id;
    if (userId == null) return;
    if (_loading) return;
    _loading = true;
    try {
      String? recruitWayString = await GatheringService.get(
          category: kClubGatheringCategory,
          id: widget.gathering.id,
          field: 'recruitWay');
      if (recruitWayString == null) return;
      RecruitWay recruitWay =
          RecruitWayExtenstion.getRecruitWay(recruitWayString);
      //승인제의 경우 계정의 질문/응답이 필요함
      if (recruitWay == RecruitWay.approval) {
        String? recruitQuestion = await GatheringService.get(
            category: kClubGatheringCategory,
            id: widget.gathering.id,
            field: 'recruitQuestion');

        if (recruitQuestion == null) return;
        if (!mounted) return;
        String? answer = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: RecruitQuestionBottomSheet(
                gatheringId: widget.gathering.id,
                userId: userId,
                question: recruitQuestion),
          ),
        );
        //응답을 적어여하는데 그냥 뒤로가는경우 여기에 해당
        _loading = false;
        if (answer == null) return;
        RecruitAnswer recruitAnswer = RecruitAnswer(
          gatheringId: widget.gathering.id,
          userId: userId,
          question: recruitQuestion,
          answer: answer,
          timeStamp: DateTime.now().toString(),
        );
        await RecruitAnswerService.uploadRecruitAnswer(
            recruitAnswer: recruitAnswer);
      }

      bool applySuccess = await ClubGatheringService.applyGathering(
          id: widget.gathering.id, userId: userId,recruitWay:recruitWay.name,);
      if (!mounted) return;
      _loading = false;
      if (!applySuccess) {
        showMessage(context, message: '이미 가입중이거나 신청중인 모임입니다.');
        return;
      }
      Navigator.pop(context);
    } catch (e) {
      showMessage(context, message: '잠시후에 다시 신청해 주세요.');
      _loading = false;
    }
  }

  Future<void> previewPressed() async {
    if (_loading) return;
    _loading = true;
    try {
      bool uploadSuccess = await ClubGatheringService.uploadGathering(
          gathering: widget.gathering);
      if (!mounted) return;
      if (uploadSuccess) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      showMessage(context, message: '잠시후에 다시 개설해 주세요.');
      _loading = false;
    }
  }

  Widget getPage() {
    switch (_headerIndex) {
      case 0:
        return ClubGatheringBasicContents(
          gathering: widget.gathering,
        );
      case 1:
        return ClubGatheringConnectedGatheringContents(
          gatheringId: widget.gathering.id,
        );
      case 2:
        return ClubGatheringConnectedDailyContents(
          gatheringId: widget.gathering.id,
        );
      default:
        return Container(
          constraints: const BoxConstraints(
            minHeight: kScreenDefaultHeight,
          ),
        );
    }
  }

  Future<void> updatePressed() async {
    if (_loading) return;
    _loading = true;
    try {
      bool updateSuccess = await ClubGatheringService.updateGathering(
          gathering: widget.gathering);
      if (!mounted) return;
      if (updateSuccess) {
        Navigator.pop(context);
        Navigator.pop(context);
        showMessage(context, message: '모임을 수정했습니다.');
      }
    } catch (e) {
      showMessage(context, message: '잠시후에 다시 시도해 주세요.');
      _loading = false;
    }
  }

  Widget getActionButton() {
    if (!widget.isPreview) {
      bool isOrganizer = context.read<UserController>().user?.id ==
          widget.gathering.organizerId;

      if (isOrganizer) {
        return GatheringButton(
          title: '가입 신청 멤버 보러가기',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GatheringApplicantScreen(
                gatheringId: widget.gathering.id,
                category: kOneDayGatheringCategory,
                organizerId: widget.gathering.organizerId,
              ),
            ),
          ),
        );
      }
      if (widget.gathering.memberList
          .contains(context.read<UserController>().user?.id)) {
        return GatheringButton(
          title: '이미 가입중인 모임입니다',
          enabled: false,
          onTap: () {},
        );
      }
      if (widget.gathering.applicantList
          .contains(context.read<UserController>().user?.id)) {
        return GatheringButton(
          title: '가입 신청중인 모임입니다',
          enabled: false,
          onTap: () {},
        );
      }
      if (widget.gathering.capacity <= widget.gathering.memberList.length) {
        return GatheringButton(
          title: '인원 마감된 모임입니다',
          enabled: false,
          onTap: () {},
        );
      }
      return GatheringButton(
        title: '소모임 가입하기',
        onTap: () => applyPressed(),
      );
    }
    if (!widget.isEdit) {
      return GatheringButton(
        title: '소모임 오픈하기',
        onTap: () => previewPressed(),
      );
    }
    return GatheringButton(
      title: '소모임 수정하기',
      onTap: () => updatePressed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kWhiteColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          GatheringSliverAppbar(
            showAppbarBlack: _showAppbarBlack,
            size: MediaQuery.of(context).size.width,
            gathering: widget.gathering,
            gatheringType: GatheringType.club,
            isPreview: widget.isPreview,
          ),
          SliverAppBar(
            primary: false,
            toolbarHeight: 48,
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
            title: Container(
              height: 48,
              decoration: BoxDecoration(
                color: kWhiteColor,
                border: Border.symmetric(
                  horizontal: BorderSide(color: kFontGray50Color, width: 1),
                ),
              ),
              child: Row(
                children: [
                  kTabBarButton(title: '정보', index: 0),
                  kTabBarButton(title: '모임', index: 1),
                  kTabBarButton(title: '데일리', index: 2),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: getPage()),
        ],
      ),
      bottomNavigationBar: getActionButton(),
    );
  }

  Widget kTabBarButton({required String title, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _headerIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: _headerIndex == index
                ? Border(
                    bottom: BorderSide(
                    color: kMainColor,
                    width: 2,
                  ))
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              color:
                  _headerIndex == index ? kFontGray800Color : kFontGray200Color,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
