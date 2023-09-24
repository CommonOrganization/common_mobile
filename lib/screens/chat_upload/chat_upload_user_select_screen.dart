import 'package:common/controllers/user_controller.dart';
import 'package:common/models/gathering/gathering.dart';
import 'package:common/services/club_gathering_service.dart';
import 'package:common/services/one_day_gathering_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_colors.dart';
import '../../constants/constants_enum.dart';
import '../../services/user_service.dart';

class ChatUploadUserSelectScreen extends StatefulWidget {
  final Function onPressed;
  const ChatUploadUserSelectScreen({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<ChatUploadUserSelectScreen> createState() =>
      _ChatUploadUserSelectScreenState();
}

class _ChatUploadUserSelectScreenState
    extends State<ChatUploadUserSelectScreen> {
  String? _selectedGatheringId;
  final List<String> _userIdList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Consumer<UserController>(builder: (context, controller, child) {
        if (controller.user == null) return Container();
        String userId = controller.user!.id;
        return ListView(
          children: [
            FutureBuilder(
              future:
                  ClubGatheringService.getGatheringListWhichUserIsParticipating(
                      userId: userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Gathering> gatheringList =
                      snapshot.data as List<Gathering>;
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: gatheringList
                        .map((gathering) => kGatheringCard(gathering, userId))
                        .toList(),
                  );
                }
                return Container();
              },
            ),
            FutureBuilder(
              future: OneDayGatheringService
                  .getGatheringListWhichUserIsParticipating(userId: userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Gathering> gatheringList =
                      snapshot.data as List<Gathering>;
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: gatheringList
                        .map((gathering) => kGatheringCard(gathering, userId))
                        .toList(),
                  );
                }
                return Container();
              },
            ),
          ],
        );
      }),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          String? userId = context.read<UserController>().user?.id;
          if(userId==null) return;
          if(!_userIdList.contains(userId)){
            _userIdList.add(userId);
          }
          widget.onPressed(_userIdList);
        },
        child: Container(
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              color: _userIdList.isNotEmpty ? kMainColor : kFontGray100Color,
            ),
            child: Text(
              _userIdList.isNotEmpty ? '${_userIdList.length} 다음  ' : '다음',
              style: TextStyle(
                fontSize: 16,
                color: _userIdList.isNotEmpty ? kWhiteColor : kFontGray200Color,
                fontWeight: FontWeight.bold,
                height: 20 / 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget kGatheringCard(Gathering gathering, String userId) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _selectedGatheringId = gathering.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: kFontGray50Color,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kDarkGray20Color,
                    image: DecorationImage(
                      image: NetworkImage(
                        gathering.mainImage,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(builder: (context) {
                        CommonCategory category =
                            CommonCategoryExtenstion.getCategory(
                                gathering.category);
                        return Row(
                          children: [
                            Image.asset(
                              category.miniImage,
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                category.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kFontGray600Color,
                                  fontWeight: FontWeight.bold,
                                  height: 17 / 12,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      Text(
                        gathering.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kFontGray600Color,
                          height: 20 / 14,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      setState(() => _selectedGatheringId = gathering.id),
                  child: RotatedBox(
                    quarterTurns: _selectedGatheringId == gathering.id ? 1 : 0,
                    child: SvgPicture.asset(
                      'assets/icons/svg/arrow_more_22px.svg',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedGatheringId == gathering.id)
          ...gathering.memberList.map((memberId) {
            if (memberId == userId) return Container();
            return kUserCard(memberId);
          }).toList(),
      ],
    );
  }

  Widget kUserCard(String memberId) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() {
        if (_userIdList.contains(memberId)) {
          _userIdList.remove(memberId);
        } else {
          _userIdList.add(memberId);
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kFontGray50Color,
            ),
          ),
        ),
        child: Row(
          children: [
            FutureBuilder(
              future: UserService.get(id: memberId, field: 'profileImage'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      color: kDarkGray20Color,
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data as String),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: kDarkGray20Color,
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                    future: UserService.get(id: memberId, field: 'name'),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: kFontGray800Color,
                          height: 18 / 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  FutureBuilder(
                    future: UserService.get(id: memberId, field: 'information'),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: kFontGray400Color,
                          height: 16 / 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              _userIdList.contains(memberId)
                  ? Icons.check_circle_outline
                  : Icons.circle_outlined,
              size: 24,
              color: _userIdList.contains(memberId)
                  ? kMainColor
                  : kFontGray200Color,
            ),
          ],
        ),
      ),
    );
  }
}
