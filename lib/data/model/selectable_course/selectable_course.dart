import 'package:flutter_template/data/model/course/course.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selectable_course.g.dart';

@JsonSerializable(explicitToJson: true)
class SelectableCourse {
  SelectableCourse(
      {required this.code,
      required this.msg,
      required this.data});

  @JsonKey(name: "code", defaultValue: 0)
  int code;
  @JsonKey(name: "msg", defaultValue: "")
  String msg;
  @JsonKey(name: "data", defaultValue: [])
  List<Course> data;

  factory SelectableCourse.fromJson(Map<String, dynamic> json) => _$SelectableCourseFromJson(json);

  Map<String, dynamic> toJson() => _$SelectableCourseToJson(this);
}
