import 'package:common/constants/constants_enum.dart';
import 'package:common/models/club_gathering/club_gathering.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/screens/gathering_upload/club_gathering_upload/club_gathering_upload_main_screen.dart';
import 'package:common/services/club_gathering_service.dart';
import 'package:common/services/one_day_gathering_service.dart';
import 'package:common/utils/gathering_utils.dart';
import 'package:common/utils/local_utils.dart';
import 'package:common/widgets/bottom_sheets/bottom_sheet_custom_button.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants_colors.dart';
import '../../models/gathering/gathering.dart';
import '../../screens/gathering_upload/one_day_gathering_upload/one_day_gathering_upload_main_screen.dart';

class GatheringEditBottomSheet extends StatelessWidget {
  final Gathering gathering;
  const GatheringEditBottomSheet({Key? key, required this.gathering})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GatheringType gatheringType = getGatheringType(gathering.id);
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    BottomSheetCustomButton(
                      title: '수정하기',
                      onPressed: () {
                        switch (gatheringType) {
                          case GatheringType.oneDay:
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OneDayGatheringUploadMainScreen(
                                  gathering: gathering as OneDayGathering,
                                ),
                              ),
                            );
                            return;
                          case GatheringType.club:
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ClubGatheringUploadMainScreen(
                                  gathering: gathering as ClubGathering,
                                ),
                              ),
                            );
                            return;
                          default:
                            return;
                        }
                      },
                    ),
                    Container(
                        width: double.infinity,
                        height: 1,
                        color: kDarkGray20Color),
                    BottomSheetCustomButton(
                      title: '삭제하기',
                      onPressed: () {
                        switch (gatheringType) {
                          case GatheringType.oneDay:
                            OneDayGatheringService.deleteGathering(
                                    gathering: gathering as OneDayGathering)
                                .then(
                              (value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showMessage(context, message: '하루모임을 삭제했습니다.');
                              },
                            );
                            return;
                          case GatheringType.club:
                            ClubGatheringService.deleteGathering(
                                    gathering: gathering as ClubGathering)
                                .then(
                              (value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showMessage(context, message: '소모임을 삭제했습니다.');
                              },
                            );
                            return;
                          default:
                            return;
                        }
                      },
                      color: kErrorColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
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
