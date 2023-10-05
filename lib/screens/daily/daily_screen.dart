import 'package:common/models/daily/daily.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/widgets/daily_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/constants_colors.dart';
import '../search/search_screen.dart';


class DailyScreen extends StatelessWidget {
  const DailyScreen({Key? key}) : super(key: key);

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
      body: FutureBuilder(
          future: DailyService.getRecommendDaily(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Daily>? dailyList = snapshot.data;
              if (dailyList == null || dailyList.isEmpty) return Container();
              return GridView.count(
                physics: const ClampingScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: dailyList
                    .map((daily) => DailyCard(daily: daily))
                    .toList(),
              );
            }
            return Container();
          }),
    );
  }
}

