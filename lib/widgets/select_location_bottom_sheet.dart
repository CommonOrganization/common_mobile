import 'package:common/constants/constants_enum.dart';
import 'package:common/models/user_place/user_place.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';

class SelectLocationBottomSheet extends StatefulWidget {
  const SelectLocationBottomSheet({Key? key}) : super(key: key);

  @override
  State<SelectLocationBottomSheet> createState() => _SelectLocationBottomSheetState();
}

class _SelectLocationBottomSheetState extends State<SelectLocationBottomSheet> {
  City? _selectedCity;

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
                  color: kWhiteC6C6C6Color,
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
                  color: kGrey363639Color,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 1,
              color: kWhiteF4F4F4Color,
            ),
            Expanded(
              child: ListView(
                children: City.values
                    .map(
                      (city) => Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_selectedCity == city) {
                            setState(() => _selectedCity = null);
                            return;
                          }
                          setState(() => _selectedCity = city);
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 48,
                          color: _selectedCity == city
                              ? kWhiteF4F4F4Color
                              : kWhiteColor,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      width: 1,
                                      color: kWhiteF4F4F4Color,
                                    ))),
                            child: Row(
                              children: [
                                Text(
                                  city.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kGrey363639Color,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  _selectedCity == city
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: kWhiteC6C6C6Color,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_selectedCity == city)
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: city.county
                                .map((county) => GestureDetector(
                              onTap: () {
                                UserPlace userPlace = UserPlace(
                                  city: city.name,
                                  county: county,
                                  dong: '전체',
                                );
                                Navigator.pop(context,userPlace);
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1,
                                      color: kWhiteF4F4F4Color,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          bottom: 5),
                                      child: Icon(
                                        Icons
                                            .subdirectory_arrow_right,
                                        color: kWhiteC6C6C6Color,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Builder(
                                      builder: (context) {
                                        if (county == '전체') {
                                          return Text(
                                            '${city.name} $county',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                              kGrey363639Color,
                                            ),
                                          );
                                        }
                                        return Text(
                                          county,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: kGrey363639Color,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
