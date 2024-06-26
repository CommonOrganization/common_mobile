import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/widgets/bottom_sheets/select_city_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/club_gathering/club_gathering.dart';
import '../../../utils/format_utils.dart';
import '../../../widgets/common_action_button.dart';

class ClubGatheringLocationScreen extends StatefulWidget {
  final ClubGathering? gathering;
  final Function nextPressed;
  const ClubGatheringLocationScreen({super.key, required this.nextPressed, this.gathering});

  @override
  State<ClubGatheringLocationScreen> createState() =>
      _ClubGatheringLocationScreenState();
}

class _ClubGatheringLocationScreenState
    extends State<ClubGatheringLocationScreen> {
  List<City> _gatheringCityList = [];

  @override
  void initState() {
    super.initState();
    setGatheringInformation();
  }

  void setGatheringInformation() {
    if (widget.gathering == null) return;
    for (var city in widget.gathering!.cityList) {
      _gatheringCityList.add(CityExtenstion.getCity(city));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                Text(
                  '소모임 활동 지역을 설정해볼까요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kFontGray900Color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  '주로 활동하는 지역',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kFontGray800Color,
                    height: 20 / 15,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    List<City>? selectedCity = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const SelectCityBottomSheet(),
                    );
                    if (selectedCity == null) return;
                    if (!mounted) return;
                    setState(() => _gatheringCityList = selectedCity);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kFontGray50Color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/svg/location_24px.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Builder(builder: (context) {
                            if (_gatheringCityList.isEmpty) {
                              return Text(
                                '지역을 선택해주세요 (중복 가능)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kFontGray400Color,
                                  height: 20 / 14,
                                ),
                              );
                            }
                            return Text(
                              getCityNames(_gatheringCityList),
                              style: TextStyle(
                                fontSize: 14,
                                color: kFontGray800Color,
                                height: 20 / 14,
                              ),
                            );
                          }),
                        ),
                        SvgPicture.asset(
                            'assets/icons/svg/arrow_down_20px.svg'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                          fontSize: 11,
                          color: kFontGray500Color,
                          height: 16 / 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '소모임이 활동 지역과 가까운 사람들에게 더 많이 노출되고,\n지역 검색을 통해 확인할 수 있어요.',
                        style: TextStyle(
                          fontSize: 11,
                          color: kFontGray500Color,
                          height: 16 / 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        CommonActionButton(
          value: _gatheringCityList.isNotEmpty,
          onTap: () {
            if (_gatheringCityList.isEmpty) return;
            widget.nextPressed(_gatheringCityList);
          },
          title: '다음',
        ),
      ],
    );
  }
}
