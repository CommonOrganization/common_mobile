import 'dart:developer';
import 'package:common/services/local_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/user/user.dart';
import '../services/user_service.dart';

class UserController extends ChangeNotifier {
  User? user;

  Future<bool> autoLogin() async {
    User? userInfo = await LocalService.getUserInfo();
    if (userInfo == null) return false;
    User? loginUser = await UserService.login(
        email: userInfo.email, password: userInfo.password);
    if (loginUser == null) return false;
    await LocalService.saveUserData(loginUser);
    user = loginUser;
    notifyListeners();
    log('${user?.id}유저 자동 로그인');
    return user != null;
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
      User? newUser = await UserService.getUser(id: user!.id);
      if (newUser == null) return false;
      user = newUser;
      notifyListeners();
      log('${user?.id}유저 새로고침');
      return true;
    } catch (e) {
      log('UserController - refreshUser Failed : $e');
      return false;
    }
  }

  Future<void> logout() async {
    await LocalService.logoutClearUserData();
    log('${user?.id}유저 로그아웃');
    user = null;
    notifyListeners();
  }

  Future<void> updateToken() async {
    if (user == null) return;
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      UserService.update(
          id: user!.id, field: 'notificationToken', value: token);
    }
  }
}
