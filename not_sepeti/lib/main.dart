import 'package:flutter/material.dart';
import 'package:not_sepeti/utils/constant.dart';
import 'package:not_sepeti/utils/database_helper.dart';
import 'package:not_sepeti/widgets/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    var databaseHelper = DatabaseHelper();
    var gelenMAp = databaseHelper.getDepartment();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Not sepeti',
      theme: ThemeData(
          primaryColor: AppColor.primaryColor,
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: AppColor.primaryColor))),
      home: BottomNavigation(),
    );
  }
}
