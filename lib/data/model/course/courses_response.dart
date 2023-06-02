import 'package:flutter_template/data/model/course/course.dart';
import 'package:json_annotation/json_annotation.dart';

part 'courses_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CoursesResponse {
  CoursesResponse(
      {required this.code,
      required this.msg,
      required this.data});

  @JsonKey(name: "code", defaultValue: 0)
  int code;
  @JsonKey(name: "msg", defaultValue: "")
  String msg;
  @JsonKey(name: "data", defaultValue: [])
  List<Course> data;

  factory CoursesResponse.fromJson(Map<String, dynamic> json) => _$CoursesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CoursesResponseToJson(this);
}
