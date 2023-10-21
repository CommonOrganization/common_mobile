import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/block_controller.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/gathering/gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/widgets/club_gathering_row_card.dart';
import 'package:common/widgets/one_day_gathering_row_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';

class HomeContentsSubScreen extends StatelessWidget {
  final String category;
  final Future future;
  final String title;
  const HomeContentsSubScreen(
      {Key? key,
      required this.category,
      required this.future,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        foregroundColor: kFontGray800Color,
        backgroundColor: kWhiteColor,
        leadingWidth: 48,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/svg/arrow_left_28px.svg'),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: kFontGray800Color,
            height: 28 / 18,
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Consumer<UserController>(builder: (context, userController, child) {
        if (userController.user == null) return Container();
        String userId = userController.user!.id;
        return Consumer<BlockController>(
            builder: (context, blockController, child) {
          List blockedObjectList = blockController.blockedObjectList;
          return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                late List<Gathering> gatheringList;
                switch (category) {
                  case kOneDayGatheringCategory:
                    gatheringList = snapshot.data as List<OneDayGathering>;
                    break;
                  case kClubGatheringCategory:
                    gatheringList = snapshot.data as List<ClubGathering>;
                    break;
                }

                if (gatheringList.isNotEmpty) {
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 10),
                    physics: const ClampingScrollPhysics(),
                    children: gatheringList
                        .where((gathering) =>!blockedObjectList.contains(gathering.id))
                        .map(
                            (gathering) => (category == kOneDayGatheringCategory
                                ? OneDayGatheringRowCard(
                                    gathering: gathering as OneDayGathering,
                                    userId: userId,
                                  )
                                : ClubGatheringRowCard(
                                    gathering: gathering as ClubGathering,
                                    userId: userId,
                                  )))
                        .toList(),
                  );
                }
              }
              return Container();
            },
          );
        });
      }),
    );
  }
}
