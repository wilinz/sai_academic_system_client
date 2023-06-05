import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/data/model/admin_select_query/admin_select_query.dart';
import 'dart:convert';

import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/ui/widget/empty_page_placeholder.dart';

class CourseInfoPage extends StatefulWidget {
  CourseInfoPage();

  @override
  _CourseInfoPageState createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends State<CourseInfoPage>
    with AutomaticKeepAliveClientMixin {
  List<AdminSelectQuery> selectedCourses = [];

  @override
  bool get wantKeepAlive => true;

  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _studentNameController = TextEditingController();

  void _getSelectedCourses(
      {String courseName = '', String studentName = ''}) async {
    try {
      final dio = await AppNetwork.getDio();
      final response = await dio.get('/course/selected/admin',
          queryParameters: {
            'course_name': courseName,
            'student_name': studentName
          });

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          selectedCourses = AdminSelectQueryResponse.fromJson(data).data;
        });
      } else {
        throw Exception('Failed to load course selection');
      }
    } catch (e) {
      throw Exception('Failed to load course selection: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getSelectedCourses();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: Text('选课信息'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "课程名称",
                hintText: "课程名称",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              controller: _courseNameController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return '课程名称不能为空';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "学生姓名",
                hintText: "学生姓名",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              controller: _studentNameController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return '学生姓名不能为空';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _getSelectedCourses(courseName:_courseNameController.text,studentName:_studentNameController.text);
                },
                child: Text('搜索'),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: selectedCourses.isEmpty
                  ? EmptyDataPlaceholder(() async {})
                  : ListView.builder(
                      itemCount: selectedCourses.length,
                      itemBuilder: (context, index) {
                        final course = selectedCourses[index];
                        return ListTile(
                          title: Text(
                            course.course.courseName +
                                "  " +
                                course.student.name,
                            style: TextStyle(fontSize: isDesktop ? 18 : 14),
                          ),
                          subtitle: Text(
                            '教师: ${course.course.teacher}, 年级: ${course.course.grade}',
                            style: TextStyle(fontSize: isDesktop ? 16 : 12),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
