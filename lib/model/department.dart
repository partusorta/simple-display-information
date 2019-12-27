abstract class DepInterface {
  int get code;
  String get message;
  List<DepData> get data;
}

class Department implements DepInterface {
  int code;
  String message;
  List<DepData> data;

  Department({this.code, this.message, this.data});

  Department.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<DepData>();
      json['data'].forEach((v) {
        data.add(new DepData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DepData {
  int id;
  String deptName;
  String deptInfo;
  String deptPicture;

  DepData({this.id, this.deptName, this.deptInfo, this.deptPicture});

  DepData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deptName = json['deptName'];
    deptInfo = json['deptInfo'];
    deptPicture = json['deptPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deptName'] = this.deptName;
    data['deptInfo'] = this.deptInfo;
    data['deptPicture'] = this.deptPicture;
    return data;
  }
}