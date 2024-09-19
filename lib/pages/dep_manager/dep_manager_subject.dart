import 'package:flutter/material.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/pages/dep_manager/Subjects/selected_subjects.dart';
import 'package:timetable_admin/pages/dep_manager/Subjects/subjects.dart';
import 'package:timetable_admin/pages/dep_manager/Subjects/toTeachers_semester_subjects.dart';


class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage>
    with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Stack(
      children: [
        Container(
        margin: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 20),
        padding: EdgeInsets.only(top: 8, left: 30, right: 30, bottom: 30),
        decoration: BoxDecoration(
          color: TColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: TColors.darkBlue,
                  indicatorWeight: 4,
                  indicatorPadding: EdgeInsets.only(bottom: 8),
                  labelColor: TColors.darkBlue,
                  unselectedLabelColor: TColors.darkBlue,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: "Subjects",),
                    Tab(text: "Semester Subjects",),
                    Tab(text: "Selected Subjects",),
                  ]),
            ),
            Container(
              width: double.maxFinite,
              height: 390,
              child: TabBarView(
                controller: _tabController,
                children:
                [
                  Subject(),
                  ToTeachersSemesterSubjects(),
                  SelectedSubjects(),
                ],
              )
            ),
          ],
        ),
      ),],
    );
  }
}

