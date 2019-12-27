import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:async';
import 'model/loopimage.dart';
import 'model/allProcess.dart';
import 'http/api.dart';
import 'http/http.dart';

class ProcessPage extends StatefulWidget {
  final Loopimage loopimage;
  final AllProcess allProcess;

  ProcessPage({@required this.loopimage, this.allProcess});
  @override
  State<StatefulWidget> createState() {
    return new ProcessPageState();
  }
}

class ProcessPageState extends State<ProcessPage> {
  List imageData;
  List processData;
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
    postProcess();
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

  postProcess() async {
    var parmas = {};
    var response = await HttpUtil(context).post(Api.ALLPROCESS, data: parmas);
    var processInfo = AllProcess.fromJson(json.decode(response.toString()));
    var secSelectList = [];
    if (processInfo.data != null) {
      for (var i = 0; i < processInfo.data.length; i++) {
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
    if (processInfo.data.length <= 5) {
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
      ProcessData secRow = new ProcessData();
      secRow.id = 1;
      secRow.processName = '收起更多';
      secRow.orderNo = 0;
      secRow.processPicture = '';
      processInfo.data.add(secRow);

      //添加
      var list = this.secSelect;
      list.add(2);
      setState(() {
        secSelect = list;
      });
    }
    setState(() {
      processData = processInfo.data;
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
                            "全部流程",
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
                            )),
                      ),
                    ]),
              ),
              _barContainer(),
              _gridContainer(),
              _imageBuilder(),
            ])))));
  }

  Widget _imageBuilder() {
    if (processData != null) {
      return (Image.network(
        processData[index].processPicture,
        fit: BoxFit.fitWidth,
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
              child: Text(
                processData != null ? processData[i].processName : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color:
                        Color(this.secSelect[i] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                    fontSize: ScreenUtil.getInstance().setSp(28)),
              ),
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
        children:
            buildGridDepList(processData != null ? processData.length : 0),
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
                    child: Text(
                        processData != null ? processData[0].processName : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(
                                this.select[0] == 1 ? 0xFFFFFFFF : 0xFFB4B4B4),
                            fontSize: ScreenUtil.getInstance().setSp(28))),
                  ),
                )),
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
                    child: Text(
                        processData != null ? processData[1].processName : '',
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
                    child: Text(
                        processData != null ? processData[2].processName : '',
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
                    child: Text(
                        processData != null ? processData[3].processName : '',
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
                    setState(() {
                      this.more = 1;
                    });
                  },
                  child: Container(
                    alignment: Alignment(0, 0),
                    width: width * 0.152,
                    height: width * 0.06,
                    color: Color(0xFFEAEAEA),
                    child: Text(
                      '更多流程',
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
