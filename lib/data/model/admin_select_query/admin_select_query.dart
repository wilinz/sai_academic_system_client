import 'package:flutter_template/data/model/course/course.dart';
import 'package:flutter_template/data/model/student/student.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_select_query.g.dart';

@JsonSerializable(explicitToJson: true)
class AdminSelectQueryResponse {
  AdminSelectQueryResponse(
      {required this.code,
      required this.msg,
      required this.data});

  @JsonKey(name: "code", defaultValue: 0)
  int code;
  @JsonKey(name: "msg", defaultValue: "")
  String msg;
  @JsonKey(name: "data", defaultValue: [])
  List<AdminSelectQuery> data;

  factory AdminSelectQueryResponse.fromJson(Map<String, dynamic> json) => _$AdminSelectQueryFromJson(json);

  Map<String, dynamic> toJson() => _$AdminSelectQueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AdminSelectQuery {
  AdminSelectQuery(
      {required this.course,
      required this.student});

  @JsonKey(name: "course")
  Course course;
  @JsonKey(name: "student")
  Student student;

  factory AdminSelectQuery.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}


