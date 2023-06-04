import 'package:flutter/material.dart';

import 'course/course.dart';


class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selected = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          CoursePage(),
          SelectedListPage(),
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
            tooltip: '选课',
            icon: Icon(Icons.school),
            label: '选课',
            selectedIcon: Icon(Icons.school_sharp),
          ),
          NavigationDestination(
            tooltip: '已选课程',
            icon: Icon(Icons.list),
            label: '已选课程',
            selectedIcon: Icon(Icons.list_alt),
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

class CourseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选课'),
      ),
      body: Center(
        child: Text('选课页面'),
      ),
    );
  }
}

class SelectedListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('已选课程'),
      ),
      body: Center(
        child: Text('已选课程'),
      ),
    );
  }
}
