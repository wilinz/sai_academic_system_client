import 'package:flutter/material.dart';
import 'package:flutter_template/ui/page/admin/info/info.dart';
import 'package:flutter_template/ui/page/admin/student/student.dart';

import 'course/course.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selected = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          StudentPage(),
          CoursePage(),
          CourseInfoPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selected = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            tooltip: '学生信息管理',
            icon: Icon(Icons.person_outline),
            label: '学生',
            selectedIcon: Icon(Icons.person),
          ),
          NavigationDestination(
            tooltip: '课程信息管理',
            icon: Icon(Icons.book_outlined),
            label: '课程',
            selectedIcon: Icon(Icons.book),
          ),
          NavigationDestination(
            tooltip: '学生选课信息查询',
            icon: Icon(Icons.search_outlined),
            label: '选课',
            selectedIcon: Icon(Icons.search),
          ),
        ],
        onDestinationSelected: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        },
        selectedIndex: _selected,
      ),
    );
  }
}

class StudentInfoManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('学生信息管理'),
      ),
      body: Center(
        child: Text('学生信息管理页面'),
      ),
    );
  }
}

class CourseInfoManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('课程信息管理'),
      ),
      body: Center(
        child: Text('课程信息管理页面'),
      ),
    );
  }
}

class StudentCourseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('学生选课信息查询'),
      ),
      body: Center(
        child: Text('学生选课信息查询页面'),
      ),
    );
  }
}
