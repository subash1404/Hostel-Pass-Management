class Pass {
  Pass({
    required this.passId,
    required this.studentId,
    required this.qrId,
    required this.status,
    required this.destination,
    required this.type,
    required this.isActive,
    required this.reason,
    required this.inDate,
    required this.inTime,
    required this.outDate, 
    required this.outTime,
  });

  final String passId;
  final String studentId;
  final String qrId;
  final String status;
  final String destination;
  final String type;
  final bool isActive;
  final String reason;
  final String inTime;
  final String inDate;
  final String outTime;
  final String outDate;
}
