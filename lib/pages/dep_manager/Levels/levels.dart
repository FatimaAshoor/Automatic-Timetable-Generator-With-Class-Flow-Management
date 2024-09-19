import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/widgets/two_actions.dart';
import 'dart:convert';
import 'package:timetable_admin/Business Logic/components/info.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_main.dart';

import '../../../constant/t_colors.dart';
import '../../../main.dart';

class Levels extends StatefulWidget {
  const Levels({super.key});

  @override
  State<Levels> createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController levelNameValue = TextEditingController();
  //المفروض تجي من البيانات المستخدمة في تسجيل الدخول
  String? DepValue = sharedPref.getString("dm_id");
  bool? levelSpecializationValue =false;
  TextEditingController levelNoOfStudentsValue = TextEditingController();
  TextEditingController levelNoOfGroupsValue = TextEditingController();
  TextEditingController numOfProg=TextEditingController();
  TextEditingController numOfNetwork=TextEditingController();
  int? id;

  Info _info =Info();
  String? newSubType = "0";
  String? updatedSubType;

   Future getData() async {
    var response = await _info.getRequest("${serverLink}/dep_levels/${DepValue}");

    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
   }


  Future postNestedData() async {
     var level={
       "Name":levelNameValue.text,
       "DepartmentId":DepValue,
       "number_of_groups":levelNoOfGroupsValue.text,
       "number_of_students":levelNoOfStudentsValue.text,
       "Specialization":"$levelSpecializationValue"
     };
     var Spec={
       "programming":numOfProg.text==null?'0':numOfProg.text,
       "network":numOfNetwork.text==null?'0':numOfNetwork.text
     };
    var response = await _info.postRequest("${serverLink}/level",
        {
      "level":jsonEncode(level),
      "Spec":jsonEncode(Spec)

    });
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DepManagerMainPage(pageIndex:3)));
    }
    else{
      Text("${response.statusCode}");
    }
  }
  Future putNestedData() async {
    var level={
      "Name":levelNameValue.text,
      "DepartmentId":DepValue,
      "number_of_groups":levelNoOfGroupsValue.text,
      "number_of_students":levelNoOfStudentsValue.text,
      "Specialization":"$levelSpecializationValue"
    };
    var Spec={
      "programming":numOfProg.text==null?'0':numOfProg.text,
      "network":numOfNetwork.text==null?'0':numOfNetwork.text

    };

    var response = await _info.putRequest("${serverLink}/level/${id.toString()}", {
      "level":jsonEncode(level)
      ,
      "Spec":jsonEncode(Spec)

    });
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DepManagerMainPage(pageIndex:3)));
    }
    else{
      Text("Error");
    }
  }

  Future deleteData() async {
    var response = await _info.deleteRequest("${serverLink}/level/${id.toString()}");
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DepManagerMainPage(pageIndex:3)));
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
                              Text("Level Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Department", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("No. Of Groups", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),

                              Text("No. Of Students", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Network Students", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Prog Students", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                            children: List.generate(7, (index) =>
                                            index == 6 ? TableCell(
                                                child: TwoActions(
                                                  onClickDelete: () async{
                                                    id=snap.data![i]['level']['id'];
                                                    await deleteData();

                                                  },


                                                  onClickUpdate: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          levelNameValue = TextEditingController(text: "${snap.data![i]['level']['Name']}");
                                                          levelSpecializationValue =snap.data![i]['level']['Specialization'];
                                                          levelNoOfStudentsValue = TextEditingController(text:"${snap.data![i]['level']['number_of_students']}");
                                                          levelNoOfGroupsValue = TextEditingController(text: "${snap.data![i]['level']['number_of_groups']}");
                                                          numOfNetwork=TextEditingController(text:"${snap.data![i]['net']!=0?snap.data![i]['net']['number_of_students']:""}");
                                                          numOfProg=TextEditingController(text: "${snap.data![i]['prog']!=0?snap.data![i]['prog']['number_of_students']:""}");
                                                          id=snap.data![i]['level']['id'];
                                                          return Builder(
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Padding(
                                                                    padding:
                                                                    const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text("Edit the level",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: TColors.black),
                                                                        ),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            icon: Icon(Symbols.close_rounded,
                                                                              color: TColors.black,
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  content: Container(
                                                                    width: 909,
                                                                    height: 824,
                                                                    margin: EdgeInsets.only(left: 50, right: 50),
                                                                    child: SingleChildScrollView(
                                                                      child: Form(
                                                                        child: Column(
                                                                          children: [
                                                                            TextFormField(
                                                                              controller: levelNameValue,
                                                                              decoration: InputDecoration(
                                                                                  hintText: "Level name",
                                                                                  border: OutlineInputBorder()),
                                                                            ),
                                                                            SizedBox(height: 16,),

                                                                            TextFormField(
                                                                              controller: levelNoOfStudentsValue,
                                                                              decoration: InputDecoration(
                                                                                  hintText: "No. of Students",
                                                                                  border: OutlineInputBorder()),
                                                                            ),
                                                                            SizedBox(height: 16,),
                                                                            TextFormField(
                                                                              controller: levelNoOfGroupsValue,
                                                                              decoration: InputDecoration(
                                                                                  hintText: "No. of Groups",
                                                                                  border: OutlineInputBorder()),
                                                                            ),
                                                                            SizedBox(height: 16,),
                                                                            Row(
                                                                              children: [
                                                                                Text("have Specializations:"),
                                                                                Checkbox(value: levelSpecializationValue, onChanged: (val){
                                                                                  print(val);
                                                                                  (context as Element).markNeedsBuild();
                                                                                  levelSpecializationValue=val;
                                                                                }
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 16,),

                                                                            TextFormField(
                                                                              enabled:levelSpecializationValue ,
                                                                              controller: numOfNetwork,
                                                                              decoration: InputDecoration(
                                                                                  hintText: "No. of network students",
                                                                                  border: OutlineInputBorder()),
                                                                            ),
                                                                            SizedBox(height: 16,),

                                                                            TextFormField(
                                                                              enabled: levelSpecializationValue,
                                                                              controller: numOfProg,
                                                                              decoration: InputDecoration(
                                                                                  hintText: "No. of programming students",
                                                                                  border: OutlineInputBorder()),
                                                                            ),



                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    OutlinedButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Text(
                                                                        "Cancel", style: TextStyle( color: TColors.darkBlue),
                                                                      ),
                                                                      style: OutlinedButton.styleFrom(
                                                                          side: BorderSide(color: TColors.darkBlue, width: 1)),
                                                                    ),

                                                                    // Save Button
                                                                    ElevatedButton(
                                                                      onPressed: () async{
                                                                        await putNestedData();

                                                                      },
                                                                      child: Text("Edit"),
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: TColors.darkBlue, textStyle: TextStyle(color: TColors.lightGray)),
                                                                    ),
                                                                  ],
                                                                  actionsPadding:
                                                                  EdgeInsets.only(
                                                                      right: 32,
                                                                      bottom: 32),
                                                                );
                                                              }
                                                          );
                                                        });
                                                  },
                                                ))
                                                : TableCell(
                                                child: (index == 0) ?
                                                Padding(padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['level']['Name']}" + "  "),
                                                )
                                                    : (index == 1) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['level']['DepartmentId']['Name']}" + "  "),
                                                )
                                                    : (index == 2) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['level']['number_of_groups']}" + "  "),
                                                )
                                                    : (index == 3) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['level']['number_of_students']}" + "  "),
                                                )
                                                    : (index == 4) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['net']!=0?snap.data![i]['net']['number_of_students']: '---'}" + "  "),
                                                ): (index == 5) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['prog']!=0?snap.data![i]['prog']['number_of_students']: '---'}" + "  "),
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
                    // Table Content


                    // Add Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0, right: 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Padding(
                                          padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Add new level",
                                                style: TextStyle( fontWeight: FontWeight.bold, color: TColors.black),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(Symbols.close_rounded, color: TColors.black,
                                                  ))
                                            ],
                                          ),
                                        ),
                                        content: Container(
                                          width: 909,
                                          height: 824,
                                          margin: EdgeInsets.only(left: 50, right: 50),
                                          child: Form(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller: levelNameValue,
                                                    decoration: InputDecoration(
                                                        hintText: "Level name",
                                                        border: OutlineInputBorder()),
                                                  ),
                                                  SizedBox(height: 16,),

                                                  SizedBox(height: 16,),
                                                  TextFormField(
                                                    controller: levelNoOfStudentsValue,
                                                    decoration: InputDecoration(
                                                        hintText: "No. of Students",
                                                        border: OutlineInputBorder()),
                                                  ),
                                                  SizedBox(height: 16,),
                                                  TextFormField(
                                                    controller: levelNoOfGroupsValue,
                                                    decoration: InputDecoration(
                                                        hintText: "No. of Groups",
                                                        border: OutlineInputBorder()),
                                                  ),
                                                  SizedBox(height: 16,),
                                                  Row(
                                                    children: [
                                                      Text(" Have Specializations:"),
                                                      Checkbox(value: levelSpecializationValue, onChanged: (val){
                                                        (context as Element).markNeedsBuild();
                                                        levelSpecializationValue=val;

                                                      }
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16,),
                                                  TextFormField(
                                                    enabled:levelSpecializationValue ,
                                                    controller: numOfNetwork,
                                                    decoration: InputDecoration(
                                                        hintText: "No. of network students",
                                                        border: OutlineInputBorder()),
                                                  ),
                                                  SizedBox(height: 16,),

                                                  TextFormField(
                                                    enabled: levelSpecializationValue,
                                                    controller: numOfProg,
                                                    decoration: InputDecoration(
                                                        hintText: "No. of programming students",
                                                        border: OutlineInputBorder()),
                                                  ),
                                                  SizedBox(height: 16,),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel", style: TextStyle(color: TColors.darkBlue),),
                                            style: OutlinedButton.styleFrom(side: BorderSide(color: TColors.darkBlue, width: 1)),
                                          ),

                                          // Save Button
                                          ElevatedButton(
                                            onPressed: () async{
                                              await postNestedData();
                                            },
                                            child: Text("Save", style: TextStyle(color: TColors.white),),
                                            style: ElevatedButton.styleFrom(backgroundColor: TColors.darkBlue),
                                          ),
                                        ],
                                        actionsPadding:
                                        EdgeInsets.only(right: 32, bottom: 32),
                                      );
                                    }
                                  );
                                });
                          },
                          color: TColors.darkBlue,
                          textColor: Colors.white,
                          child: Icon(Symbols.add_rounded, size: 24,),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder(),
                        ),
                      ),
                    )

                  ],
                ),
              );
  }
}
