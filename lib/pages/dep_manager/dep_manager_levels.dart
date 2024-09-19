import 'package:flutter/material.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/pages/dep_manager/Levels/groups.dart';
import 'package:timetable_admin/pages/dep_manager/Levels/levels.dart';

class LevelsPage extends StatefulWidget {
  final tab;
  const LevelsPage({super.key,this.tab=0});

  @override
  State<LevelsPage> createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this,initialIndex: widget.tab);
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
                      Tab(text: "Levels",),
                      Tab(text: "Groups",),
                     // Tab(text: "Specializations",),
                    ]),
              ),
              Container(
                  width: double.maxFinite,
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Levels(),
                      Groups(),
                     // Specializations(),
                    ],
                  )
              ),
            ],
          ),
        ),],
    );
  }
}

