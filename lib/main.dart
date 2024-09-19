import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable_admin/pages/admin/admin_classrooms_page.dart';
import 'package:timetable_admin/pages/admin/admin_departments_page.dart';
import 'package:timetable_admin/pages/admin/admin_main.dart';
import 'package:timetable_admin/pages/admin/admin_profile.dart';
import 'package:timetable_admin/pages/admin/admin_students_page.dart';
import 'package:timetable_admin/pages/dep_manager/choose_dep.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_main.dart';
import 'package:timetable_admin/pages/login.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timetable',
      theme: ThemeData(
          fontFamily: "Inter",
      ),


      home: sharedPref.getString('role')==null? LoginPage():
      sharedPref.getString('role')=='Admin'? AdminMainPage():
      sharedPref.getString('role')=='DM'? DepManagerMainPage():
          LoginPage(),

      routes: {
        "loginPage": (context)=> LoginPage(),
        "adminMainPage": (context)=> AdminMainPage(),
        "adminDepartmentsPage": (context)=> DepartmentsPage(),
        "adminClassroomsPage": (context)=> ClassroomsPage(),
        "adminStudentsPage": (context)=> StudentsPage(),
        "adminProfilePage": (context)=> AdminProfile(),
        "chooseDepPage":(context)=> ChooseDep(),
        "depManagerMainPage":(context)=> DepManagerMainPage(),
      },
    );
  }
}
