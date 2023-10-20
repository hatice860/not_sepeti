import 'package:flutter/material.dart';
import 'package:not_sepeti/utils/constant.dart';
import 'package:not_sepeti/view/add_note.dart';
import 'package:not_sepeti/view/home.dart';
import 'package:not_sepeti/view/not_item.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.primaryColor,
              title: const Center(
                child: Text(
                  'Not Sepeti',
                ),
              ),
            ),
            body: const TabBarView(
              children: [
               //  AddNoteView(),
                NotItem(),
                HomeView(),
              ],
            ),
            bottomNavigationBar: const BottomAppBar(
              child: TabBar(tabs: [
                  /* Tab(
                  icon: Icon(
                    Icons.note_alt,
                    color: AppColor.primaryColor,
                  ),
                ),*/
                Tab(
                  icon: Icon(
                    Icons.home,
                    size: 28,
                    color: AppColor.primaryColor,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.list,
                    size: 28,
                    color: AppColor.primaryColor,
                  ),
                ),
              ], indicatorColor: AppColor.primaryColor),
            )));
  }
}
