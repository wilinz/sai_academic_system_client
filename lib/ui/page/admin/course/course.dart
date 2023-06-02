import 'package:flutter/material.dart';
import 'package:flutter_template/data/model/course/course.dart';
import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/util/platform.dart';

import '../../../../data/model/course/courses_response.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with AutomaticKeepAliveClientMixin {
  List<Course> _Courses = [];
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
      final response = await dio.get('/courses');
      final CourseResponse = CoursesResponse.fromJson(response.data);

      setState(() {
        _Courses = CourseResponse.data;
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
        title: const Text('课程信息管理'),
        actions: [
          if (_selectedCourses.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  if (_selectedCourses.length == _Courses.length) {
                    _selectedCourses.clear();
                  } else {
                    _selectedCourses = List<Course>.from(_Courses);
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchCourses,
              child: ListView.builder(
                padding: const EdgeInsets.all(4.0),
                itemCount: _Courses.length,
                itemBuilder: (context, index) {
                  final Course = _Courses[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (_selectedCourses.isNotEmpty) {
                            _selectCourse(Course);
                          } else {
                            _showEditDialog(course: Course, index: index);
                          }
                        },
                        onLongPress: () {
                          _selectCourse(Course);
                        },
                        child: ListTile(
                          leading: _selectedCourses.contains(Course)
                              ? Icon(Icons.check_circle)
                              : null,
                          title: Text(Course.courseName),
                          subtitle: Text(Course.grade.toString() +
                              " | " +
                              Course.courseNo +
                              " | " +
                              Course.teacher),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: _selectedCourses.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                _showEditDialog();
              },
              child: Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {
                _showDeleteDialog();
              },
              child: Icon(Icons.delete),
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
  Future<void> _showEditDialog({Course? course, int? index}) async {
    final courseNameController =
        TextEditingController(text: course?.courseName);
    final courseNoController = TextEditingController(text: course?.courseNo);
    final creditsController =
        TextEditingController(text: course?.credits.toString());
    final teacherController = TextEditingController(text: course?.teacher);

    final gradeController =
        TextEditingController(text: course?.grade.toString());
    final roomController = TextEditingController(text: course?.room);
    final capacityController =
        TextEditingController(text: course?.capacity.toString());
    final selectedController =
        TextEditingController(text: course?.selected.toString());

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(course == null ? '添加课程信息' : '修改课程信息'),
          content: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 400),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "课程名称",
                          hintText: "课程名称",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: courseNameController,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '课程名称不能为空';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "课号",
                          hintText: "课号",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: courseNoController,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '课号不能为空';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "学分",
                          hintText: "学分",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: creditsController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '学分不能为空';
                          }
                          if (double.tryParse(value ?? "") == null) {
                            return '学分必须为数字';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "教师",
                          hintText: "教师",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: teacherController,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '教师不能为空';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "年级",
                          hintText: "年级",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: gradeController,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '年级不能为空';
                          }
                          if (int.tryParse(value ?? "") == null) {
                            return '年级必须为数字';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "教室",
                          hintText: "教室",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: roomController,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '教室不能为空';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "容量",
                          hintText: "容量",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: capacityController,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '容量不能为空';
                          }
                          if (int.tryParse(value ?? "") == null) {
                            return '容量必须为数字';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "已选",
                          hintText: "已选",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: selectedController,
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return '已选人数不能为空';
                          }
                          if (int.tryParse(value ?? "") == null) {
                            return '已选人数必须为数字';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            if (course != null)
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the edit dialog
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('确认删除'),
                        content: Text('确定要删除该课程吗？'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false); // Return false
                            },
                            child: Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true); // Return true
                            },
                            child: Text('确定'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    try {
                      final dio = await AppNetwork.getDio();
                      await dio.delete('/course',
                          queryParameters: {"id": course.id});

                      setState(() {
                        _Courses.remove(course);
                      });
                      Navigator.pop(context); // Close the confirmation dialog
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
                child: Text('删除'),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() == true) {
                  final newCourse0 = Course(
                    id: course?.id ?? 0,
                    courseName: courseNameController.text,
                    courseNo: courseNoController.text,
                    credits: double.parse(creditsController.text),
                    teacher: teacherController.text,
                    room: roomController.text,
                    capacity: int.parse(capacityController.text),
                    selected: int.parse(selectedController.text),
                    grade: int.parse(gradeController.text),
                  );

                  try {
                    final dio = await AppNetwork.getDio();
                    final response = course == null
                        ? await dio.post('/course', data: newCourse0.toJson())
                        : await dio.put('/course', data: newCourse0.toJson());
                    final newCourse = course == null
                        ? Course.fromJson(response.data['data'])
                        : newCourse0;

                    setState(() {
                      course == null
                          ? _Courses.add(newCourse)
                          : _Courses[index!] = newCourse;
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print(e.toString());
                  }
                }
              },
              child: Text(index == null ? '添加' : '保存'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('批量删除课程信息'),
          content: Text('确定要删除选中的课程吗？'),
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
                  for (final Course in _selectedCourses) {
                    await dio
                        .delete('/course', queryParameters: {"id": Course.id});
                  }

                  setState(() {
                    _Courses.removeWhere(
                        (Course) => _selectedCourses.contains(Course));
                    _selectedCourses.clear();
                  });
                  Navigator.pop(context);
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text('删除'),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
