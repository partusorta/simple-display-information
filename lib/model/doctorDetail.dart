abstract class DoctorDetailInterface {
  int get code;
  String get message;
  List<Data> get data;
}

class DoctorDetail implements DoctorDetailInterface {
  int code;
  String message;
  List<Data> data;

  DoctorDetail({this.code, this.message, this.data});

  DoctorDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  int id;
  String doctorName;
  String doctorTitle;
  String doctorInfo;
  String doctorPicture;
  int doctorDeptId;
  String deptName;

  Data(
      {this.id,
      this.doctorName,
      this.doctorTitle,
      this.doctorInfo,
      this.doctorPicture,
      this.doctorDeptId,
      this.deptName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorName = json['doctorName'];
    doctorTitle = json['doctorTitle'];
    doctorInfo = json['doctorInfo'];
    doctorPicture = json['doctorPicture'];
    doctorDeptId = json['doctorDeptId'];
    deptName = json['deptName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctorName'] = this.doctorName;
    data['doctorTitle'] = this.doctorTitle;
    data['doctorInfo'] = this.doctorInfo;
    data['doctorPicture'] = this.doctorPicture;
    data['doctorDeptId'] = this.doctorDeptId;
    data['deptName'] = this.deptName;
    return data;
  }
}