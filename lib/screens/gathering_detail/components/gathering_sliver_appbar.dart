import 'package:common/controllers/user_controller.dart';
import 'package:common/models/gathering/gathering.dart';
import 'package:common/services/like_service.dart';
import 'package:common/utils/gathering_utils.dart';
import 'package:common/widgets/bottom_sheets/gathering_report_bottom_sheet.dart';
import 'package:common/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_enum.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/bottom_sheets/gathering_edit_bottom_sheet.dart';

class GatheringSliverAppbar extends StatefulWidget {
  final bool showAppbarBlack;
  final double size;
  final Gathering gathering;
  final GatheringType gatheringType;
  final bool isPreview;

  const GatheringSliverAppbar({
    super.key,
    required this.showAppbarBlack,
    required this.size,
    required this.gathering,
    required this.gatheringType,
    required this.isPreview,
  });

  @override
  State<GatheringSliverAppbar> createState() => _GatheringSliverAppbarState();
}

class _GatheringSliverAppbarState extends State<GatheringSliverAppbar> {
  final PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    GatheringType gatheringType = getGatheringType(widget.gathering.id);
    return SliverAppBar(
        backgroundColor:
            widget.showAppbarBlack ? kWhiteColor : Colors.transparent,
        surfaceTintColor: kWhiteColor,
        elevation: 0,
        pinned: true,
        expandedHeight: MediaQuery.of(context).size.width,
        leadingWidth: 48,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              widget.showAppbarBlack
                  ? 'assets/icons/svg/arrow_left_28px.svg'
                  : 'assets/icons/svg/arrow_left_white_28px.svg',
            ),
          ),
        ),
        actions: widget.isPreview
            ? null
            : [
                // TODO 공유기능 개발시 바로 넣기
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: () {},
                //   child: SvgPicture.asset(
                //     widget.showAppbarBlack
                //         ? 'assets/icons/svg/share_26px.svg'
                //         : 'assets/icons/svg/share_white_26px.svg',
                //   ),
                // ),
                const SizedBox(width: 18),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    String? userId = context.read<UserController>().user?.id;
                    if (userId == null) return;
                    if (userId == widget.gathering.organizerId) {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => GatheringEditBottomSheet(
                          gathering: widget.gathering,
                        ),
                      );
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => GatheringReportBottomSheet(
                        gathering: widget.gathering,
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    widget.showAppbarBlack
                        ? 'assets/icons/svg/more_26px.svg'
                        : 'assets/icons/svg/more_white_26px.svg',
                  ),
                ),
                const SizedBox(width: 20),
              ],
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: pageController,
                      children: [
                        widget.gathering.mainImage,
                        ...widget.gathering.gatheringImage
                      ]
                          .map(
                            (image) => Container(
                              width: widget.size,
                              height: widget.size,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                width: widget.size,
                                height: widget.size,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      kBlackColor.withOpacity(0.4),
                                      kBlackColor.withOpacity(0.08),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          runSpacing: 8,
                          spacing: 8,
                          children: widget.gathering.tagList
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.5),
                                    border: Border.all(
                                      color: kWhiteColor,
                                      width: 1.25,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: kWhiteColor,
                                      height: 17 / 13,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 24, bottom: 16),
                        width: MediaQuery.of(context).size.width,
                        constraints: const BoxConstraints(
                          minHeight: 100,
                        ),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(builder: (context) {
                              CommonCategory category =
                                  CommonCategoryExtenstion.getCategory(
                                      widget.gathering.category);
                              return Row(
                                children: [
                                  Image.asset(
                                    category.miniImage,
                                    width: 22,
                                    height: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    category.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kFontGray600Color,
                                      fontWeight: FontWeight.bold,
                                      height: 17 / 12,
                                    ),
                                  ),
                                  if (widget
                                      .gathering.detailCategory.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Container(
                                        width: 1,
                                        height: 10,
                                        color: kFontGray500Color,
                                      ),
                                    ),
                                  Text(
                                    widget.gathering.detailCategory,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kFontGray600Color,
                                      height: 17 / 12,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.gathering.title,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: kFontGray900Color,
                                      height: 37 / 26,
                                    ),
                                  ),
                                ),
                                FavoriteButton(
                                  category: gatheringType.category,
                                  objectId: widget.gathering.id,
                                  userId:
                                      context.read<UserController>().user!.id,
                                  size: 28,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  '${getTimeDifference(DateTime.parse(widget.gathering.timeStamp))} 등록',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kMainColor,
                                    height: 17 / 13,
                                  ),
                                ),
                                Text(
                                  'ㆍ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kFontGray400Color,
                                    height: 17 / 13,
                                  ),
                                ),
                                FutureBuilder(
                                    future: LikeService.getLikeObjectCount(
                                        objectId: widget.gathering.id),
                                    builder: (context, snapshot) {
                                      return RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: kFontGray400Color,
                                            height: 17 / 13,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '${snapshot.data ?? 0}명',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                height: 18 / 13,
                                              ),
                                            ),
                                            const TextSpan(text: '이 찜한 모임'),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
