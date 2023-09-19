import 'dart:developer';
import 'package:common/controllers/local_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/user/user.dart';
import '../services/user_service.dart';

class UserController extends ChangeNotifier {
  User? user;

  Future<bool> autoLogin() async {
    User? userInfo = await LocalController.getUserInfo();
    if (userInfo == null) return false;
    User? loginUserInfo = await UserService.login(
        phone: userInfo.phone, password: userInfo.password);
    if (loginUserInfo == null) return false;
    await LocalController.saveUserData(loginUserInfo);
    user = loginUserInfo;

    notifyListeners();
    log('${user?.id}유저 로그인');
    return true;
  }

  Future<bool> setUser(User newUser) async {
    try {
      user = newUser;
      await updateToken();
      notifyListeners();
      log('${user?.id}유저 로그인');
      return true;
    } catch (e) {
      log('UserController - setUser Failed : $e');
      return false;
    }
  }

  Future<bool> refreshUser() async {
    try {
      if (user == null) return false;
      User? newUser = await UserService.refresh(id: user!.id);
      if (newUser == null) return false;
      user = newUser;
      notifyListeners();
      log('${user?.id}유저 로그인');
      return true;
    } catch (e) {
      log('UserController - refreshUser Failed : $e');
      return false;
    }
  }

  Future<void> logout() async {
    log('${user?.id}유저 로그아웃');
    user = null;
    notifyListeners();
  }

  Future<void> updateToken() async {
    if (user == null) return;
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await UserService.update(
          id: user!.id, field: 'notificationToken', value: token);
    }
  }
}
