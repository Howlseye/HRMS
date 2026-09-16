class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = 'method/login';
  static const String logout = 'method/logout';

  // Employee
  static const String getEmployees = 'resource/Employee';
  static const String getEmployeeDetail = 'resource/Employee/{id}';

  //Shift
  static const String getShift = 'resource/Shift Assignment?fields=["shift_type","start_date","end_date"]';
  static const String getShiftDetail = 'resource/Shift Type/{shift}';

  //attendance
  static const String getActivity = 'resource/Employee Checkin?fields=["*"]&filters=[["time", ">=", {start_date}], ["time", "<=", {end_date}]]';
  static const String getPresence = 'resource/Employee Checkin';
  static const String getAttendance = 'resource/Attendance?fields=["*"]';

  //check in & check out 
  static const String presence = 'resource/Employee Checkin?fields=["*"]&order_by=time desc&limit=10';
  
}
