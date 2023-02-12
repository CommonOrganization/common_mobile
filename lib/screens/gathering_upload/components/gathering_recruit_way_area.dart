import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';

class GatheringRecruitWayArea extends StatelessWidget {
  final RecruitWay selectedRecruitWay;
  final TextEditingController controller;
  final Function recruitWayPressed;
  final Function textFieldOnChange;
  const GatheringRecruitWayArea({
    Key? key,
    required this.selectedRecruitWay,
    required this.controller,
    required this.recruitWayPressed,
    required this.textFieldOnChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          '어떻게 멤버를 모집할까요?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kGrey1C1C1EColor,
          ),
        ),
        const SizedBox(height: 36),
        ...RecruitWay.values.map(
          (recruitWay) => GestureDetector(
            onTap: () => recruitWayPressed(recruitWay),
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selectedRecruitWay == recruitWay
                    ? kMainColor
                    : kWhiteF6F6F6Color,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    selectedRecruitWay == recruitWay
                        ? recruitWay.selectedIcon
                        : recruitWay.unselectedIcon,
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recruitWay.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: selectedRecruitWay == recruitWay
                                ? kWhiteColor
                                : kGrey48484AColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recruitWay.content,
                          style: TextStyle(
                            fontSize: 13,
                            color: selectedRecruitWay == recruitWay
                                ? kWhiteColor
                                : kGrey8E8E93Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (selectedRecruitWay == RecruitWay.approval)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  '가입할 멤버들에게 물어볼 질문을 작성해주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: kGrey363639Color,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 6),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 14,
                    height: 14,
                    child: Text(
                      'ⓘ',
                      style: TextStyle(
                        fontSize: 10,
                        color: kGrey8E8E93Color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '전화번호, 신청 폼 작성 요구, 타 플랫폼 요구 등\n과도한 개인 정보를 요구하는 경우 경고 및 제재를 받게 돼요.',
                      style: TextStyle(
                        fontSize: 10,
                        color: kGrey8E8E93Color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: kGrey363639Color,
                ))),
                child: TextField(
                  controller: controller,
                  style: TextStyle(fontSize: 13, color: kGrey363639Color),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    counterText: '',
                    hintText: '예시: 어떤 관심사를 갖고 계신가요?',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: kWhiteAEAEB2Color,
                    ),
                  ),
                  onChanged: (text) => textFieldOnChange(text),
                ),
              ),
            ],
          )
      ],
    );
  }
}
