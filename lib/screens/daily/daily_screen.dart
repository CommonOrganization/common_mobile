import 'package:common/controllers/block_controller.dart';
import 'package:common/controllers/screen_controller.dart';
import 'package:common/models/daily/daily.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/widgets/daily_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../search/search_screen.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 20,
        title: Text(
          '데일리',
          style: TextStyle(
            fontSize: 22,
            height: 28 / 22,
            color: kFontGray900Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            ),
            child: SvgPicture.asset('assets/icons/svg/search_26px.svg'),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<ScreenController>(
          builder: (context, screenController, child) {
        return Consumer<BlockController>(builder: (context, controller, child) {
          return FutureBuilder(
            future: DailyService.getRecommendDaily(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Daily>? dailyList = snapshot.data;
                if (dailyList == null) return Container();
                dailyList = dailyList
                    .where((daily) =>
                        !controller.blockedObjectList.contains(daily.id))
                    .where((daily) => !controller.blockedObjectList
                        .contains(daily.organizerId))
                    .toList();
                if (dailyList.isEmpty) {
                  return Center(
                    child: Text(
                      '데일리가 없어요...\n데일리를 직접 만들어 보세요!',
                      style: TextStyle(
                        fontSize: 16,
                        height: 24 / 16,
                        letterSpacing: -0.5,
                        color: kFontGray400Color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return GridView.count(
                  physics: const ClampingScrollPhysics(),
                  crossAxisCount: 3,
                  children: dailyList
                      .map((daily) => DailyCard(daily: daily))
                      .toList(),
                );
              }
              return Container();
            },
          );
        });
      }),
    );
  }
}
