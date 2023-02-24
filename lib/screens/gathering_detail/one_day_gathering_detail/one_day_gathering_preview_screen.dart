import 'package:common/models/gathering_place/gathering_place.dart';
import 'package:common/models/one_day_gathering/one_day_gathering.dart';
import 'package:common/services/firebase_user_service.dart';
import 'package:common/services/http_service.dart';
import 'package:common/utils/date_utils.dart';
import 'package:common/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/constants_colors.dart';
import '../components/gathering_sliver_appbar.dart';

class OneDayGatheringPreviewScreen extends StatefulWidget {
  final OneDayGathering gathering;
  const OneDayGatheringPreviewScreen({
    Key? key,
    required this.gathering,
  }) : super(key: key);

  @override
  State<OneDayGatheringPreviewScreen> createState() =>
      _OneDayGatheringPreviewScreenState();
}

class _OneDayGatheringPreviewScreenState
    extends State<OneDayGatheringPreviewScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _showAppbarBlack = false;

  @override
  void initState() {
    super.initState();
    addEventListener();
  }

  void addEventListener() {
    int size = 300;
    _scrollController.addListener(() {
      if (_scrollController.offset < size && _showAppbarBlack) {
        setState(() => _showAppbarBlack = false);
      }
      if (_scrollController.offset > size && !_showAppbarBlack) {
        setState(() => _showAppbarBlack = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kWhiteColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          GatheringSliverAppbar(
              showAppbarBlack: _showAppbarBlack,
              size: MediaQuery.of(context).size.width,
              gathering: widget.gathering),
        ],
        body: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
            color: kWhiteF4F4F4Color,
            width: 1,
          ))),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: _showAppbarBlack
                ? const BouncingScrollPhysics()
                : const ClampingScrollPhysics(),
            children: [
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    FutureBuilder(
                      future: FirebaseUserService.get(
                        id: widget.gathering.organizerId,
                        field: 'profileImage',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              image: DecorationImage(
                                image: NetworkImage(
                                  snapshot.data as String,
                                ),
                              ),
                              color: kWhiteC6C6C6Color,
                            ),
                          );
                        }
                        return Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            color: kWhiteC6C6C6Color,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '모임장',
                      style: TextStyle(
                        fontSize: 15,
                        color: kGrey363639Color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    FutureBuilder(
                      future: FirebaseUserService.get(
                        id: widget.gathering.organizerId,
                        field: 'name',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              print('프로필로 이동하기');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: kGrey48484AColor,
                              ))),
                              child: Text(
                                snapshot.data,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kGrey48484AColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                    color: kWhiteF6F6F6Color,
                  ),
                  child: Text(
                    widget.gathering.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: kGrey48484AColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              kInformationCard(
                'assets/icons/svg/clock_gray.svg',
                widget.gathering.type == 'oneDay' ? '선착순 하루모임' : '승인제 하루모임',
              ),
              const SizedBox(height: 16),
              kInformationCard(
                'assets/icons/svg/calendar_gray.svg',
                getDateDetail(widget.gathering.openingDate),
              ),
              const SizedBox(height: 16),
              kInformationCard(
                'assets/icons/svg/profile_gray.svg',
                '${widget.gathering.capacity}명',
              ),
              if (widget.gathering.isHaveEntryFee)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    kInformationCard(
                      'assets/icons/svg/wallet_gray.svg',
                      '${getMoneyFormat(widget.gathering.entryFee)}원',
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              kLocationCard(widget.gathering.place),
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 18, bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kWhiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: kGrey1C1C1EColor.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 ${widget.gathering.memberList.length}명이 참여중에 있습니다.',
                      style: TextStyle(
                        fontSize: 15,
                        color: kGrey363639Color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FutureBuilder(
                          future: FirebaseUserService.get(
                            id: widget.gathering.memberList.last,
                            field: 'profileImage',
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String image = snapshot.data as String;
                              if (widget.gathering.memberList.length > 1) {
                                return SizedBox(
                                  width: 64,
                                  height: 42,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(42),
                                            color: kWhiteC6C6C6Color,
                                            image: DecorationImage(
                                              image: NetworkImage(image),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(42),
                                              color: kMainColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kGrey1C1C1EColor
                                                      .withOpacity(0.1),
                                                  offset: const Offset(0, 4),
                                                  blurRadius: 10,
                                                )
                                              ]),
                                          child: Text(
                                            '+${widget.gathering.memberList.length - 1}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: kWhiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(42),
                                  color: kWhiteC6C6C6Color,
                                  image: DecorationImage(
                                    image: NetworkImage(image),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(42),
                                color: kWhiteC6C6C6Color,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 6),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: '/ ',
                                style: TextStyle(
                                  color: kMainColor,
                                ),
                              ),
                              TextSpan(
                                text: '${widget.gathering.capacity}',
                                style: TextStyle(
                                  color: kGrey48484AColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kMainBackgroundColor,
                          ),
                          child: Text(
                            '모임장과 채팅하기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kMainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 6),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 14,
                      height: 14,
                      child: Text(
                        'ⓘ',
                        style: TextStyle(
                          fontSize: 11,
                          color: kGrey8E8E93Color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11,
                            color: kGrey8E8E93Color,
                          ),
                          children: const [
                            TextSpan(text: '하루모임에 대해 궁금한 점이 있다면 '),
                            TextSpan(
                                text: '모임장과 채팅하기',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(text: '를 통해 물어보세요!'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget kInformationCard(String image, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: kGrey363639Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget kLocationCard(Map place) {
    GatheringPlace gatheringPlace =
        GatheringPlace.fromJson(place as Map<String, dynamic>);
    String placeDetail =
        '${gatheringPlace.city} ${gatheringPlace.county} ${gatheringPlace.detail}'
            .replaceAll('전체 ', '');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/svg/location_gray.svg',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeDetail,
                        style: TextStyle(
                          fontSize: 15,
                          color: kGrey363639Color,
                        ),
                      ),
                      FutureBuilder(
                        future: HttpService.searchPlaceWithKeyword(placeDetail),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: kGrey8E8E93Color,
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: kWhiteC6C6C6Color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
