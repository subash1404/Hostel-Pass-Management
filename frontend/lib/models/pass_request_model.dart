import 'package:hostel_pass_management/models/pass_model.dart';

class PassRequest extends Pass {
  PassRequest(
      {
      // Parent Class Constructor parameters
      required super.passId,
      required super.studentId,
      required super.qrId,
      required super.status,
      required super.destination,
      required super.type,
      required super.isActive,
      required super.reason,
      required super.expectedInTime,
      required super.expectedInDate,
      required super.expectedOutTime,
      required super.expectedOutDate,
      required super.isSpecialPass,
      required super.gender,
      super.actualInDate,
      super.actualInTime,
      super.actualOutDate,
      super.actualOutTime,
      super.isLate,
      super.isExceeding,

      // This Class Constructor parameters
      required this.dept,
      required this.fatherPhNo,
      required this.motherPhNo,
      required this.blockNo,
      required this.phNo,
      required this.roomNo,
      required this.studentName,
      required this.year,
      required this.approvedBy,
      required this.confirmedWith});

  final String studentName;
  final int year;
  final String dept;
  final int roomNo;
  final String phNo;
  final String fatherPhNo;
  final String motherPhNo;
  final int blockNo;
  final String approvedBy;
  final String confirmedWith;
}
