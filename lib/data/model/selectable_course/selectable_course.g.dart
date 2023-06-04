// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selectable_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectableCourse _$SelectableCourseFromJson(Map<String, dynamic> json) =>
    SelectableCourse(
      code: json['code'] as int? ?? 0,
      msg: json['msg'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SelectableCourseToJson(SelectableCourse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
