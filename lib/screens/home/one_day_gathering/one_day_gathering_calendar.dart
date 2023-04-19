import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/home/one_day_gathering/one_day_gathering_calendar_card.dart';
import 'package:common/services/firebase_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants_value.dart';
import '../../../services/firebase_one_day_gathering_service.dart';

class OneDayGatheringCalendar extends StatefulWidget {
  const OneDayGatheringCalendar({Key? key}) : super(key: key);

  @override
  State<OneDayGatheringCalendar> createState() =>
      _OneDayGatheringCalendarState();
}

class _OneDayGatheringCalendarState extends State<OneDayGatheringCalendar> {
  late DateTime _nowDate;

  int _selectedAddDay = 0;

  @override
  void initState() {
    super.initState();
    _nowDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      width: MediaQuery.of(context).size.width,
      height: 486,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            width: double.infinity,
            height: 197,
            color: kMainColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '하루모임 캘린더',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 20 / 18,
                    color: kFontGray0Color,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [0, 1, 2, 3, 4, 5, 6, 7]
                      .map((day) => Builder(builder: (context) {
                            DateTime date = _nowDate.add(Duration(days: day));
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedAddDay = day),
                              child: Container(
                                width: 30,
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: _selectedAddDay == day
                                      ? kSubColor3
                                      : null,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      kShortWeekdayList[date.weekday - 1],
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 20 / 14,
                                        color: kFontGray0Color,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: _selectedAddDay == day
                                            ? kWhiteColor
                                            : null,
                                      ),
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedAddDay == day
                                              ? kSubColor3
                                              : kFontGray100Color,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }))
                      .toList(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 144,
            child: Consumer<UserController>(
              builder: (context, controller, child) {
                if (controller.user == null) return Container();
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 342,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kWhiteColor,
                  ),
                  child: FutureBuilder(
                    future: FirebaseOneDayGatheringService.getGathering(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<OneDayGathering> gatheringList =
                            snapshot.data as List<OneDayGathering>;
                        if (gatheringList.isNotEmpty) {
                          int count = 0;
                          return Column(
                            children: gatheringList
                                .sublist(
                                  0,
                                  gatheringList.length > 3
                                      ? 3
                                      : gatheringList.length,
                                )
                                .map((gathering) => OneDayGatheringCalendarCard(
                                    count: count++, gathering: gathering))
                                .toList(),
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
