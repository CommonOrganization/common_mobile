import 'package:json_annotation/json_annotation.dart';
part 'gathering_apply_status.g.dart';

@JsonSerializable()
class GatheringApplyStatus  {
  final String status;
  final String gatheringId;
  final String applierId;
  GatheringApplyStatus({
    required this.status,
    required this.gatheringId,
    required this.applierId,
  });

  factory GatheringApplyStatus.fromJson(Map<String, dynamic> json) =>
      _$GatheringApplyStatusFromJson(json);
  Map<String, dynamic> toJson() => _$GatheringApplyStatusToJson(this);
}
