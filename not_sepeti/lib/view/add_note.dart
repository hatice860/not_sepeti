import 'package:flutter/material.dart';

import 'package:not_sepeti/models/department.dart';
import 'package:not_sepeti/models/lessons.dart';
import 'package:not_sepeti/utils/constant.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({Key? key}) : super(key: key);

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
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
    return ListView.builder(
      shrinkWrap: true,
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
                final currentLesson = departmentLessons[index];
                return ListTile(
                  title: Text(currentLesson.lessonName.toString()),
                  onTap: () {
                    showNoteTitlesDialog(context, currentLesson);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showNoteTitlesDialog(BuildContext context, Lessons lesson) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Not Başlıkları"),
              SizedBox(height: 16),
              FutureBuilder<List<Map<String, Object?>>?>(
                future: databaseHelper.getNote(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final notes = snapshot.data!;
                    final noteTitles = notes
                        .where((note) => note['lessonID'] == lesson.lessonID)
                        .map((note) => note['notName'])
                        .toList();
                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: noteTitles.length,
                        itemBuilder: (context, index) {
                          final noteTitle = noteTitles[index];
                          return ListTile(
                            title: Text(noteTitle.toString()),
                            onTap: () {
                            },
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Hata: ${snapshot.error}");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Kapat'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
