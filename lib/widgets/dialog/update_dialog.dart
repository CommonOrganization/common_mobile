import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/constants_colors.dart';
import '../../constants/constants_value.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '업데이트 안내',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '안정적인 서비스 사용을 위해\n최신 버전으로 업데이트해주세요',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      if (await canLaunchUrl(Uri.parse(kPlayStoreMarketUrl))) {
                        await launchUrl(Uri.parse(kPlayStoreMarketUrl));
                        return;
                      }
                      if (await canLaunchUrl(Uri.parse(kPlayStoreUrl))) {
                        await launchUrl(Uri.parse(kPlayStoreUrl));
                      }
                    }
                    if(Platform.isIOS){
                      if (await canLaunchUrl(Uri.parse(kAppStoreUrl))) {
                        await launchUrl(Uri.parse(kAppStoreUrl));
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '커먼 업데이트',
                      style: TextStyle(
                        fontSize: 16,
                        color: kWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
