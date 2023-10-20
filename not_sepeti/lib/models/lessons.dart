class Lessons {
  int? lessonID;
  int? departmentID;
  String? lessonName;

  Lessons(this.departmentID, this.lessonName);
  //verileri yazarken
  Lessons.withID(this.lessonID, this.departmentID, this.lessonName);
  //verileri okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['lessonID'] = lessonID;
    map['departmentID'] = departmentID;
    map['lessonName'] = lessonName;

    return map;
  }

  Lessons.fromMap(Map<String, dynamic> map) {
    this.lessonID = map['lessonID'];
    this.departmentID = map['departmentID'];
    this.lessonName = map['lessonName'];
  }
  @override
  String toString() {
    return 'Lessons{ lessonID:$lessonID, departmentID:$departmentID, lessonName:$lessonName }';
  }
}
