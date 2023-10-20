import 'dart:io';
import 'package:flutter/services.dart';
import 'package:not_sepeti/models/department.dart';
import 'package:not_sepeti/models/lessons.dart';
import 'package:not_sepeti/models/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }
  DatabaseHelper._internal();

  Future<Database?> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "not_sepeti_son.db");

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(join("assets/database", "not_sepeti_son.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, Object?>>?> getDepartment() async {
    var db = await _getDatabase();
    var sonuc = await db?.query("department");
    return sonuc;
  }

  Future<int?> addDepartment(Department department) async {
    var db = await _getDatabase();
    var sonuc = await db!.insert("department", department.toMap());
    return sonuc;
  }

  Future<int?> updateDepartment(Department department) async {
    var db = await _getDatabase();
    var sonuc = await db!.update("department", department.toMap(),
        where: 'departmentID=?', whereArgs: [department.departmentID]);
    return sonuc;
  }

  Future<int?> deleteDepartment(int departmentID) async {
    var db = await _getDatabase();
    var sonuc = await db!.delete("department",
        where: 'departmentID=?', whereArgs: [departmentID]);
    return sonuc;
  }

  Future<List<Map<String, Object?>>?> getLessons() async {
    var db = await _getDatabase();
    var sonuc = await db?.query("lessons");
    return sonuc;
  }

  Future<int?> addLessons(Lessons lessons) async {
    var db = await _getDatabase();
    var sonuc = await db!.insert("lessons", lessons.toMap());
    return sonuc;
  }

  Future<int?> updateLessons(Lessons lessons) async {
    var db = await _getDatabase();
    var sonuc = await db!.update("lessons", lessons.toMap(),
        where: 'lessonID=?', whereArgs: [lessons.lessonID]);
    return sonuc;
  }

  Future<int?> deleteLessons(int lessonID) async {
    var db = await _getDatabase();
    var sonuc =
        await db!.delete("lessons", where: 'lessonID=?', whereArgs: [lessonID]);
    return sonuc;
  }

  Future<List<Map<String, Object?>>?> getNote() async {
    var db = await _getDatabase();
    var sonuc = await db?.query("notes");
    return sonuc;
  }

  Future<int?> addNote(Notes notes) async {
    var db = await _getDatabase();
    var sonuc = await db!.insert("notes", notes.toMap());
    return sonuc;
  }

  Future<int?> updateNote(Notes notes) async {
    var db = await _getDatabase();
    var sonuc = await db!.update("notes", notes.toMap(),
        where: 'noteID=?', whereArgs: [notes.notID]);
    return sonuc;
  }

  Future<int?> deleteNote(int noteID) async {
    var db = await _getDatabase();
    var sonuc =
        await db!.delete("notes", where: 'noteID=?', whereArgs: [noteID]);
    return sonuc;
  }
}
