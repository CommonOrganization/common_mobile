import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/models/user/user.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants_colors.dart';
import '../../profile/profile_screen.dart';

class DrawerMemberCard extends StatelessWidget {
  final User user;
  final bool isMe;
  const DrawerMemberCard({super.key, required this.user, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId: user.id),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 20,
        ),
        width: double.infinity,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: user.profileImage,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(42),
                      color: kDarkGray20Color,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholder: (context, url) => Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(42),
                  color: kDarkGray20Color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (isMe)
              Container(
                margin: const EdgeInsets.only(right: 6,top: 4),
                alignment: Alignment.center,
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(30),
                  color: kFontGray100Color,
                ),
                child: Text(
                  '나',
                  style: TextStyle(
                    fontSize: 10,
                    height: 12 / 10,
                    letterSpacing: -0.5,
                    color: kFontGray400Color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  color: kFontGray800Color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
