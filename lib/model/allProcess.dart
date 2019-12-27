abstract class AllProcessInterface {
  int get code;
  String get message;
  List<ProcessData> get data;
}

class AllProcess implements AllProcessInterface {
  int code;
  String message;
  List<ProcessData> data;

  AllProcess({this.code, this.message, this.data});

  AllProcess.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ProcessData>();
      json['data'].forEach((v) {
        data.add(new ProcessData.fromJson(v));
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

class ProcessData {
  int id;
  String processName;
  int orderNo;
  String processPicture;

  ProcessData({this.id, this.processName, this.orderNo, this.processPicture});

  ProcessData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processName = json['processName'];
    orderNo = json['orderNo'];
    processPicture = json['processPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['processName'] = this.processName;
    data['orderNo'] = this.orderNo;
    data['processPicture'] = this.processPicture;
    return data;
  }
}