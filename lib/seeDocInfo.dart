import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:async';
import 'model/loopimage.dart';
import 'model/allProcess.dart';
import 'http/api.dart';
import 'http/http.dart';

class SeeDocPage extends StatefulWidget {
  final Loopimage loopimage;
  final AllProcess allProcess;
  SeeDocPage({@required this.loopimage, this.allProcess});
  @override
  State<StatefulWidget> createState() {
    return new SeeDocPageState();
  }
}

class SeeDocPageState extends State<SeeDocPage> {
  List imageData;
  List processData;
  var more = 0;

  var countdownTime = 60;
  Timer timer;

  void initState() {
    super.initState();
    postLoopImage();
    postSeeDocInfo();
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

  postSeeDocInfo() async {
    var parmas = {
      'processName': '就诊流程',
    };
    var response =
        await HttpUtil(context).post(Api.SINGLEPROCESS, data: parmas);
    var processInfo = AllProcess.fromJson(json.decode(response.toString()));
    setState(() {
      processData = processInfo.data; // 把从接口获取的列表赋值到_list
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
            child: SingleChildScrollView(
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
                                        ScreenUtil.getInstance().setSp(30),
                                  )))),
                      Container(
                          width: width * 0.25,
                          alignment: new Alignment(0.0, 0.0),
                          child: Text(
                            "就诊流程",
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
              _imageBuilder()
            ])))));
  }

  Widget _imageBuilder() {
    if (processData != null) {
      return (Image.network(
        processData[0].processPicture,
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
