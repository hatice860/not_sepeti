class Department {
  int? departmentID;
  String? departmentName;

  Department(this.departmentName);
  //kategori eklerken kullanılacak
  Department.withID(this.departmentID, this.departmentName);
  //kategorileri db'den okurken kullanılır
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['departmentID'] = departmentID;
    map['departmentName'] = departmentName;
    return map;
  }

  Department.fromMap(Map<String, dynamic> map) {
    this.departmentID = map['departmentID'] ;
    this.departmentName = map['departmentName'];
  }
  @override
  String toString() {
    return 'Department{departmentID:$departmentID, departmentName:$departmentName}';
  }
}
