import 'package:common/constants/constants_enum.dart';
import 'package:common/utils/gathering_utils.dart';
import 'package:flutter/material.dart';
import '../../constants/constants_colors.dart';

class RecruitQuestionBottomSheet extends StatefulWidget {
  final String gatheringId;
  final String userId;
  final String question;
  const RecruitQuestionBottomSheet(
      {Key? key,
      required this.gatheringId,
      required this.userId,
      required this.question})
      : super(key: key);

  @override
  State<RecruitQuestionBottomSheet> createState() =>
      _RecruitQuestionBottomSheetState();
}

class _RecruitQuestionBottomSheetState
    extends State<RecruitQuestionBottomSheet> {
  late GatheringType _gatheringType;
  final TextEditingController _questionController = TextEditingController();
  bool get canApply => _questionController.text.isNotEmpty;
  String get buttonText =>
      _gatheringType == GatheringType.oneDay ? '참여하기' : '가입하기';

  @override
  void initState() {
    super.initState();
    _gatheringType = getGatheringType(widget.gatheringId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.4,
          color: kWhiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kFontGray100Color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  '궁금해요!!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kFontGray800Color,
                    height: 20 / 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '질문 : ${widget.question}',
                style: TextStyle(
                  fontSize: 20,
                  height: 1,
                  color: kFontGray900Color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    controller: _questionController,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 13,
                      color: kFontGray800Color,
                      height: 20 / 13,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      counterText: '',
                      hintText: '질문에 대한 답을 적어주세요 :)',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: kFontGray400Color,
                        height: 20 / 13,
                      ),
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context, _questionController.text),
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 20),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: canApply ? kMainColor : kFontGray100Color,
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 16,
                        color: canApply ? kWhiteColor : kFontGray200Color,
                        fontWeight: FontWeight.bold,
                        height: 20 / 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
