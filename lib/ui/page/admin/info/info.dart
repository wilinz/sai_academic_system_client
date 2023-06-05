import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_template/data/network.dart';

class CourseInfoPage extends StatefulWidget {

  CourseInfoPage();

  @override
  _CourseInfoPageState createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends State<CourseInfoPage> {
  List<Map<String, dynamic>> selectedCourses = [];

  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _studentNameController = TextEditingController();

  void _getSelectedCourses() async {
    try {
      final dio = await AppNetwork.getDio();
      final response = await dio.get('http://yourbackendserver.com/api/selected_courses', queryParameters: {});

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          selectedCourses = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load selected courses');
      }
    } catch (e) {
      throw Exception('Failed to load selected courses: $e');
    }
  }

  void _getCourseSelectionByCourseName(String courseName) async {
    try {
      final dio = await AppNetwork.getDio();
      final response = await dio.get('http://yourbackendserver.com/api/course_selection', queryParameters: {'courseName': courseName});

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          selectedCourses = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load course selection');
      }
    } catch (e) {
      throw Exception('Failed to load course selection: $e');
    }
  }

  void _getCourseSelectionByStudentName(String studentName) async {
    try {
      final dio = await AppNetwork.getDio();
      final response = await dio.get(
        'http://yourbackendserver.com/api/course_selection',
        queryParameters: {'studentName': studentName},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          selectedCourses = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load course selection');
      }
    } catch (e) {
      throw Exception('Failed to load course selection: ${e.toString()}');
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
            ElevatedButton(
              onPressed: () {
                _getCourseSelectionByCourseName(_courseNameController.text);
              },
              child: Text('按课程名称搜索'),
            ),
            SizedBox(height: 32),
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
            ElevatedButton(
              onPressed: () {
                _getCourseSelectionByStudentName(_studentNameController.text);
              },
              child: Text('按学生姓名搜索'),
            ),
            SizedBox(height: 32),
            Expanded(
              child: selectedCourses.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: selectedCourses.length,
                itemBuilder: (context, index) {
                  final course = selectedCourses[index];
                  return ListTile(
                    title: Text(
                      course['courseName'],
                      style: TextStyle(fontSize: isDesktop ? 18 : 14),
                    ),
                    subtitle: Text(
                      'Teacher: ${course['teacherName']}, Grade: ${course['grade']}',
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