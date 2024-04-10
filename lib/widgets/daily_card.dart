import 'package:common/models/daily/daily.dart';
import 'package:flutter/material.dart';

import '../constants/constants_colors.dart';
import '../screens/daily/daily_detail_screen.dart';

class DailyCard extends StatelessWidget {
  final Daily daily;
  const DailyCard({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DailyDetailScreen(daily: daily),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kDarkGray20Color,
          image: DecorationImage(
            image: NetworkImage(daily.mainImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
