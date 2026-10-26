class LogBookTemplateResponse {
  final TimesheetInfo timesheet;
  final TemplateInfo template;
  final List<TemplateField> fields;

  LogBookTemplateResponse({
    required this.timesheet,
    required this.template,
    required this.fields,
  });

  factory LogBookTemplateResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>;
    return LogBookTemplateResponse(
      timesheet: TimesheetInfo.fromJson(message['timesheet']),
      template: TemplateInfo.fromJson(message['template']),
      fields: (message['fields'] as List)
          .map((e) => TemplateField.fromJson(e))
          .toList(),
    );
  }
}

class TimesheetInfo {
  final String name;
  final String targetDate;
  final String employee;
  final String employeeName;
  final String contextType;
  final String assignment;
  final String assignmentStartDate;
  final String assignmentEndDate;
  final String customer;
  final String periodStart;
  final String periodEnd;
  final String status;
  final bool created;

  TimesheetInfo({
    required this.name,
    required this.targetDate,
    required this.employee,
    required this.employeeName,
    required this.contextType,
    required this.assignment,
    required this.assignmentStartDate,
    required this.assignmentEndDate,
    required this.customer,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
    required this.created,
  });

  factory TimesheetInfo.fromJson(Map<String, dynamic> json) {
    return TimesheetInfo(
      name: json['name'] ?? '',
      targetDate: json['target_date'] ?? '',
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
      contextType: json['context_type'] ?? '',
      assignment: json['assignment'] ?? '',
      assignmentStartDate: json['assignment_start_date'] ?? '',
      assignmentEndDate: json['assignment_end_date'] ?? '',
      customer: json['customer'] ?? '',
      periodStart: json['period_start'] ?? '',
      periodEnd: json['period_end'] ?? '',
      status: json['status'] ?? '',
      created: json['created'] ?? false,
    );
  }
}

class TemplateInfo {
  final String name;
  final int version;
  final String exportScope;

  TemplateInfo({
    required this.name,
    required this.version,
    required this.exportScope,
  });

  factory TemplateInfo.fromJson(Map<String, dynamic> json) {
    return TemplateInfo(
      name: json['name'] ?? '',
      version: json['version'] ?? 1,
      exportScope: json['export_scope'] ?? '',
    );
  }
}

class TemplateField {
  final String fieldname;
  final String label;
  final String fieldtype;
  final bool required;
  final String options;
  final String placeholder;
  final String scope;

  TemplateField({
    required this.fieldname,
    required this.label,
    required this.fieldtype,
    required this.required,
    required this.options,
    required this.placeholder,
    required this.scope,
  });

  factory TemplateField.fromJson(Map<String, dynamic> json) {
    return TemplateField(
      fieldname: json['fieldname'] ?? '',
      label: json['label'] ?? '',
      fieldtype: json['fieldtype'] ?? '',
      required: json['required'] ?? false,
      options: json['options'] ?? '',
      placeholder: json['placeholder'] ?? '',
      scope: json['scope'] ?? '',
    );
  }
}
