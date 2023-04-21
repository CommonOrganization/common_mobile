import 'package:common/constants/constants_colors.dart';
import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_upload_main_screen.dart';
import 'package:common/screens/gathering_upload/one_day_gathering_upload/one_day_gathering_upload_main_screen.dart';
import 'package:common/services/firebase_club_gathering_service.dart';
import 'package:common/services/firebase_one_day_gathering_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../models/gathering/gathering.dart';

class GatheringCategoryContainer extends StatelessWidget {
  final String category;
  const GatheringCategoryContainer({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 18, right: 10, top: 21, bottom: 21),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kSubColor1),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            blurRadius: 10,
            color: kMainColor.withOpacity(0.15),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTitle(category),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 20 / 15,
                    letterSpacing: -0.5,
                    color: kFontGray800Color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  getSubTitle(category),
                  style: TextStyle(
                    fontSize: 13,
                    height: 18 / 13,
                    letterSpacing: -0.5,
                    color: kFontGray400Color,
                  ),
                ),
              ],
            ),
          ),
          Consumer<UserController>(builder: (context, controller, child) {
            if (controller.user == null) return Container();

            late Future future;
            switch (category) {
              case kClubGatheringCategory:
                future = FirebaseClubGatheringService
                    .getGatheringListWhichUserIsParticipating(
                        userId: controller.user!.id);
                break;
              case kOneDayGatheringCategory:
              default:
                future = FirebaseOneDayGatheringService
                    .getGatheringListWhichUserIsParticipating(
                        userId: controller.user!.id);
                break;
            }
            return FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Gathering> gatheringList =
                        snapshot.data as List<Gathering>;

                    int emptyCount = 3 - gatheringList.length;
                    if (emptyCount > 0) {
                      return Row(
                        children: [
                          ...gatheringList.map(
                            (gathering) => getGatheringButton(gathering),
                          ),
                          ...List.generate(
                            emptyCount,
                            (index) => getEmptyButton(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      getGatheringUploadScreen(category),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: gatheringList
                          .sublist(0, 3)
                          .map((gathering) => getGatheringButton(gathering))
                          .toList(),
                    );
                  }
                  return Row(
                    children: List.generate(
                        3, (index) => getEmptyButton(onTap: () {})),
                  );
                });
          }),
        ],
      ),
    );
  }

  String getTitle(String category) {
    switch (category) {
      case kClubGatheringCategory:
        return '소모임';
      case kOneDayGatheringCategory:
      default:
        return '하루모임';
    }
  }

  String getSubTitle(String category) {
    switch (category) {
      case kClubGatheringCategory:
        return '지속형 모임을\n가지고 싶을 때';
      case kOneDayGatheringCategory:
      default:
        return '일회성 모임을\n가지고 싶을 때';
    }
  }

  Widget getGatheringUploadScreen(String category) {
    switch (category) {
      case kClubGatheringCategory:
        return const ClubGatheringUploadMainScreen();
      case kOneDayGatheringCategory:
      default:
        return const OneDayGatheringUploadMainScreen();
    }
  }

  Widget getGatheringButton(Gathering gathering) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 68,
      height: 66,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(64),
          image: DecorationImage(
            image: NetworkImage(gathering.mainImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget getEmptyButton({required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 68,
        height: 66,
        child: Stack(
          children: [
            DottedBorder(
              borderType: BorderType.Circle,
              dashPattern: const [3, 3],
              color: kMainColor,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(64),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: kMainColor,
                  border: Border.all(color: kWhiteColor),
                ),
                child: SvgPicture.asset(
                  'assets/icons/svg/add_10px.svg',
                  width: 10,
                  height: 10,
                  fit: BoxFit.scaleDown,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
