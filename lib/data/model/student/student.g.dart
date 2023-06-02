// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: json['id'] as int? ?? 0,
      majors: json['majors'] as String? ?? '',
      grade: json['grade'] as int? ?? 0,
      studentNo: json['student_no'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'majors': instance.majors,
      'grade': instance.grade,
      'student_no': instance.studentNo,
      'name': instance.name,
    };
