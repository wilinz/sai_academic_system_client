import 'package:flutter_template/data/model/student/student.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_response.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentsResponse {
  StudentsResponse(
      {required this.code,
      required this.msg,
      required this.data});

  @JsonKey(name: "code", defaultValue: 0)
  int code;
  @JsonKey(name: "msg", defaultValue: "")
  String msg;
  @JsonKey(name: "data", defaultValue: [])
  List<Student> data;

  factory StudentsResponse.fromJson(Map<String, dynamic> json) => _$StudentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsResponseToJson(this);
}
