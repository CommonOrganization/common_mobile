import 'dart:developer';

import 'package:common/controllers/local_controller.dart';
import 'package:flutter/material.dart';

class BlockController extends ChangeNotifier {

  List blockedObjectList = [];

  static final BlockController _instance = BlockController._internal();
  factory BlockController() => _instance;
  BlockController._internal(){
    log('blockController init');
    initializeBlockedObjectList();
  }

  void initializeBlockedObjectList()async{
    List localSavedBlockedObjectList = await LocalController.getBlockObjectList();
    blockedObjectList.addAll(localSavedBlockedObjectList);
    blockedObjectList.add('oneDayGathering00000014');
  }

}
