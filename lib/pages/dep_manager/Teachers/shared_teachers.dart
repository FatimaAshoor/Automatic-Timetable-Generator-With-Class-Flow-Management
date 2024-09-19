import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/widgets/delete_action.dart';
import 'package:timetable_admin/widgets/two_actions.dart';
import 'dart:convert';
import 'package:timetable_admin/Business Logic/components/info.dart';

import '../../../constant/t_colors.dart';
import '../../../main.dart';

class SharedTeachers extends StatefulWidget {
  const SharedTeachers({super.key});

  @override
  State<SharedTeachers> createState() => _SharedTeachersState();
}

class _SharedTeachersState extends State<SharedTeachers> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController NameValue = TextEditingController();
  String? AcademicLevelValue ;
  String DepartmentValue = '1';
  String? accountValue;
  TextEditingController ConstraintsValue = TextEditingController();
  TextEditingController emailValue = TextEditingController();
  TextEditingController passwordValue = TextEditingController();
  int? id;
  String? teacherName;
  String? teacherAcademicLevel;
  String? teacherDepartment;
  String? teacherConstraints;
  String? teacherEmail;
  String? teacherPassword;
  Info _info=Info();
  String? deptValue = sharedPref.getString("dm_id");


  String? newSubType = "0";
  String? updatedSubType;
  Future getData() async {
    var response = await _info.getRequest("${serverLink}/shared_teacher/${deptValue}");
    if (response!='failed'){
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }
  Future deleteData() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/shared_teacher_pk/${id.toString()}/${deptValue}");
    if (response==true){

      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();

    }
    else{
      Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Stack(
                  children: [

                    // Search Bar
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 200, right: 250),
                        height: 40,
                        width:double.maxFinite,
                        child: Form(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(color: TColors.darkGray),
                                ),
                                hintText: "Search",
                                prefixIcon: Icon(Symbols.search_rounded, color: TColors.darkGray,size: 20,)
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: TColors.darkBlue,
                        ),
                        height: 38,
                        width: 150,
                        child: Row(
                          children: [
                            PopupMenuButton(
                                icon: Icon(
                                  Symbols.swap_vert_rounded,
                                  color: TColors.white,
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: "0",
                                    child: Text("Name"),
                                    onTap: (){},
                                  ),
                                  PopupMenuItem(
                                    value: "1",
                                    child: Text("Type"),
                                    onTap: (){},
                                  )

                                ]),
                            Text("Sorted data by", style: TextStyle(fontWeight: FontWeight.bold,color: TColors.white),),
                          ],
                        ),
                      ),),


                    // Table Header
                    Container(
                      margin: EdgeInsets.only(top: 50,),
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: TColors.lightGray,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Text("Teacher Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Department", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Academic Level", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black,), textAlign: TextAlign.center,),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Table Content
                    FutureBuilder(
                        future: getData(),
                        builder: (context, snap){
                          if(snap.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          }
                          if(snap.connectionState == ConnectionState.done){
                            if (snap.hasError) {
                              return Center(child: Text("${snap.error}"));
                            }

                            if (snap.hasData && snap.data!=[]) {
                              return Container(
                                margin: EdgeInsets.only(top: 50,),
                                padding: EdgeInsets.only(top: 38),
                                child: SingleChildScrollView(
                                  child: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    children: [
                                      for (int i = 0; i < snap.data!.length; i++)
                                        TableRow(
                                            children: List.generate(4, (index) =>
                                            index == 3? TableCell(
                                                child: DeleteAction(
                                                  onClickDelete: ()async {
                                                    id=snap.data[i]['id'];
                                                    await deleteData();
                                                  },
                                                ))
                                                : TableCell(
                                                child: (index == 0) ?
                                                Padding(padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['Name']}" + "  "),
                                                )
                                                    : (index == 1) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['DepartmentId']['Name']}" + "  "),
                                                ): (index == 2) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['Academic_Degree']}" + "  "),
                                                )
                                                    : Text("")))),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                          return Text("");
                        }),

                    // Add Button

                  ],
                ),
              );

  }
}
