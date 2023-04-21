import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/constants_colors.dart';
import '../services/firebase_gathering_service.dart';

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
      future: FirebaseGatheringService.get(
          category: widget.category,
          id: widget.gatheringId,
          field: 'favoriteList'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List favoriteList = snapshot.data as List;
          bool value = favoriteList.contains(widget.userId);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (value) {
                favoriteList.remove(widget.userId);
              } else {
                favoriteList.add(widget.userId);
              }
              FirebaseGatheringService.update(
                category: widget.category,
                id: widget.gatheringId,
                field: 'favoriteList',
                value: favoriteList,
              ).then((value) => setState(() {}));
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              color: kWhiteColor,
              child: SvgPicture.asset(
                'assets/icons/svg/favorite_${value ? 'active' : 'inactive'}_20px.svg',
                width: widget.size,
                height: widget.size,
              ),
            ),
          );
        }
        return Container(
          width: widget.size,
          height: widget.size,
          color: kWhiteColor,
          child: SvgPicture.asset(
            'assets/icons/svg/favorite_inactive_20px.svg',
          ),
        );
      },
    );
  }
}
