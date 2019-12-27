import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:async';
import 'model/loopimage.dart';
import 'model/location.dart';
import 'http/api.dart';
import 'http/http.dart';

class LocationPage extends StatefulWidget {
  final Loopimage loopimage;
  final Location location;

  LocationPage({@required this.loopimage, this.location});
  @override
  State<StatefulWidget> createState() {
    return new LocationPageState();
  }
}

class LocationPageState extends State<LocationPage> {
  List imageData;
  List locationData;
  List select = [1, 0, 0, 0, 0];
  List select6 = [1, 0, 0, 0, 0];
  List secSelect;
  var more = 0; //默认展开，不添加按钮
  var isUpButton = 0;
  var index = 0; //点击的二级按钮

  var countdownTime = 60;
  Timer timer;

  void initState() {
    super.initState();
    postLoopImage();
    postLocation('就诊科室');
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

  postLocation(typeString) async {
    setState(() {
      this.index = 0;
    });
    var parmas = {
      'siteType': typeString,
    };
    var response =
        await HttpUtil(context).post(Api.LOCATION_INFO, data: parmas);
    var locationInfo = Location.fromJson(json.decode(response.toString()));
    var secSelectList = [];
    if (locationInfo.data.rows != null) {
      for (var i = 0; i < locationInfo.data.rows.length; i++) {
        if (i == 0) {
          secSelectList.add(1);
        } else {
          secSelectList.add(0);
        }
      }
      setState(() {
        secSelect = secSelectList;
      });
    }
    //如果小于等于6条数据，展示所有数据
    if (locationInfo.data.rows.length <= 6) {
      setState(() {
        this.more = 1; //状态为展开
        this.isUpButton = 0; //不增加按钮
      });
    }
    //大于6条数据，展示一行，点击更多展示全部，并添加按钮收起
    else {
      setState(() {
        this.more = 0; //状态为收起
        this.isUpButton = 1; //增加一个按钮
      });

      //创建两个list
      Rows secRow = new Rows();
      secRow.id = 1;
      secRow.siteName = '收起更多';
      secRow.siteType = '';
      secRow.orderNo = 0;
      secRow.sitePicture = '';
      locationInfo.data.rows.add(secRow);

      //添加
      var list = this.secSelect;
      list.add(2);
      setState(() {
        secSelect = list;
      });
    }
    setState(() {
      locationData = locationInfo.data.rows;
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
                                        ScreenUtil.getInstance().setSp(30))),
                          )),
                      Container(
                          width: width * 0.25,
                          alignment: new Alignment(0.0, 0.0),
                          child: Text(
                            "位置查询",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(38),
                              color: Color(0xff4AAAFC),
                            ),
                          )),
                      Container(
                          width: width * 0.2,
                          // color: Colors.green,
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
              _barContainer(),
              _secbarContainer(),
              _gridContainer(),
              _imageBuilder(),
              // )
            ])))));
  }

  Widget _imageBuilder() {
    if (locationData != null) {
      return (Image.network(
        locationData[index].sitePicture,
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

  Widget _barContainer() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.04, 0, width * 0.04, 0),
      width: width,
      height: width * 0.14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              postLocation('就诊科室');
              setState(() {
                select = [1, 0, 0, 0, 0];
                select6 = [1, 0, 0, 0, 0];
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                alignment: Alignment(0, 0),
                width: width * 0.16,
                height: width * 0.07,
                color: Color(this.select[0] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                child: Text('就诊科室',
                    style: TextStyle(
                        color: Color(
                            this.select[0] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                        fontSize: ScreenUtil.getInstance().setSp(32))),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              postLocation('检查科室');
              setState(() {
                select = [0, 1, 0, 0, 0];
                select6 = [1, 0, 0, 0, 0];
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                alignment: Alignment(0, 0),
                width: width * 0.16,
                height: width * 0.07,
                color: Color(this.select[1] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                child: Text('检查科室',
                    style: TextStyle(
                        color: Color(
                            this.select[1] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                        fontSize: ScreenUtil.getInstance().setSp(32))),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              postLocation('病区住院');
              setState(() {
                select = [0, 0, 1, 0, 0];
                select6 = [1, 0, 0, 0, 0];
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                alignment: Alignment(0, 0),
                width: width * 0.16,
                height: width * 0.07,
                color: Color(this.select[2] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                child: Text(
                  '病区住院',
                  style: TextStyle(
                      color:
                          Color(this.select[2] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                      fontSize: ScreenUtil.getInstance().setSp(32)),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              postLocation('楼层信息');
              setState(() {
                select = [0, 0, 0, 1, 0];
                select6 = [1, 0, 0, 0, 0];
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                alignment: Alignment(0, 0),
                width: width * 0.16,
                height: width * 0.07,
                color: Color(this.select[3] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                child: Text('楼层信息',
                    style: TextStyle(
                        color: Color(
                            this.select[3] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                        fontSize: ScreenUtil.getInstance().setSp(32))),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              postLocation('辅助设施');
              setState(() {
                select = [0, 0, 0, 0, 1];
                select6 = [1, 0, 0, 0, 0];
              });
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  alignment: Alignment(0, 0),
                  width: width * 0.16,
                  height: width * 0.07,
                  color: Color(this.select[4] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                  child: Text('辅助设施',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(
                              this.select[4] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                          fontSize: ScreenUtil.getInstance().setSp(32))),
                )),
          )
        ],
      ),
    );
  }

  Widget _secbarContainer() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (this.more == 0 && this.locationData != null) {
      return Container(
        margin: EdgeInsets.fromLTRB(width * 0.04, 0, width * 0.04, 0),
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = 0;
                    this.select6 = [1, 0, 0, 0, 0];
                  });
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  width: width * 0.15,
                  height: width * 0.07,
                  // color: Color(0xFFEAEAEA),
                  child: Text(
                      locationData != null ? locationData[0].siteName : '',
                      style: TextStyle(
                          color: Color(
                              this.select6[0] == 1 ? 0xFF57BBFB : 0xFFB4B4B4),
                          fontSize: ScreenUtil.getInstance().setSp(28))),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = 1;
                    this.select6 = [0, 1, 0, 0, 0];
                  });
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  width: width * 0.15,
                  height: width * 0.07,
                  // color: Color(0xFFEAEAEA),
                  child: Text(
                      locationData != null ? locationData[1].siteName : '',
                      style: TextStyle(
                          color: Color(
                              this.select6[1] == 1 ? 0xFF57BBFB : 0xFFB4B4B4),
                          fontSize: ScreenUtil.getInstance().setSp(28))),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = 2;
                    this.select6 = [0, 0, 1, 0, 0];
                  });
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  width: width * 0.15,
                  height: width * 0.07,
                  // color: Color(0xFFEAEAEA),
                  child: Text(
                      locationData != null ? locationData[2].siteName : '',
                      style: TextStyle(
                          color: Color(
                              this.select6[2] == 1 ? 0xFF57BBFB : 0xFFB4B4B4),
                          fontSize: ScreenUtil.getInstance().setSp(28))),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = 3;
                    this.select6 = [0, 0, 0, 1, 0];
                  });
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  width: width * 0.15,
                  height: width * 0.07,
                  // color: Color(0xFFEAEAEA),
                  child: Text(
                      locationData != null ? locationData[3].siteName : '',
                      style: TextStyle(
                          color: Color(
                              this.select6[3] == 1 ? 0xFF57BBFB : 0xFFB4B4B4),
                          fontSize: ScreenUtil.getInstance().setSp(28))),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = 4;
                    this.select6 = [0, 0, 0, 0, 1];
                  });
                },
                child: Container(
                  alignment: Alignment(0, 0),
                  width: width * 0.15,
                  height: width * 0.07,
                  // color: Color(0xFFEAEAEA),
                  child: Text(
                      locationData != null ? locationData[4].siteName : '',
                      style: TextStyle(
                          color: Color(
                              this.select6[4] == 1 ? 0xFF57BBFB : 0xFFB4B4B4),
                          fontSize: ScreenUtil.getInstance().setSp(28))),
                )),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.more = 1; //状态为展开，提前已经添加了按钮
                });
              },
              child: Container(
                alignment: Alignment(0, 0),
                width: width * 0.15,
                height: width * 0.07,
                // color: Color(0xFFEAEAEA),
                child: Text('其他门诊',
                    style: TextStyle(
                        color: Color(0xff32D392),
                        fontSize: ScreenUtil.getInstance().setSp(28))),
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _gridContainer() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (this.more == 1) {
      return Container(
          child: GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(width * 0.04, 0, width * 0.04, 0),
        primary: false,
        mainAxisSpacing: 0, // 竖向间距
        crossAxisCount: 6, // 横向 Item 的个数
        crossAxisSpacing: 0,
        childAspectRatio: 4.28 / 2,
        // 横向间距
        children: buildGridDepList(locationData.length),
      ));
    } else {
      return Container();
    }
  }

  List<Widget> buildGridDepList(int number) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < number; i++) {
      widgetList.add(Container(
        child: GestureDetector(
          onTap: () {
            if (this.isUpButton == 1 && i == number - 1) {
              setState(() {
                this.more = 0; //状态为收起
              });
            } else {
              setState(() {
                this.index = i;
              });
              for (var j = 0; j < this.secSelect.length; j++) {
                if (j == i) {
                  setState(() {
                    this.secSelect[j] = 1;
                  });
                } else if (j != i && j != number - 1) {
                  setState(() {
                    this.secSelect[j] = 0;
                  });
                }
              }
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              alignment: Alignment(0, 0),
              // color: Color(0xFFEAEAEA),
              child: Text(locationData != null ? locationData[i].siteName : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(
                          this.secSelect[i] == 1 ? 0xFF57BBFB : 0xFFB4B4B4),
                      fontSize: ScreenUtil.getInstance().setSp(28))),
            ),
          ),
        ),
      ));
    }
    return widgetList;
  }

  @override
  void dispose() {
    this.timer.cancel();
    this.countdownTime = null;
    super.dispose();
  }
}
