import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/constants_colors.dart';

class TopAddContainer extends StatelessWidget {
  final String title;
  final Function onTap;
  const TopAddContainer({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kMainBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  border: Border.all(color: kWhiteColor, width: 1),
                  borderRadius: BorderRadius.circular(42),
                  color: kMainColor,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset.zero,
                      color: kMainColor.withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ]),
              child: SvgPicture.asset(
                'assets/icons/svg/add.svg',
                width: 24,
                height: 24,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: kFontMainColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
