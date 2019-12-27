import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'model/loopimage.dart';
import 'model/department.dart';
import 'api.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'http.dart';

class DepInfoPage extends StatefulWidget {
  final Loopimage loopimage;
  final Department department;

  DepInfoPage({@required this.loopimage, this.department});
  @override
  State<StatefulWidget> createState() {
    return new DepInfoPageState();
  }
}

class DepInfoPageState extends State<DepInfoPage> {
  List imageData;
  List depData;
  var index = 0;
  var more = 1;
  var isUpButton = 0;
  var select = [1, 0, 0, 0, 0];
  var secSelect;

  var countdownTime = 60;
  Timer timer;

  void initState() {
    super.initState();
    postLoopImage();
    postDepInfo();
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

  postDepInfo() async {
    var parmas = {};
    var response =
        await HttpUtil(context).post(Api.DEPARTMENT_INFO, data: parmas);
    var depInfo = Department.fromJson(json.decode(response.toString()));
    var secSelectList = [];
    if (depInfo.data != null) {
      for (var i = 0; i < depInfo.data.length; i++) {
        if (i == 0) {
          secSelectList.add(1);
        } else {
          secSelectList.add(0);
        }
      }
      setState(() {
        secSelect = secSelectList;
      });
    //如果小于等于6条数据，展示所有数据
    if (depInfo.data.length <= 5) {
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
      DepData data = new DepData();
      data.id = 1;
      data.deptName = '收起更多';
      data.deptInfo = '';
      data.deptPicture = '';
      depInfo.data.add(data);

      //添加
      var list = this.secSelect;
      list.add(2);
      setState(() {
        secSelect = list;
      });
    }
    }
    setState(() {
      depData = depInfo.data;
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
                            "科室介绍",
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
              _barContainer(),
              _gridContainer(),
              Container(
                  width: width * 0.92,
                  child: Column(
                    children: <Widget>[
                      _imageBuilder(),
                      Container(
                          margin: EdgeInsets.only(top: width * 0.03),
                          child: Text(
                            depData != null ? depData[index].deptInfo : '',
                            style: TextStyle(
                                color: Color(0xFF454545),
                                fontSize: ScreenUtil.getInstance().setSp(32)),
                          ))
                    ],
                  )),
            ])))));
  }

  Widget _imageBuilder() {
    if (depData != null) {
      return (Image.network(
        depData[index].deptPicture,
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

  List<Widget> buildGridDepList(int number) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < number; i++) {
      widgetList.add(Container(
        child: GestureDetector(
          onTap: () {
            if (this.isUpButton == 1 && i == number - 1) {
              setState(() {
                this.more = 0; //状态为收起
                this.index = 0;
                this.select = [1, 0, 0, 0, 0];
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
              color: Color(this.secSelect[i] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
              child: Text(depData != null ? depData[i].deptName : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(
                          this.secSelect[i] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                      fontSize: ScreenUtil.getInstance().setSp(28))),
            ),
          ),
        ),
      ));
    }
    return widgetList;
  }

  Widget _gridContainer() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (this.more == 1) {
      return Container(
          child: GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.all(width * 0.04),
        primary: false,
        mainAxisSpacing: width * 0.025, // 竖向间距
        crossAxisCount: 5, // 横向 Item 的个数
        crossAxisSpacing: width * 0.04,
        childAspectRatio: 5 / 2,
        // 横向间距
        children: buildGridDepList(depData != null ? depData.length : 0),
      ));
    } else {
      return Container();
    }
  }

  Widget _barContainer() {
    if (this.more == 0) {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;
      return Container(
        width: width,
        height: width * 0.14,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 0;
                      select = [1, 0, 0, 0, 0];
                    });
                  },
                  child: Container(
                    width: width * 0.152,
                    height: width * 0.06,
                    alignment: Alignment(0, 0),
                    color: Color(this.select[0] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                    child: Text(depData != null ? depData[0].deptName : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(
                                this.select[0] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                            fontSize: ScreenUtil.getInstance().setSp(28))),
                  )),
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 1;
                      select = [0, 1, 0, 0, 0];
                    });
                  },
                  child: Container(
                    width: width * 0.152,
                    height: width * 0.06,
                    alignment: Alignment(0, 0),
                    color: Color(this.select[1] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                    child: Text(depData != null ? depData[1].deptName : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(
                                this.select[1] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                            fontSize: ScreenUtil.getInstance().setSp(28))),
                  ),
                )),
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 2;
                      select = [0, 0, 1, 0, 0];
                    });
                  },
                  child: Container(
                    width: width * 0.152,
                    height: width * 0.06,
                    alignment: Alignment(0, 0),
                    color: Color(this.select[2] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                    child: Text(depData != null ? depData[2].deptName : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(
                                this.select[2] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                            fontSize: ScreenUtil.getInstance().setSp(28))),
                  ),
                )),
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 3;
                      select = [0, 0, 0, 1, 0];
                    });
                  },
                  child: Container(
                    width: width * 0.152,
                    height: width * 0.06,
                    alignment: Alignment(0, 0),
                    color: Color(this.select[3] == 1 ? 0xFF57BBFB : 0xFFEAEAEA),
                    child: Text(depData != null ? depData[3].deptName : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(
                                this.select[3] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                            fontSize: ScreenUtil.getInstance().setSp(28))),
                  ),
                )),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: GestureDetector(
                  onTap: () {
                    var secSelectList = [];
                    if (this.depData != null) {
                      for (var i = 0; i < this.depData.length; i++) {
                        if (i == 0) {
                          secSelectList.add(1);
                        } else {
                          secSelectList.add(0);
                        }
                      }
                    }
                    setState(() {
                      this.more = 1;
                      this.index = 0;
                      secSelect = secSelectList;
                    });
                  },
                  child: Container(
                    alignment: Alignment(0, 0),
                    width: width * 0.152,
                    height: width * 0.06,
                    color: Color(0xFFEAEAEA),
                    child: Text(
                      '更多科室',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff32D392),
                          fontSize: ScreenUtil.getInstance().setSp(28)),
                    ),
                  )),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    this.timer.cancel();
    this.countdownTime = null;
    super.dispose();
  }
}
