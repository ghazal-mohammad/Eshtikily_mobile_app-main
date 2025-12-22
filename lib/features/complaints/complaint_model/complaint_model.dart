import 'package:meta/meta.dart';
import 'dart:convert';

class ComplaintsModel {
  Data data;
  String status;

  ComplaintsModel({
    required this.data,
    required this.status,
  });

  factory ComplaintsModel.fromRawJson(String str) => ComplaintsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ComplaintsModel.fromJson(Map<String, dynamic> json) => ComplaintsModel(
    data: Data.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
  };
}

class Data {
  List<Complaint> complaints;

  Data({
    required this.complaints,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    complaints: List<Complaint>.from(json["complaints"].map((x) => Complaint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "complaints": List<dynamic>.from(complaints.map((x) => x.toJson())),
  };
}

class Complaint {
  int id;
  String reference;
  int userId;
  dynamic employeeId;
  int departmentId;
  int typeId;
  int locationId;
  String description;
  dynamic employeeNotes;
  int requiresMoreAttachments;
  dynamic requestMessage;
  String status;
  dynamic deletedAt;
  String createdAt;
  String updatedAt;
  Department type;
  Department department;
  Department location;
  List<dynamic> attachments;
  List<History> histories;

  Complaint({
    required this.id,
    required this.reference,
    required this.userId,
    required this.employeeId,
    required this.departmentId,
    required this.typeId,
    required this.locationId,
    required this.description,
    required this.employeeNotes,
    required this.requiresMoreAttachments,
    required this.requestMessage,
    required this.status,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.department,
    required this.location,
    required this.attachments,
    required this.histories,
  });

  factory Complaint.fromRawJson(String str) => Complaint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
    id: json["id"],
    reference: json["reference"],
    userId: json["user_id"],
    employeeId: json["employee_id"],
    departmentId: json["department_id"],
    typeId: json["type_id"],
    locationId: json["location_id"],
    description: json["description"],
    employeeNotes: json["employee_notes"],
    requiresMoreAttachments: json["requires_more_attachments"],
    requestMessage: json["request_message"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    type: Department.fromJson(json["type"]),
    department: Department.fromJson(json["department"]),
    location: Department.fromJson(json["location"]),
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
    histories: List<History>.from(json["histories"].map((x) => History.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference": reference,
    "user_id": userId,
    "employee_id": employeeId,
    "department_id": departmentId,
    "type_id": typeId,
    "location_id": locationId,
    "description": description,
    "employee_notes": employeeNotes,
    "requires_more_attachments": requiresMoreAttachments,
    "request_message": requestMessage,
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "type": type.toJson(),
    "department": department.toJson(),
    "location": location.toJson(),
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "histories": List<dynamic>.from(histories.map((x) => x.toJson())),
  };
}

class Department {
  int id;
  String name;
  String createdAt;
  String updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromRawJson(String str) => Department.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class History {
  int id;
  int complaintId;
  dynamic oldStatus;
  String newStatus;
  String notes;
  String createdAt;
  String updatedAt;

  History({
    required this.id,
    required this.complaintId,
    required this.oldStatus,
    required this.newStatus,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory History.fromRawJson(String str) => History.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"],
    complaintId: json["complaint_id"],
    oldStatus: json["old_status"],
    newStatus: json["new_status"],
    notes: json["notes"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "complaint_id": complaintId,
    "old_status": oldStatus,
    "new_status": newStatus,
    "notes": notes,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
