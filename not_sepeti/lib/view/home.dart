import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_sepeti/models/department.dart';
import 'package:not_sepeti/models/lessons.dart';
import 'package:not_sepeti/utils/constant.dart';
import 'package:not_sepeti/utils/database_helper.dart';
import 'package:not_sepeti/view/image_cropper_view.dart';
import 'package:not_sepeti/view/image_picker.dart';
import 'package:not_sepeti/view/recognized_screen.dart';
import 'package:not_sepeti/view/scanner_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _expandedIndex = -1;
  late List<Department> tumDepartmanlar;
  late List<Lessons> tumDersler;
  late DatabaseHelper databaseHelper;
  int departmentID = 1;

  @override
  void initState() {
    super.initState();
    tumDepartmanlar = [];
    tumDersler = [];

    databaseHelper = DatabaseHelper();
    databaseHelper.getDepartment().then((departmanIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in departmanIcerenMapListesi!) {
        tumDepartmanlar.add(Department.fromMap(okunanMap));
      }
      setState(() {});
    });
    databaseHelper.getLessons().then((dersleriiIcerenMapListesi) {
      for (Map<String, dynamic> okunanDers in dersleriiIcerenMapListesi!) {
        tumDersler.add(Lessons.fromMap(okunanDers));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: const EdgeInsets.fromLTRB(8, 40, 8, 12),
      itemCount: tumDepartmanlar.length,
      itemBuilder: (BuildContext context, int index) {
        final currentDepartment = tumDepartmanlar[index];
        final departmentLessons = tumDersler
            .where(
                (ders) => ders.departmentID == currentDepartment.departmentID)
            .toList();
        return ExpansionTile(
          textColor: AppColor.primaryColor,
          iconColor: AppColor.primaryColor,
          title: Text(currentDepartment.departmentName! + " Bölümü"),
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedIndex = expanded ? index : -1;
            });
          },
          initiallyExpanded: _expandedIndex == index,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: departmentLessons.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(departmentLessons[index].lessonName.toString()),
                  onTap: () {
                    notEkleDialog(context);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void notEkleDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text("Not Ekle"),
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          imagePickerModel(context, onCameraTap: () {
                            log('Camera');
                            pickImage(source: ImageSource.camera).then((value) {
                              if (value != '') {
                                imageCropperView(value, context).then((value) {
                                  if (value != '') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RecognizeScreen(
                                          path: value,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              }
                            });
                          }, onGalleryTap: () {
                            log('Gallery');
                            pickImage(source: ImageSource.gallery)
                                .then((value) {
                              if (value != '') {
                                imageCropperView(value, context).then((value) {
                                  if (value != '') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RecognizeScreen(
                                          path: value,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              }
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Not Ekle",
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: const Text(
                            'vazgeç',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: AppColor.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
 
/* import 'package:flutter/material.dart';
import 'package:not_sepeti/models/department.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  var formKey = GlobalKey<FormState>();
  late List<Department> tumDepartmanlar;
  late DatabaseHelper databaseHelper;
  int departmentID = 1;

  @override
  void initState() {
    super.initState();
    tumDepartmanlar = [];
    databaseHelper = DatabaseHelper();
    databaseHelper.getDepartment().then((departmanIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in departmanIcerenMapListesi!) {
        tumDepartmanlar.add(Department.fromMap(okunanMap));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          DropdownButton<int>(
              items: departmanItemleriOlustur(),
              onChanged: (secilenDepartmanID) {})
        ],
      ),
    );
  }

  departmanItemleriOlustur() {
    print(tumDepartmanlar);
  }
} */
