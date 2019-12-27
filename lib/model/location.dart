abstract class LocationInterface {
  int get code;
  String get message;
  Data get data;
}

class Location implements LocationInterface {

  int code;
  String message;
  Data data;

  Location({this.code, this.message, this.data});

  Location.fromJson(Map<String, dynamic> json) {
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
  int total;
  List<Rows> rows;

  Data({this.total, this.rows});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = new List<Rows>();
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  int id;
  String siteName;
  String siteType;
  int orderNo;
  String sitePicture;

  Rows({this.id, this.siteName, this.siteType, this.orderNo, this.sitePicture});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['siteName'];
    siteType = json['siteType'];
    orderNo = json['orderNo'];
    sitePicture = json['sitePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['siteName'] = this.siteName;
    data['siteType'] = this.siteType;
    data['orderNo'] = this.orderNo;
    data['sitePicture'] = this.sitePicture;
    return data;
  }
}