// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_select_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSelectQueryResponse _$AdminSelectQueryFromJson(Map<String, dynamic> json) =>
    AdminSelectQueryResponse(
      code: json['code'] as int? ?? 0,
      msg: json['msg'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => AdminSelectQuery.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AdminSelectQueryToJson(AdminSelectQueryResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

AdminSelectQuery _$DataFromJson(Map<String, dynamic> json) => AdminSelectQuery(
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
      student: Student.fromJson(json['student'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(AdminSelectQuery instance) => <String, dynamic>{
      'course': instance.course.toJson(),
      'student': instance.student.toJson(),
    };
