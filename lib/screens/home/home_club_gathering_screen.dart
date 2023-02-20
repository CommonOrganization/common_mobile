import 'package:flutter/material.dart';

import '../gathering_upload/club_gathering_upload/club_gathering_upload_main_screen.dart';
import 'components/top_add_container.dart';

class HomeClubGatheringScreen extends StatelessWidget {
  const HomeClubGatheringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopAddContainer(
          title: '새로운 소모임 만들기',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClubGatheringUploadMainScreen(),
            ),
          ),
        ),
      ],
    );
  }
}
