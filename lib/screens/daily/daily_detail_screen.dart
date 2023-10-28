import 'package:common/constants/constants_value.dart';
import 'package:common/controllers/user_controller.dart';
import 'package:common/services/daily_service.dart';
import 'package:common/services/like_service.dart';
import 'package:common/utils/date_utils.dart';
import 'package:common/widgets/bottom_sheets/daily_edit_bottom_sheet.dart';
import 'package:common/widgets/bottom_sheets/daily_report_bottom_sheet.dart';
import 'package:common/widgets/common_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../constants/constants_colors.dart';
import '../../models/daily/daily.dart';
import '../../widgets/favorite_button.dart';
import 'components/daily_image_container.dart';
import 'components/daily_organizer_card.dart';

class DailyDetailScreen extends StatefulWidget {
  final Daily daily;
  final bool isPreview;
  const DailyDetailScreen({
    Key? key,
    required this.daily,
    this.isPreview = false,
  }) : super(key: key);

  @override
  State<DailyDetailScreen> createState() => _DailyDetailScreenState();
}

class _DailyDetailScreenState extends State<DailyDetailScreen> {
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
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          '데일리',
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: -0.5,
            color: kFontGray800Color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!widget.isPreview)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                String? userId = context.read<UserController>().user?.id;
                bool isOrganizer = userId == widget.daily.organizerId;
                if (isOrganizer) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DailyEditBottomSheet(
                      daily: widget.daily,
                    ),
                  );
                  return;
                }
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => DailyReportBottomSheet(
                    daily: widget.daily,
                  ),
                );
              },
              child: SvgPicture.asset('assets/icons/svg/more_26px.svg'),
            ),
          const SizedBox(width: 20),
        ],
        elevation: 0,
      ),
      body: Consumer<UserController>(
        builder: (context, controller, child) {
          if (controller.user == null) return Container();
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              DailyOrganizerCard(organizerId: widget.daily.organizerId),
              const SizedBox(height: 12),
              DailyImageContainer(daily: widget.daily),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    FavoriteButton(
                      category: kDailyCategory,
                      objectId: widget.daily.id,
                      userId: controller.user!.id,
                      size: 28,
                    ),
                    const SizedBox(width: 6),
                    FutureBuilder(
                      future: LikeService.getLikeObjectCount(
                          objectId: widget.daily.id),
                      builder: (context, snapshot) {
                        int likeCount = snapshot.data ?? 0;
                        if (likeCount > 0) {
                          return RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                color: kFontGray800Color,
                              ),
                              children: [
                                TextSpan(
                                  text: '$likeCount명',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: '이 좋아합니다'),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kFontGray50Color,
                  ),
                  child: Text(
                    widget.daily.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: kFontGray800Color,
                      height: 22 / 13,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  getDateFromDateTime(
                    DateTime.parse(widget.daily.timeStamp),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    height: 14 / 12,
                    color: kFontGray600Color,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: widget.isPreview
          ? CommonActionButton(
              value: true,
              onTap: () async {
                bool uploadSuccess =
                    await DailyService.uploadDaily(daily: widget.daily);
                if (!mounted) return;
                if (uploadSuccess) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              title: '데일리 올리기',
            )
          : null,
    );
  }
}
