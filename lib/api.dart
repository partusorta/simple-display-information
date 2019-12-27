class Api{
  static const String BASE_URL = 'http://192.168.7.71:10088/';

  static const String SOCKET_URL = 'ws://192.168.7.7:10088/machineSocket';

  static const String LOOPIMAGE = BASE_URL+'loopimage/selectloopimage';//轮播图

  static const String HOSPITAL_INFO = BASE_URL+'app/hospital/selecthospitalinfo';//医院介绍
  
  static const String DEPARTMENT_INFO = BASE_URL+'app/department/selectdepartment';//科室介绍

  static const String DOCTOR_INFO = BASE_URL+'app/doctor/selectalldoctor';//医生介绍

  static const String ALLPROCESS = BASE_URL+'app/process/selectallprocess';//全部流程

  static const String SINGLEPROCESS = BASE_URL+'app/process/selectprocess';//单一流程

  static const String LOCATION_INFO = BASE_URL+'app/site/getSiteList';//位置信息

  static const String DOCTOR_DETAIL = BASE_URL+'app/doctor/selectdoctorInfo';//医生详情

  static const String LOOPIMAGE_TYPE = BASE_URL+'loopimage/getLoopImageState';//查主推轮播图状态 1启用 2停用
}