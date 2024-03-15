import 'package:common/constants/constants_enum.dart';
import 'package:common/controllers/screen_controller.dart';
import 'package:common/services/like_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatefulWidget {
  final String category;
  final String objectId;
  final String userId;
  final double size;
  const FavoriteButton({
    Key? key,
    required this.category,
    required this.objectId,
    required this.userId,
    this.size = 20,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() =>
      _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LikeService.isLikeObject(
        objectId: widget.objectId,
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
                  objectId: widget.objectId,
                  userId: widget.userId,
                );
              } else {
                await LikeService.likeObject(
                  objectId: widget.objectId,
                  userId: widget.userId,
                  likeType:
                      LikeTypeExtenstion.getLikeType(widget.category).name,
                );
              }
              if (!context.mounted) return;
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
