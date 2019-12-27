abstract class DoctorInterface {
  int get code;
  String get message;
  List<DoctorData> get data;
}

class Doctor implements DoctorInterface {
  int code;
  String message;
  List<DoctorData> data;

  Doctor({this.code, this.message, this.data});

  Doctor.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null && json['data'] != '') {
      data = new List<DoctorData>();
      json['data'].forEach((v) {
        data.add(new DoctorData.fromJson(v));
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

class DoctorData {
  int id;
  String doctorName;
  String doctorTitle;
  String doctorInfo;
  String doctorPicture;
  int doctorDeptId;
  String deptName;

  DoctorData(
      {this.id,
      this.doctorName,
      this.doctorTitle,
      this.doctorInfo,
      this.doctorPicture,
      this.doctorDeptId,
      this.deptName});

  DoctorData.fromJson(Map<String, dynamic> json) {
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