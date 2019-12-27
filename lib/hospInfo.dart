import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'model/loopimage.dart';
import 'model/hospital.dart';
import 'api.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'http.dart';

class HospInfoPage extends StatefulWidget {
  final Loopimage loopimage;
  final Hospital hospital;

  HospInfoPage({@required this.loopimage, this.hospital});
  @override
  State<StatefulWidget> createState() {
    return new HospInfoPageState();
  }
}

class HospInfoPageState extends State<HospInfoPage> {
  List imageData;
  var info;
  var name;
  var picture;
  var more = 0;

  var countdownTime = 60;
  Timer timer;

  void initState() {
    super.initState();
    postLoopImage();
    posthospitalInfo();
    startCountdownTimer();
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    setState(() {
      countdownTime = 60;
    });
    timer = Timer.periodic(oneSec, callback);
  }

  void callback(timer) {
    var count = this.countdownTime;
    count--;
    setState(() {
      countdownTime = count;
    });
    if (this.countdownTime < 1) {
      timer.cancel();
      Navigator.pop(context);
    }
  }

  postLoopImage() async {
    var parmas = {'loopType': 1};
    var response = await HttpUtil(context).post(Api.LOOPIMAGE, data: parmas);
    var loopImage = Loopimage.fromJson(json.decode(response.toString()));
    setState(() {
      imageData = loopImage.data; // 把从接口获取的列表赋值到_list
    });
  }

  posthospitalInfo() async {
    var parmas = {};
    var response =
        await HttpUtil(context).post(Api.HOSPITAL_INFO, data: parmas);
    var hospitalData = Hospital.fromJson(json.decode(response.toString()));
    setState(() {
      name = hospitalData.data.hospitalName;
      picture = hospitalData.data.hospitalPicture;
      info = hospitalData.data.hospitalInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return new Scaffold(
        appBar: PreferredSize(
          child: Offstage(
            offstage: true,
          ),
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        ),
        body: Listener(
            onPointerDown: (event) => setState(() {
                  timer.cancel();
                  startCountdownTimer();
                }),
            child: Container(
                child: Column(children: <Widget>[
              Container(
                  // margin: EdgeInsets.only(bottom: 30),
                  width: width,
                  height: height * 0.3,
                  child: Swiper(
                    itemBuilder: _swiperBuilder,
                    itemCount: 3,
                    pagination: new SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                      color: Colors.black54,
                      activeColor: Colors.white,
                    )),
                    control: new SwiperControl(),
                    scrollDirection: Axis.horizontal,
                    autoplay: true,
                    onTap: (index) => print('点击了第$index个'),
                  )),
              Container(
                width: width,
                height: height * 0.06,
                color: Color(0xFFEFEFEF),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          alignment: Alignment(0, 0),
                          width: width * 0.2,
                          child: Container(
                            width: width * 0.07,
                            height: width * 0.07,
                            decoration: BoxDecoration(
                              border: new Border.all(
                                  color: Color(0xff4AAAFC),
                                  width: 1), // 边色与边宽度形
                              borderRadius: new BorderRadius.circular(
                                  width * 0.35), // 圆角度
                            ),
                            alignment: Alignment(0, 0),
                            margin: EdgeInsets.only(left: width * 0.04),
                            child: Text(this.countdownTime.toString() + 's',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff4AAAFC),
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(30))),
                          )),
                      Container(
                          width: width * 0.25,
                          alignment: new Alignment(0.0, 0.0),
                          child: Text(
                            "医院介绍",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(38),
                              color: Color(0xff4AAAFC),
                            ),
                          )),
                      Container(
                          width: width * 0.2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: new Border.all(
                                    color: Color(0xff4AAAFC),
                                    width: 1), // 边色与边宽度形
                                borderRadius:
                                    new BorderRadius.circular(4), // 圆角度
                              ),
                              margin: EdgeInsets.only(right: width * 0.04),
                              width: width * 0.1,
                              height: width * 0.07,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image.asset(
                                    'lib/resource/images/back.png',
                                    width: width * 0.04,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Text(
                                    '返回',
                                    style: TextStyle(
                                        color: Color(0xff4AAAFC),
                                        fontSize:
                                            ScreenUtil.getInstance().setSp(30)),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.02),
                width: width * 0.92,
                height: height * 0.62,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    _imageBuilder(),
                    Container(
                        margin: EdgeInsets.only(top: width * 0.03),
                        child: Text(
                          this.info ?? '',
                          style: TextStyle(
                              color: Color(0xFF454545),
                              fontSize: ScreenUtil.getInstance().setSp(32)),
                        ))
                  ],
                )),
              )
            ]))));
  }

  Widget _imageBuilder() {
    if (this.picture != null && this.picture != '') {
      return (Image.network(
        this.picture,
        fit: BoxFit.fitWidth,
      ));
    } else {
      return (Image.asset(
        "lib/resource/images/pic.png",
        fit: BoxFit.cover,
      ));
    }
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    if (imageData != null) {
      return (Image.network(
        imageData[index].imgUrl,
        fit: BoxFit.cover,
      ));
    } else {
      return (Image.asset(
        "lib/resource/images/pic.png",
        fit: BoxFit.cover,
      ));
    }
  }

  @override
  void dispose() {
    this.timer.cancel();
    this.countdownTime = null;
    super.dispose();
  }
}
