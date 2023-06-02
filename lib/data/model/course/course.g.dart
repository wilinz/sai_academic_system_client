// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as int? ?? 0,
      courseName: json['course_name'] as String? ?? '',
      courseNo: json['course_no'] as String? ?? '',
      credits: (json['credits'] as num?)?.toDouble() ?? 0,
      teacher: json['teacher'] as String? ?? '',
      grade: json['grade'] as int? ?? 0,
      room: json['room'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 0,
      selected: json['selected'] as int? ?? 0,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'course_name': instance.courseName,
      'course_no': instance.courseNo,
      'credits': instance.credits,
      'teacher': instance.teacher,
      'grade': instance.grade,
      'room': instance.room,
      'capacity': instance.capacity,
      'selected': instance.selected,
    };
