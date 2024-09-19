import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/widgets/two_actions.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_main.dart';

import '../../../constant/t_colors.dart';
import '../../../main.dart';

class SelectedSubjects extends StatefulWidget {
  const SelectedSubjects({super.key});

  @override
  State<SelectedSubjects> createState() => _SelectedSubjectsState();
}

class _SelectedSubjectsState extends State<SelectedSubjects> {
  GlobalKey<FormState> formState = GlobalKey();

  var subjectValue ;
  var teacherValue ;

  String? subName;
  String? subHours;
  String? subTeacher;

  String? newSubType = "0";
  String? updatedSubType;
  Info _info=Info();
  String? deptValue = sharedPref.getString("dm_id");


  Future getData() async {
    var response = await _info.getRequest("${serverLink}/dep_selected_subject/${deptValue}");

    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }
  Future postData() async {
    var response = await _info.postRequest("${serverLink}/teacher_subject",{
      "teacher":"$teacherValue",
      "Subject":"$subjectValue",


    });
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DepManagerMainPage(pageIndex:1)));
    }
    else{
      Text("${response.statusCode}");
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
                              Text("Subject Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Type", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),

                              Text("Teacher", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                        for(int j=0;j < snap.data![i]['Teachers']!.length; j++)
                                          TableRow(
                                              children: List.generate(4, (index) =>
                                              index == 3? TableCell(
                                                  child: TwoActions(
                                                    teacherRequest: true,




                                                  ))
                                                  : TableCell(
                                                  child: (index == 0) ?
                                                  Padding(padding: const EdgeInsets.all(10),
                                                    child: Text( "${snap.data![i]['SubjectId']['SubjectId']['Name']}" + "  "),
                                                  )
                                                      : (index == 1) ?
                                                  Padding( padding: const EdgeInsets.all(10),
                                                    child: Text( "${snap.data![i]['SubjectId']['IsLab']?'Lab':'theoretic'}" + "  "),
                                                  )
                                                      : (index == 2) ?
                                                  Padding( padding: const EdgeInsets.all(10),
                                                      child: Container(
                                                          height: 20,
                                                          child:
                                                          Text("${snap.data![i]['Teachers'][j]['Name']}")


                                                      ))
                                                      : Text("")))),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                          return Text("");
                        }),
                    // Table Content


                    // Add Button
                  ],
                ),
              );
  }
}
