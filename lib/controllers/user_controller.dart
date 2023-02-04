import 'dart:developer';
import 'package:common/controllers/local_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/user/user.dart';
import '../services/firebase_user_service.dart';

class UserController extends ChangeNotifier {
  User? user;

  Future<bool> autoLogin() async {
    User? userInfo = await LocalController.getUserInfo();
    if (userInfo == null) return false;
    User? loginUserInfo = await FirebaseUserService.login(
        phone: userInfo.phone, password: userInfo.password);
    if (loginUserInfo == null) return false;
    user = loginUserInfo;
    notifyListeners();
    return true;
  }

  Future<bool> setUser(User newUser) async {
    try {
      user = newUser;
      await updateToken();
      notifyListeners();
      return true;
    } catch (e) {
      log('UserController - setUser Failed : $e');
      return false;
    }
  }

  Future<bool> refreshUser() async {
    try {
      if (user == null) return false;
      User? newUser = await FirebaseUserService.refresh(id: user!.id);
      if (newUser == null) return false;
      user = newUser;
      notifyListeners();
      return true;
    } catch (e) {
      log('UserController - refreshUser Failed : $e');
      return false;
    }
  }

  Future<void> logout() async {
    user = null;
    notifyListeners();
  }

  Future<void> updateToken() async {
    if (user == null) return;
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseUserService.update(
          id: user!.id, field: 'notificationToken', value: token);
    }
  }
}
