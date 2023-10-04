import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants_enum.dart';
import '../../../controllers/screen_controller.dart';
import '../../../services/like_service.dart';

class DailyFavoriteButton extends StatefulWidget {
  final String category;
  final String dailyId;
  final String userId;
  final double size;
  const DailyFavoriteButton({
    Key? key,
    required this.category,
    required this.dailyId,
    required this.userId,
    this.size = 20,
  }) : super(key: key);

  @override
  State<DailyFavoriteButton> createState() => _DailyFavoriteButtonState();
}

class _DailyFavoriteButtonState extends State<DailyFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LikeService.isLikeObject(
        objectId: widget.dailyId,
        userId: widget.userId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool value = snapshot.data as bool;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (value) {
                await LikeService.dislikeObject(
                  objectId: widget.dailyId,
                  userId: widget.userId,
                );
              } else {
                await LikeService.likeObject(
                  objectId: widget.dailyId,
                  userId: widget.userId,
                  likeType:
                      LikeTypeExtenstion.getLikeType(widget.category).name,
                );
              }
              if (!mounted) return;
              context.read<ScreenController>().pageRefresh();
              setState(() {});
            },
            child: SvgPicture.asset(
              'assets/icons/svg/favorite_${value ? 'active' : 'inactive'}_${widget.size.toInt()}px.svg',
              width: widget.size,
              height: widget.size,
            ),
          );
        }
        return SvgPicture.asset(
          'assets/icons/svg/favorite_inactive_20px.svg',
          width: widget.size,
          height: widget.size,
        );
      },
    );
  }
}
