import 'package:flutter/material.dart';

import 'components/top_add_container.dart';

class HomeClubGatheringScreen extends StatelessWidget {
  const HomeClubGatheringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopAddContainer(
          title: '새로운 소모임 만들기',
          onTap: () {
            print('하루모임');
          },
        ),
      ],
    );
  }
}
