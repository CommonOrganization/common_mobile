import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:common/constants/constants_colors.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants_value.dart';

String getNewCertificationNumber() {
  String newCertificationNumber = '';
  for (int i = 0; i < 6; i++) {
    newCertificationNumber += Random().nextInt(10).toString();
  }
  return newCertificationNumber;
}

String getSignatureKey({
  required String serviceId,
  required String timeStamp,
  required String accessKey,
  required String secretKey,
}) {
  String space = ' '; // one space
  String newLine = '\n'; // new line
  String method = 'POST'; // method
  String url = '/sms/v2/services/$serviceId/messages';

  StringBuffer buffer = StringBuffer();
  buffer.write(method);
  buffer.write(space);
  buffer.write(url);
  buffer.write(newLine);
  buffer.write(timeStamp);
  buffer.write(newLine);
  buffer.write(accessKey);

  var key = utf8.encode(secretKey);
  var signingKey = Hmac(sha256, key);

  var bytes = utf8.encode(buffer.toString());
  var digest = signingKey.convert(bytes);
  String signatureKey = base64.encode(digest.bytes);
  return signatureKey;
}

void showMessage(BuildContext context, {required String message}) async {
  try {
    Flushbar(
      backgroundColor: kFlushBarBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kWhiteColor,
          fontSize: 14,
        ),
      ),
      duration: const Duration(seconds: 2),
    ).show(context);
  } catch (e) {
    developer.log('showMessage error : $e');
  }
}

void launchServiceUsePolicy() async {
  bool canLaunchServiceUsePolicyUrl =
  await canLaunchUrl(Uri.parse(kServiceUsePolicyUrl));
  if (!canLaunchServiceUsePolicyUrl) return;
  launchUrl(Uri.parse(kServiceUsePolicyUrl));
}

void launchPersonalInformationProcessingPolicy() async {
  bool canLaunchPersonalInformationProcessingPolicyUrl =
      await canLaunchUrl(Uri.parse(kPersonalInformationProcessingPolicyUrl));
  if (!canLaunchPersonalInformationProcessingPolicyUrl) return;
  launchUrl(Uri.parse(kPersonalInformationProcessingPolicyUrl));
}


