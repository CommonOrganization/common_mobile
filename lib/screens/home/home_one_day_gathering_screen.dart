import 'package:flutter/material.dart';

import '../gathering_upload/one_day_gathering_upload/one_day_gathering_upload_main_screen.dart';
import 'components/top_add_container.dart';

class HomeOneDayGatheringScreen extends StatelessWidget {
  const HomeOneDayGatheringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopAddContainer(
          title: '새로운 하루모임 만들기',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OneDayGatheringUploadMainScreen(),
            ),
          ),
        ),
      ],
    );
  }
}
