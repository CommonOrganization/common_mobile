import 'package:json_annotation/json_annotation.dart';
part 'report.g.dart';

@JsonSerializable()
class Report {
  final String reporterId;
  final String reportedId;
  final String timeStamp;
  Report({
    required this.reporterId,
    required this.reportedId,
    required this.timeStamp,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
