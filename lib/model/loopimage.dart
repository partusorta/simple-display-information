abstract class LoopInterface {
  int get code;
  //类目名称
  String get message;
  //描述
  List<Data> get data;
}

class Loopimage implements LoopInterface {
  int code;
  String message;
  List<Data> data;

  Loopimage({this.code, this.message, this.data});

  Loopimage.fromJson(Map<String, dynamic> json) {
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
  String loopName;
  String imgUrl;
  int orderNo;
  int loopType;
  Null state;
  String createTime;

  Data(
      {this.id,
      this.loopName,
      this.imgUrl,
      this.orderNo,
      this.loopType,
      this.state,
      this.createTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loopName = json['loopName'];
    imgUrl = json['imgUrl'];
    orderNo = json['orderNo'];
    loopType = json['loopType'];
    state = json['state'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['loopName'] = this.loopName;
    data['imgUrl'] = this.imgUrl;
    data['orderNo'] = this.orderNo;
    data['loopType'] = this.loopType;
    data['state'] = this.state;
    data['createTime'] = this.createTime;
    return data;
  }
}
