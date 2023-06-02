import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable(explicitToJson: true)
class Course {
  Course(
      {required this.id,
      required this.courseName,
      required this.courseNo,
      required this.credits,
      required this.teacher,
      required this.grade,
      required this.room,
      required this.capacity,
      required this.selected});

  @JsonKey(name: "id", defaultValue: 0)
  int id;
  @JsonKey(name: "course_name", defaultValue: "")
  String courseName;
  @JsonKey(name: "course_no", defaultValue: "")
  String courseNo;
  @JsonKey(name: "credits", defaultValue: 0)
  double credits;
  @JsonKey(name: "teacher", defaultValue: "")
  String teacher;
  @JsonKey(name: "grade", defaultValue: 0)
  int grade;
  @JsonKey(name: "room", defaultValue: "")
  String room;
  @JsonKey(name: "capacity", defaultValue: 0)
  int capacity;
  @JsonKey(name: "selected", defaultValue: 0)
  int selected;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
