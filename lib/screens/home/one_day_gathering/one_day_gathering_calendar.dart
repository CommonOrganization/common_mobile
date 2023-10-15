import 'package:common/constants/constants_colors.dart';
import 'package:common/controllers/block_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/models/user/user.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_upload_main_screen.dart';
import 'package:common/screens/home/one_day_gathering/one_day_gathering_calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_value.dart';
import '../../../models/user_place/user_place.dart';
import '../../../services/one_day_gathering_service.dart';

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '하루모임 캘린더',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 20 / 18,
                    color: kFontGray900Color,
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
                                      ? kMainColor
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
                                        color: _selectedAddDay == day
                                            ? kFontGray0Color
                                            : kFontGray400Color,
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
                                            ? kFontGray0Color
                                            : null,
                                      ),
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedAddDay == day
                                              ? kMainColor
                                              : kFontGray400Color,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              User? user = context.read<UserController>().user;
              if (user == null) return Container();
              UserPlace userPlace =
                  UserPlace.fromJson(user.userPlace as Map<String, dynamic>);

              DateTime addedDate =
                  _nowDate.add(Duration(days: _selectedAddDay));
              DateTime dateTime =
                  DateTime(addedDate.year, addedDate.month, addedDate.day);

              return Consumer<BlockController>(
                  builder: (context, controller, child) {
                return FutureBuilder(
                  future: OneDayGatheringService.getDailyGathering(
                      city: userPlace.city, dateTime: dateTime),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<OneDayGathering>? gatheringList = snapshot.data;
                      if (gatheringList == null) return Container();
                      gatheringList = gatheringList
                          .where((gathering) => !controller.blockedObjectList
                              .contains(gathering.id))
                          .toList();
                      if (gatheringList.isNotEmpty) {
                        int count = 1;
                        int gatheringSize =
                            gatheringList.length > 3 ? 3 : gatheringList.length;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 26),
                          color: kDarkGray20Color,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kDarkGray20Color,
                            ),
                            child: Column(
                              children: gatheringList
                                  .sublist(0, gatheringSize)
                                  .map(
                                    (gathering) => OneDayGatheringCalendarCard(
                                      count: count++,
                                      gathering: gathering,
                                      gatheringSize: gatheringSize,
                                      userId: user.id,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 26),
                        color: kDarkGray20Color,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          width: MediaQuery.of(context).size.width - 40,
                          height: 342,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kWhiteColor,
                            border: Border.all(
                              color: kFontGray50Color,
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 5,
                                color: kBlurColor,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '해당일에 하루모임이 없어요...\n하루모임을 직접 만들어 보세요!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 24 / 16,
                                      letterSpacing: -0.5,
                                      color: kFontGray400Color,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OneDayGatheringUploadMainScreen(),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27),
                                    color: kMainColor,
                                  ),
                                  child: Text(
                                    '하루모임 만들기',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 20 / 16,
                                      color: kFontGray0Color,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
