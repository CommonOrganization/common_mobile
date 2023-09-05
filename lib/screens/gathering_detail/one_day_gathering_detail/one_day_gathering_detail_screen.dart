import 'package:common/constants/constants_enum.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/models/recruit_answer/recruit_answer.dart';
import 'package:common/services/gathering_service.dart';
import 'package:common/services/recruit_answer_service.dart';
import 'package:common/utils/local_utils.dart';
import 'package:common/widgets/bottom_sheets/recruit_question_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../services/one_day_gathering_service.dart';
import '../components/gathering_button.dart';
import '../components/gathering_sliver_appbar.dart';
import 'one_day_gathering_basic_contents.dart';

class OneDayGatheringDetailScreen extends StatefulWidget {
  final OneDayGathering gathering;
  final bool isPreview;
  final bool isEdit;
  const OneDayGatheringDetailScreen({
    Key? key,
    required this.gathering,
    this.isPreview = false,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<OneDayGatheringDetailScreen> createState() =>
      _OneDayGatheringDetailScreenState();
}

class _OneDayGatheringDetailScreenState
    extends State<OneDayGatheringDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _showAppbarBlack = false;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    addEventListener();
  }

  void addEventListener() {
    int size = 300;
    _scrollController.addListener(() {
      if (_scrollController.offset < size && _showAppbarBlack) {
        setState(() => _showAppbarBlack = false);
      }
      if (_scrollController.offset > size && !_showAppbarBlack) {
        setState(() => _showAppbarBlack = true);
      }
    });
  }

  Future<void> applyPressed() async {
    String? userId = context.read<UserController>().user?.id;
    if (userId == null) return;
    if (_loading) return;
    _loading = true;
    try {
      String? recruitWayString = await GatheringService.get(
          category: kOneDayGatheringCategory,
          id: widget.gathering.id,
          field: 'recruitWay');
      if (recruitWayString == null) return;
      RecruitWay recruitWay =
          RecruitWayExtenstion.getRecruitWay(recruitWayString);
      if (recruitWay == RecruitWay.approval) {
        String? recruitQuestion = await GatheringService.get(
            category: kOneDayGatheringCategory,
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
        _loading = false;
        if (answer == null) return;
        RecruitAnswer recruitAnswer = RecruitAnswer(
          gatheringId: widget.gathering.id,
          userId: userId,
          question: recruitQuestion,
          answer: answer,
          timeStamp: DateTime.now().toString(),
        );
        await RecruitAnswerService.uploadRecruitAnswer(recruitAnswer: recruitAnswer);
      }
      bool applySuccess = await OneDayGatheringService.applyGathering(
          id: widget.gathering.id, userId: userId);
      if (!mounted) return;
      if (!applySuccess) {
        showMessage(context, message: '이미 참여중이거나 요청중인 모임입니다.');
        return;
      }
      showMessage(context, message: '하루모임에 참여 신청했습니다.');
    } catch (e) {
      showMessage(context, message: '잠시후에 다시 신청해 주세요.');
      _loading = false;
    }
  }

  Future<void> previewPressed() async {
    if (_loading) return;
    _loading = true;
    try {
      bool uploadSuccess = await OneDayGatheringService.uploadGathering(
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

  Future<void> updatePressed() async {
    if (_loading) return;
    _loading = true;
    try {
      bool updateSuccess = await OneDayGatheringService.updateGathering(
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
      return GatheringButton(
        title: '하루모임 참여하기',
        onTap: () => applyPressed(),
      );
    }
    if (!widget.isEdit) {
      return GatheringButton(
        title: '하루모임 개설하기',
        onTap: () => previewPressed(),
      );
    }
    return GatheringButton(
      title: '수정하기',
      onTap: () => updatePressed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kWhiteColor,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          GatheringSliverAppbar(
            showAppbarBlack: _showAppbarBlack,
            size: MediaQuery.of(context).size.width,
            gathering: widget.gathering,
            gatheringType: GatheringType.oneDay,
            isPreview: widget.isPreview,
          ),
          SliverToBoxAdapter(
            child: OneDayGatheringBasicContents(
              gathering: widget.gathering,
            ),
          )
        ],
      ),
      bottomNavigationBar: getActionButton(),
    );
  }
}
