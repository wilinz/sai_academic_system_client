import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable(explicitToJson: true)
class Student {
  Student(
      {required this.id,
      required this.majors,
      required this.grade,
      required this.studentNo,
      required this.name});

  @JsonKey(name: "id", defaultValue: 0)
  int id;
  @JsonKey(name: "majors", defaultValue: "")
  String majors;
  @JsonKey(name: "grade", defaultValue: 0)
  int grade;
  @JsonKey(name: "student_no", defaultValue: "")
  String studentNo;
  @JsonKey(name: "name", defaultValue: "")
  String name;

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}


