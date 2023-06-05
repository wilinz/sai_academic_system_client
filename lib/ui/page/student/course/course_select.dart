import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/data/model/course/course.dart';
import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/ui/widget/empty_page_placeholder.dart';
import 'package:flutter_template/util/platform.dart';
import 'package:path/path.dart';

import '../../../../data/model/course/courses_response.dart';

class CourseSelectPage extends StatefulWidget {
  @override
  _CourseSelectPageState createState() => _CourseSelectPageState();
}

class _CourseSelectPageState extends State<CourseSelectPage>
    with AutomaticKeepAliveClientMixin {
  List<Course> _courses = [];
  bool _isLoading = false;
  List<Course> _selectedCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    if (_selectedCourses.isNotEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = await AppNetwork.getDio();
      final response = await dio.get('/course/selectable');
      final CourseResponse = CoursesResponse.fromJson(response.data);

      setState(() {
        _courses = CourseResponse.data;
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('选课'),
        actions: [
          if (_selectedCourses.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  if (_selectedCourses.length == _courses.length) {
                    _selectedCourses.clear();
                  } else {
                    _selectedCourses = List<Course>.from(_courses);
                  }
                });
              },
            ),
          if (PlatformUtil.isDesktop())
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _selectedCourses.isEmpty
                  ? () {
                      _fetchCourses();
                    }
                  : null,
            ),
        ],
      ),
      body: _courses.isEmpty
          ? EmptyDataPlaceholder(_fetchCourses)
          : _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: _fetchCourses,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(4.0),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              if (_selectedCourses.isNotEmpty) {
                                _selectCourse(course);
                              } else {
                                _showSelectDialog(context, course);
                              }
                            },
                            onLongPress: () {
                              // _selectCourse(course);
                            },
                            child: ListTile(
                              leading: _selectedCourses.contains(course)
                                  ? Icon(Icons.check_circle)
                                  : null,
                              title: Text(course.courseName),
                              subtitle: Text(course.grade.toString() +
                                  " | " +
                                  course.courseNo +
                                  " | " +
                                  course.teacher),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: _selectedCourses.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                _showSelectAllDialog(context);
              },
              child: Icon(Icons.done),
            ),
    );
  }

  void _selectCourse(Course Course) {
    setState(() {
      if (_selectedCourses.contains(Course)) {
        _selectedCourses.remove(Course);
      } else {
        _selectedCourses.add(Course);
      }
    });
  }

  /*
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
  * */
  Future<void> _showSelectDialog(BuildContext context, Course course) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('选课'),
          content: Text('确定要选择这门课程吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final dio = await AppNetwork.getDio();
                  final resp = await dio.post('/course/select',
                      data: {"course_id": course.id},
                      options: Options(contentType: AppNetwork.typeUrlEncode));

                  final result = resp.data;
                  if (result['code'] == 200) {
                    setState(() {
                      _courses.remove(course);
                    });
                    showSnackBar(context, "选课成功");
                  } else {
                    showSnackBar(context, "选课失败: ${result['msg']}");
                  }

                  Navigator.pop(context);
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSelectAllDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('批量选课'),
          content: Text('确定要选择这些课程吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final dio = await AppNetwork.getDio();
                  for (final course in _selectedCourses) {
                    await dio
                        .delete('/course', queryParameters: {"id": course.id});
                  }
                  setState(() {
                    _courses.removeWhere(
                        (Course) => _selectedCourses.contains(Course));
                    _selectedCourses.clear();
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
