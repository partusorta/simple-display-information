abstract class HospInterface {
  int get code;
  String get message;
  Data get data;
}

class Hospital implements HospInterface {
  int code;
  String message;
  Data data;

  Hospital({this.code, this.message, this.data});

  Hospital.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String hospitalName;
  String hospitalInfo;
  String hospitalPicture;

  Data({this.id, this.hospitalName, this.hospitalInfo, this.hospitalPicture});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hospitalName = json['hospitalName'];
    hospitalInfo = json['hospitalInfo'];
    hospitalPicture = json['hospitalPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hospitalName'] = this.hospitalName;
    data['hospitalInfo'] = this.hospitalInfo;
    data['hospitalPicture'] = this.hospitalPicture;
    return data;
  }
}