import 'package:flutter/material.dart';
import 'package:release_news/hospInfo.dart';
import 'package:release_news/doctorInfo.dart';
import 'package:release_news/depInfo.dart';
import 'package:release_news/locationInfo.dart';
import 'package:release_news/processInfo.dart';
import 'package:release_news/recedeInfo.dart';
import 'package:release_news/seeDocInfo.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'model/loopimage.dart';
import 'http/api.dart';
import 'http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        platform: TargetPlatform.iOS,
      ),
      home: MyHomePage(
          title: '信息发布', channel: IOWebSocketChannel.connect(Api.SOCKET_URL)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Loopimage loopimage;
  WebSocketChannel channel;
  MyHomePage(
      {Key key,
      @required this.title,
      @required this.channel,
      @required this.loopimage})
      : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List imageData;
  var imageType; //轮播图类型1主推，2常规
  var isVisible = false; //悬浮按钮是否可见

  var error;

  var countdownTime = 60;
  Timer timer;

  void initState() {
    super.initState();
    postImageType();
    _getMessage();
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
      postImage(2);
      if (mounted) {
        setState(() {
          imageType = 1;
          isVisible = true;
        });
      }
    }
  }

  postImage(type) async {
    var parmas = {'loopType': type};
    var response = await HttpUtil(context).post(Api.LOOPIMAGE, data: parmas);
    var loopImage = Loopimage.fromJson(json.decode(response.toString()));
    setState(() {
      imageData = loopImage.data; // 把从接口获取的列表赋值到_list
    });
  }

  postImageType() async {
    var parmas = {};
    var response =
        await HttpUtil(context).post(Api.LOOPIMAGE_TYPE, data: parmas);
    if (response == null) {
      setState(() {
        error = 1;
      });
    } else {
      setState(() {
        error = 0;
      });
      var imageStatus = Socket.fromJson(json.decode(response.toString()));
      //普通轮播
      if (imageStatus.data == 2) {
        //标记不加倒计时
        setStorage('0');
        //获取轮播图数据
        postImage(1);
        setState(() {
          imageType = 2;
          isVisible = false;
        });
      }
      //主推轮播
      else if (imageStatus.data == 1) {
        //标记加倒计时
        setStorage('1');
        //获取轮播图数据
        postImage(2);
        setState(() {
          imageType = 1;
          isVisible = true;
        });
      }
    }
  }

  void _hospInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HospInfoPage(
        loopimage: null,
      );
    })).then((data) {
      getStorage();
    });
  }

  void _doctorInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DoctorInfoPage(
        loopimage: null,
      );
    })).then((data) {
      getStorage();
    });
  }

  void _depInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DepInfoPage(
        loopimage: null,
      );
    })).then((data) {
      getStorage();
    });
  }

  void _location() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationPage(
        loopimage: null,
      );
    })).then((data) {
      getStorage();
    });
  }

  void _processInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProcessPage(
        loopimage: null,
      );
    })).then((data) {
      getStorage();
    });
  }

  void _recedeInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecedePage(
        loopimage: null,
      );
    })).then((data) {
      getStorage();
    });
  }

  void _seeDocInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SeeDocPage(
        loopimage: null,
      );
    })).then((data) {
      getStorage();
    });
  }

  void _getMessage() {
    widget.channel.stream.listen(this.onData, onError: onError, onDone: onDone);
  }

  onDone() {
    debugPrint("Socket is closed");
    widget.channel = IOWebSocketChannel.connect(Api.SOCKET_URL);
    this._getMessage();
  }

  onError(err) {
    debugPrint(err.runtimeType.toString());
    WebSocketChannelException ex = err;
    debugPrint(ex.message);
  }

  onData(event) {
    print(event);
    var socketData = Socket.fromJson(json.decode(event.toString())).data;
    if (socketData == 2) {
      setState(() {
        imageType = 2;
        isVisible = false;
      });
      setStorage('0');
      postImage(1);
    } else if (socketData == 1) {
      setState(() {
        imageType = 1;
        isVisible = true;
      });
      setStorage('1');
      postImage(2);
    }
  }

  setStorage(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isCountdown', value);
  }

  getStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isCountdown = prefs.getString('isCountdown');
    if (isCountdown == '1') {
      startCountdownTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return Scaffold(
        appBar: PreferredSize(
          child: Offstage(
            offstage: true,
          ),
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        ),
        floatingActionButton: new Visibility(
            visible: this.isVisible,
            child: FloatingActionButton(
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  //点击主页开始倒计时
                  setState(() {
                    imageType = 2;
                    isVisible = false;
                  });
                  postImage(1);
                  startCountdownTimer();
                },
                backgroundColor: Colors.blue)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Listener(
          onPointerDown: (event) => setState(() {
            if (timer != null) {
              timer.cancel();
            }
          }),
          child: _loopImageContainer(),
        ));
  }

  Widget _loopImageContainer() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //没有网络
    if (this.error == 1) {
      return Container(
          child: GestureDetector(
              onTap: () {
                postImageType();
              },
              child: Center(
                  child: Container(
                height: height * 0.5,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(bottom: height * 0.04),
                        child: Image.asset(
                          'lib/resource/images/error.png',
                          width: width * 0.5,
                        )),
                    Text('请检查您的网络，点击刷新',
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(38),
                            color: Color(0xff454545))),
                  ],
                ),
              ))));
    } else {
      if (this.imageType == 2 && this.imageData != null) {
        return Container(
            child: Column(children: <Widget>[
          //轮播图
          Container(
              width: width,
              height: height * 0.35,
              child: Swiper(
                itemBuilder: _swiperBuilder,
                itemCount: this.imageData.length,
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
          Center(
              child: Container(
            margin: EdgeInsets.fromLTRB(
                width * 0.04, height * 0.03, width * 0.04, height * 0.03),
            // width: width * 0.9,
            height: height * 0.59, //布局总高度
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                      onTap: _location,
                      child: Container(
                        height: height * 0.14, //top高
                        color: Color(0xFF57BBFB),
                        child: Center(
                          child: Container(
                            width: width * 0.6,
                            height: height * 0.09,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: width * 0.2,
                                  child: Image.asset(
                                      "lib/resource/images/location.png"),
                                ),
                                Container(
                                  width: width * 0.4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text('位置查询',
                                          style: new TextStyle(
                                            fontSize: ScreenUtil.getInstance()
                                                .setSp(38),
                                            color: Colors.white,
                                          )),
                                      Text('选择您要查询的位置',
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil.getInstance()
                                                .setSp(34),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
                Container(
                  height: height * 0.27, //middle高
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                            onTap: _hospInfo,
                            child: Container(
                                width: width * 0.35,
                                color: Color(0xFFE95F58),
                                child: Center(
                                    child: Container(
                                  width: width * 0.25,
                                  height: height * 0.125,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width: width * 0.15,
                                          height: width * 0.15,
                                          child: Image.asset(
                                            "lib/resource/images/hosp.png",
                                          )),
                                      Text('医院介绍',
                                          style: new TextStyle(
                                            fontSize: ScreenUtil.getInstance()
                                                .setSp(34),
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                )))),
                      ),
                      Container(
                        width: width * 0.54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                  onTap: _doctorInfo,
                                  child: Container(
                                    height: height * 0.1275,
                                    color: Color(0xFFFFB052),
                                    child: Center(
                                        child: Container(
                                      width: width * 0.36,
                                      height: height * 0.09,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              width: width * 0.15,
                                              height: width * 0.15,
                                              child: Image.asset(
                                                "lib/resource/images/doctor.png",
                                              )),
                                          Container(
                                            width: width * 0.2,
                                            child: Text('医生介绍',
                                                textAlign: TextAlign.center,
                                                style: new TextStyle(
                                                  fontSize:
                                                      ScreenUtil.getInstance()
                                                          .setSp(34),
                                                  color: Colors.white,
                                                )),
                                          )
                                        ],
                                      ),
                                    )),
                                  )),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                  onTap: _depInfo,
                                  child: Container(
                                    height: height * 0.1275,
                                    color: Color(0xFF00D7DC),
                                    child: Center(
                                        child: Container(
                                      width: width * 0.36,
                                      height: height * 0.09,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              width: width * 0.15,
                                              height: width * 0.15,
                                              child: Image.asset(
                                                "lib/resource/images/dep.png",
                                              )),
                                          Container(
                                            // color: Colors.red,
                                            width: width * 0.2,
                                            child: Text('科室介绍',
                                                textAlign: TextAlign.center,
                                                style: new TextStyle(
                                                  fontSize:
                                                      ScreenUtil.getInstance()
                                                          .setSp(34),
                                                  color: Colors.white,
                                                )),
                                          )
                                        ],
                                      ),
                                    )),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: height * 0.15, //bottom高
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                            onTap: _processInfo,
                            child: Container(
                                width: width * 0.35,
                                color: Color(0xFF32D392),
                                child: Center(
                                    child: Container(
                                  width: width * 0.25,
                                  height: height * 0.125,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width: width * 0.15,
                                          height: width * 0.15,
                                          child: Image.asset(
                                            "lib/resource/images/process.png",
                                          )),
                                      Text('全部流程',
                                          style: new TextStyle(
                                            fontSize: ScreenUtil.getInstance()
                                                .setSp(34),
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                )))),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                            onTap: _recedeInfo,
                            child: Container(
                                width: width * 0.255,
                                color: Color(0xFF57BBFB),
                                child: Center(
                                    child: Container(
                                  width: width * 0.25,
                                  height: height * 0.125,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width: width * 0.15,
                                          height: width * 0.15,
                                          child: Image.asset(
                                            "lib/resource/images/recede.png",
                                          )),
                                      Text('退费流程',
                                          style: new TextStyle(
                                            fontSize: ScreenUtil.getInstance()
                                                .setSp(34),
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                )))),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                            onTap: _seeDocInfo,
                            child: Container(
                                width: width * 0.255,
                                color: Color(0xFFFFB052),
                                child: Center(
                                    child: Container(
                                  width: width * 0.25,
                                  height: height * 0.125,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width: width * 0.15,
                                          height: width * 0.15,
                                          child: Image.asset(
                                            "lib/resource/images/seeDoc.png",
                                          )),
                                      Text('就诊流程',
                                          style: new TextStyle(
                                            fontSize: ScreenUtil.getInstance()
                                                .setSp(34),
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                )))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ]));
      } else if (this.imageType == 1 && this.imageData != null) {
        return Container(
          width: width,
          height: height,
          child: Swiper(
            itemBuilder: _swiperBuilder,
            itemCount: this.imageData.length,
            pagination: new SwiperPagination(
                builder: DotSwiperPaginationBuilder(
              color: Colors.black54,
              activeColor: Colors.white,
            )),
            control: new SwiperControl(),
            scrollDirection: Axis.horizontal,
            autoplay: true,
            onTap: (index) => print('点击了第$index个'),
          ),
        );
      } else {
        return Container();
      }
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
    widget.channel.sink.close();
    super.dispose();
  }
}

class Socket {
  int code;
  int data;
  String message;

  Socket({this.code, this.data, this.message});

  Socket.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
