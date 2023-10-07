import 'package:chatapp/models/user.dart' as AppUser;
import 'package:flutter/material.dart';

class UserSave {
  static late AppUser.AppUser _user;

  static void setUser(AppUser.AppUser user) {
    _user = user;
  }

  static AppUser.AppUser getUser() {
    return _user;
  }
}