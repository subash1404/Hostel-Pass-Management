class Pass {
  Pass(
      {required this.passId,
      required this.studentId,
      required this.gender,
      required this.qrId,
      required this.status,
      required this.destination,
      required this.type,
      required this.isActive,
      required this.reason,
      required this.expectedInTime,
      required this.expectedInDate,
      required this.expectedOutTime,
      required this.expectedOutDate,
      required this.isSpecialPass,
      this.actualInTime,
      this.actualInDate,
      this.actualOutTime,
      this.actualOutDate,
      this.showQr,
      this.isLate,
      this.isExceeding
      // this.actualInTime,
      // this.actualInDate,
      // this.actualOutTime,
      // this.actualOutDate,
      });

  final String passId;
  final String studentId;
  final String gender;
  final String qrId;
  final String status;
  final String destination;
  final String type;
  final bool isActive;
  final String reason;
  final String expectedInTime;
  final String expectedInDate;
  final String expectedOutTime;
  final String expectedOutDate;
  final String? actualInTime;
  final String? actualInDate;
  final String? actualOutTime;
  final String? actualOutDate;
  final bool isSpecialPass;
  bool? showQr;
  bool? isLate;
  bool? isExceeding;
  // final String? actualInTime;
  // final String? actualInDate;
  // final String? actualOutTime;
  // final String? actualOutDate;
}
