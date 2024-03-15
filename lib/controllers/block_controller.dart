import 'dart:developer';

import 'package:common/services/local_service.dart';
import 'package:flutter/material.dart';

class BlockController extends ChangeNotifier {
  List blockedObjectList = [];

  static final BlockController _instance = BlockController._internal();
  factory BlockController() => _instance;
  BlockController._internal() {
    log('blockController init');
    initializeBlockedObjectList();
  }

  void initializeBlockedObjectList() async {
    List localSavedBlockedObjectList =
        await LocalService.getBlockObjectList();
    blockedObjectList.addAll(localSavedBlockedObjectList);
  }

  Future<void> removeBlockedObject(String id) async {
    bool removeSuccess = await LocalService.removeBlockedObject(id);
    blockedObjectList.remove(id);
    if (removeSuccess) {
      notifyListeners();
    }
  }

  Future<void> blockObject(String id) async {
    bool blockSuccess = await LocalService.blockNewObject(id);
    blockedObjectList.add(id);
    if (blockSuccess) {
      notifyListeners();
    }
  }
}
