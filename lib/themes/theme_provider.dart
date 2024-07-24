import 'package:chat_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }


Future<void> saveTheme() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    await prefs.setBool('themeKey', _themeData==darkMode);
}

Future<void> loadTheme() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    bool isDarkMode= prefs.getBool('themeKey')??false;
    _themeData=isDarkMode ? darkMode:lightMode;
    notifyListeners();
}


}
