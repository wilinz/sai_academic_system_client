import 'package:flutter/material.dart';
import 'package:flutter_template/data/model/student/student_response.dart';
import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/util/platform.dart';

import '../../../../data/model/student/student.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage>
    with AutomaticKeepAliveClientMixin {
  List<Student> _students = [];
  bool _isLoading = false;
  List<Student> _selectedStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    if (_selectedStudents.isNotEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = await AppNetwork.getDio();
      final response = await dio.get('/students');
      final studentResponse = StudentsResponse.fromJson(response.data);

      setState(() {
        _students = studentResponse.data;
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
        title: const Text('学生信息管理'),
        actions: [
          if (_selectedStudents.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  if (_selectedStudents.length == _students.length) {
                    _selectedStudents.clear();
                  } else {
                    _selectedStudents = List<Student>.from(_students);
                  }
                });
              },
            ),
          if (PlatformUtil.isDesktop())
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _selectedStudents.isEmpty
                  ? () {
                      _fetchStudents();
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
              onRefresh: _fetchStudents,
              child: ListView.builder(
                padding: const EdgeInsets.all(4.0),
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (_selectedStudents.isNotEmpty) {
                            _selectStudent(student);
                          } else {
                            _showEditDialog(student: student, index: index);
                          }
                        },
                        onLongPress: () {
                          _selectStudent(student);
                        },
                        child: ListTile(
                          leading: _selectedStudents.contains(student)
                              ? Icon(Icons.check_circle)
                              : null,
                          title: Text(student.name),
                          subtitle: Text(student.grade.toString() +
                              " | " +
                              student.studentNo +
                              " | " +
                              student.majors),
                          trailing: Text(
                              student.username.isEmpty ? "未注册" : "已注册",
                              style: TextStyle(
                                  color: !student.username.isEmpty
                                      ? Colors.green
                                      : Colors.red)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: _selectedStudents.isEmpty
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
              child: Icon(Icons.delete_outline),
            ),
    );
  }

  void _selectStudent(Student student) {
    setState(() {
      if (_selectedStudents.contains(student)) {
        _selectedStudents.remove(student);
      } else {
        _selectedStudents.add(student);
      }
    });
  }

  Future<void> _showEditDialog({Student? student, int? index}) async {
    final nameController = TextEditingController(text: student?.name);
    final usernameController = TextEditingController(text: student?.username);
    final studentNoController = TextEditingController(text: student?.studentNo);
    final gradeController =
        TextEditingController(text: student?.grade.toString());
    final majorsController = TextEditingController(text: student?.majors);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(student == null ? '添加学生信息' : '修改学生信息'),
          content: Form(
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
                        labelText: "姓名",
                        hintText: "姓名",
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return '姓名不能为空';
                        }
                        return null;
                      },
                    ),
                    if (student != null) SizedBox(height: 8),
                    if (student != null)
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "登录用户名",
                          hintText: "登录用户名",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        controller: usernameController,
                      ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "学号",
                        hintText: "学号",
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      controller: studentNoController,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return '学号不能为空';
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      controller: gradeController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return '年级不能为空';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "专业",
                        hintText: "专业",
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      controller: majorsController,
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return '专业不能为空';
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
          actions: [
            if (student != null)
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the edit dialog
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('确认删除'),
                        content: Text('确定要删除该学生吗？'),
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
                      await dio.delete('/student',
                          queryParameters: {"id": student.id});

                      setState(() {
                        _students.remove(student);
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
                  final newStudent0 = Student(
                    id: student?.id ?? 0,
                    name: nameController.text,
                    username: usernameController.text,
                    studentNo: studentNoController.text,
                    grade: int.tryParse(gradeController.text) ?? 0,
                    majors: majorsController.text,
                  );

                  try {
                    final dio = await AppNetwork.getDio();
                    final response = student == null
                        ? await dio.post('/student', data: newStudent0.toJson())
                        : await dio.put('/student', data: newStudent0.toJson());
                    final newStudent = student == null
                        ? Student.fromJson(response.data['data'])
                        : newStudent0;

                    setState(() {
                      student == null
                          ? _students.add(newStudent)
                          : _students[index!] = newStudent;
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
          title: Text('批量删除学生信息'),
          content: Text('确定要删除选中的学生吗？'),
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
                  for (final student in _selectedStudents) {
                    await dio.delete('/student',
                        queryParameters: {"id": student.id});
                  }

                  setState(() {
                    _students.removeWhere(
                        (student) => _selectedStudents.contains(student));
                    _selectedStudents.clear();
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
