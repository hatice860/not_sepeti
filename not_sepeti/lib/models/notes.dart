class Notes {
  int? notID;
  int? lessonID;
  String? notName;
  String? notDescripition;
  String notDate ="Tarih" ;

  Notes(this.lessonID, this.notName, this.notDescripition, notDate);
  //verileri yazarken
  Notes.withID(this.notID, this.lessonID, this.notName, this.notDescripition,
      this.notDate);
  //verileri okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notID'] = notID;
    map['lessonID'] = lessonID;
    map['notName'] = notName;
    map['notDescripition'] = notDescripition;
    map['notDate'] = notDate;

    return map;
  }

  Notes.fromMap(Map<String, dynamic> map) {
    this.notID = map['notID'];
    this.lessonID = map['lessonID'];
    this.notName = map['notName'];
    this.notDescripition = map['notDescripition'];
    this.notDate = map['notDate'];
  }
  @override
  String toString() {
    return 'Notes{noteID:$notID lessonID:$lessonID, notName:$notName, notDescripition:$notDescripition,notDate:$notDate }';
  }
}
