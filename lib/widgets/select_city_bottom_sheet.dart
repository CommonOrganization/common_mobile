import 'package:common/constants/constants_enum.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:common/utils/local_utils.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class SelectCityBottomSheet extends StatefulWidget {
  const SelectCityBottomSheet({Key? key}) : super(key: key);

  @override
  State<SelectCityBottomSheet> createState() => _SelectCityBottomSheetState();
}

class _SelectCityBottomSheetState extends State<SelectCityBottomSheet> {
  final List<City> _selectedCityList = [];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              width: double.infinity,
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: kFontGray100Color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: Text(
                '지역선택',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kFontGray800Color,
                  height: 20/16,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 1,
              color: kFontGray50Color,
            ),
            Expanded(
              child: ListView(
                children: City.values
                    .map(
                      (city) => GestureDetector(
                        onTap: () {
                          if (_selectedCityList.contains(city)) {
                            setState(() => _selectedCityList.remove(city));
                            return;
                          }
                          if (_selectedCityList.length >= 5) {
                            showMessage(context,
                                message: '소모임 활동 지역은 최대 5개까지만 설정 가능합니다');
                            return;
                          }
                          setState(() => _selectedCityList.add(city));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 48,
                          color: _selectedCityList.contains(city)
                              ? kFontGray50Color
                              : kWhiteColor,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              width: 1,
                              color: kFontGray50Color,
                            ),),),
                            child: Text(
                              city.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: kFontGray800Color,
                                height: 20/14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_selectedCityList.isEmpty) {
                  showMessage(context, message: '소모임이 주로 활동하는 지역을 선택해 주세요');
                  return;
                }
                Navigator.pop(context, _selectedCityList);
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                color: _selectedCityList.isNotEmpty
                    ? kMainColor
                    : kFontGray100Color,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      '선택완료',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedCityList.isNotEmpty
                            ? kWhiteColor
                            : kFontGray200Color,
                        fontWeight: FontWeight.bold,
                        height: 20/16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
