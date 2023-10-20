import 'dart:math';
import 'package:flutter/material.dart';
import 'package:not_sepeti/models/notes.dart';
import 'package:not_sepeti/utils/constant.dart';
import 'package:not_sepeti/utils/database_helper.dart';
import 'package:not_sepeti/view/not_detail.dart';

class NotItem extends StatefulWidget {
  const NotItem({super.key});

  @override
  State<NotItem> createState() => _NotItemState();
}

class _NotItemState extends State<NotItem> {
  List<Notes> tumNotlar = [];
  late DatabaseHelper databaseHelper;
  Random random = Random();
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    _getNotes();
  }

  Future<void> _getNotes() async {
    final noteList = await databaseHelper.getNote();
    setState(() {
      tumNotlar = noteList!.map((map) => Notes.fromMap(map)).toList();
    });
  }

  Color generateRandomColor(Random random) {
    // Pastel ve nude tonlarında rastgele renk oluşturma
    final int red = random.nextInt(100) + 155;
    final int green = random.nextInt(100) + 155;
    final int blue = random.nextInt(100) + 155;
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotlar = isSearching
        ? tumNotlar
            .where((not) => not.notName!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList()
        : tumNotlar;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 25, 12, 0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  isSearching = value.length >=
                      2; // Arama yapılıp yapılmayacağını kontrol etmek için
                });
              },
              decoration: InputDecoration(
                  labelText: 'Not Başlığı Ara',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, // Primary color
                    ),
                  ),
                  labelStyle: const TextStyle(color: AppColor.primaryColor)),
            ),
          ),
          SizedBox(
            height: 650,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(8, 25, 8, 2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: filteredNotlar.length,
              itemBuilder: (BuildContext context, int index) {
                Color randomColor = generateRandomColor(random);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotDetail(
                            notDescription: tumNotlar[index].notDescripition),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: randomColor,
                      border: Border.all(
                        width: 3,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        filteredNotlar[index].notName!,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
