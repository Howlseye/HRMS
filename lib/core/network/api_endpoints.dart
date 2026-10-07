class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = 'method/login';
  static const String logout = 'method/logout';
  static const String resetPassword = 'method/frappe.core.doctype.user.user.reset_password';
  
  // Common
  static const String uploadFile = 'method/upload_file';

  // Employee
  static const String getEmployees = 'resource/Employee';
  static const String getEmployeeDetail = 'resource/Employee/{id}';

  //Shift
  static const String getShift = 'resource/Shift Assignment?fields=["shift_type","start_date","end_date", "shift_location"]';
  static const String getShiftDetail = 'resource/Shift Type/{shift}';
  static const String getShiftLocation = 'resource/Shift Location/{location}';

  //attendance
  static const String getActivity = 'resource/Employee Checkin?fields=["*"]&filters=[["time", ">=", {start_date}], ["time", "<=", {end_date}]]';
  static const String getPresence = 'resource/Employee Checkin';
  static const String getAttendance = 'resource/Attendance?fields=["*"]';

  //check in & check out 
  static const String presence = 'resource/Employee Checkin?fields=["*"]&order_by=time desc&limit=10';

  //Leave
  static const String getLeaveAllocations = "method/hrms.hr.doctype.leave_application.leave_application.get_leave_details?employee={employee_id}&date={today_date}";
  static const String getLeave = 'resource/Leave Application?fields=["status", "name", "posting_date", "leave_type", "from_date", "to_date", "total_leave_days", "description"]';
  static const String getLeaveDetail = 'resource/Leave Application/{id}';
  static const String getLeaveTypes = 'resource/Leave Type?fields=["*"]';
  static const String createLeave = 'resource/Leave Application';
  static const String cancelLeave = 'method/frappe.client.cancel';

  //Reimburse
  static const String getBenefitType = 'resource/Expense Claim Type';
  static const String getReimbursements = 'resource/Expense Claim';
  static const String getReimbursementsDetail = 'resource/Expense Claim/{id}';

}
