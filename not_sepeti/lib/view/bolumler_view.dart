import 'package:flutter/material.dart';
import 'package:not_sepeti/models/department.dart';
import 'package:not_sepeti/models/lessons.dart';
import 'package:not_sepeti/utils/constant.dart';
import 'package:not_sepeti/utils/database_helper.dart';
import 'package:not_sepeti/view/add_note.dart';

class BolumlerView extends StatefulWidget {
  BolumlerView({super.key, required this.category, required this.dialogTur});
  String category;
  String dialogTur;

  @override
  State<BolumlerView> createState() => _BolumlerViewState();
}

class _BolumlerViewState extends State<BolumlerView> {
  int _expandedIndex = -1;
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text("Bölümler"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.category + " Eklemek için lütfen",
                    style: const TextStyle(fontSize: 14),
                  ),
                  TextButton(
                      onPressed: () {
                        departmanEkleDialog(context);
                      },
                      child: const Text(
                        "tıklayınız.",
                        style: TextStyle(color: AppColor.primaryColor),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 668,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                itemCount: tumDepartmanlar.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColor.lightPrimaryColor, width: 3)),
                    child: InkWell(
                      onTap: () {
                        dersEkleDialog(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: AppColor.primaryColor,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              tumDepartmanlar[index].departmentName!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void departmanEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniDepartmanAdi = 'Bilgisayar Mühendisliği';
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: Text(
                "Bölüm Ekle",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: formKey,
                      child: TextFormField(
                        onSaved: (yeniDeger) {
                          yeniDepartmanAdi = yeniDeger!;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Bölüm Adı',
                            border: OutlineInputBorder()),
                        validator: (girilenBolumAdi) {
                          if (girilenBolumAdi!.length < 3) {
                            return "En az 3 karakter giriniz";
                          }
                        },
                      )),
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('vazgeç'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColor.primaryColor),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          databaseHelper
                              .addDepartment(Department(yeniDepartmanAdi))
                              .then((departmentID) {
                            if (departmentID! > 0) {
                              setState(() {
                                this.departmentID = departmentID;
                              });
                              debugPrint("bölüm eklendi :$departmentID");
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Kaydet'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColor.primaryColor),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  void dersEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniDersAdi = 'Bilgisayar Mühendisliğine giriş';
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: Text(
                "Ders Ekle",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: formKey,
                      child: TextFormField(
                        onSaved: (yeniDeger) {
                          yeniDersAdi = yeniDeger!;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Ders Adı',
                            border: OutlineInputBorder()),
                        validator: (girilenDersAdi) {
                          if (girilenDersAdi!.length < 3) {
                            return "En az 3 karakter giriniz";
                          }
                        },
                      )),
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('vazgeç'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColor.primaryColor),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          databaseHelper
                              .addLessons(Lessons(departmentID, yeniDersAdi))
                              .then((lessonID) {
                            if (lessonID! > 0) {
                              debugPrint("ders eklendi :$lessonID )");
                            }
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Kaydet'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColor.primaryColor),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
