import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/screen_controller.dart';
import 'package:common/services/like_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class GatheringFavoriteButton extends StatefulWidget {
  final String category;
  final String gatheringId;
  final String userId;
  final double size;
  const GatheringFavoriteButton({
    Key? key,
    required this.category,
    required this.gatheringId,
    required this.userId,
    this.size = 20,
  }) : super(key: key);

  @override
  State<GatheringFavoriteButton> createState() =>
      _GatheringFavoriteButtonState();
}

class _GatheringFavoriteButtonState extends State<GatheringFavoriteButton> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LikeService.isLikeObject(
        objectId: widget.gatheringId,
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
                  objectId: widget.gatheringId,
                  userId: widget.userId,
                );
              } else {
                await LikeService.likeObject(
                  objectId: widget.gatheringId,
                  userId: widget.userId,
                  likeType: LikeTypeExtenstion.getLikeType(widget.category).name,
                );
              };
              if(!mounted) return;
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
