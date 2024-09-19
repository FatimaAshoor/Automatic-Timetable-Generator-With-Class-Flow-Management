import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import 'package:timetable_admin/main.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_main.dart';

class CreateTimetable extends StatefulWidget {

  final VoidCallback onCreate;
  CreateTimetable({super.key, required this.onCreate});

  @override
  State<CreateTimetable> createState() => _CreateTimetableState();
}

class _CreateTimetableState extends State<CreateTimetable> {

  GlobalKey<FormState> formState = GlobalKey();

  String? lectureSubjectValue;
  String? lectureTeacherValue;
  String? lectureLevelValue;
  String? lectureSpecializationValue;
  String? lectureGroupValue;
  bool? SubjectType;
  Info _info=Info();
  int? id;
  int? sem_subject_id;
  bool selectedSubject=false;
  bool selectedTeacher=false;
  bool selectedLevel=false;
  bool selectedSpec=false;
  bool existSpec = false;
  bool lectureCreated=true;
  String? deptValue = sharedPref.getString("dm_id");

  Future createTimeTable() async {
    var response = await _info.postRequest("${serverLink}/create_timetable/1",{});
    if (response==true){
      sharedPref.setBool('created_timetable', true);
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>DepManagerMainPage()));
    return response;
    }
    else{
      return false;
    }
  }
  Future createLectures() async {
    var response = await _info.postRequest("${serverLink}/create_lectures/${deptValue}",{});
    if (response==true){
      lectureCreated=true;
      (context as Element).markNeedsBuild();
    }
    else{
      Text("${response.statusCode}");
    }
  }
  Future getLectures() async {
    var response = await _info.getRequest("${serverLink}/dep_lectures/${deptValue}");

    if (response!='failed') {
      List resBody = response;
      return resBody;
    }
  }
  Future getSubject() async {
    var response = await _info.getRequest("${serverLink}/dep_sem_subject/${deptValue}");

    if (response!='failed') {
      List resBody = response;

      return resBody;
    }
  }
  Future getTeacher() async {
    var response = await _info.getRequest("${serverLink}/dep_teacher_of_subject/${lectureSubjectValue}");

    if (response!='failed') {
      List resBody = response;

      return resBody;
    }
  }
  Future getLevel() async {
    var response = await _info.getRequest("${serverLink}/dep_levels/${deptValue}");

    if (response!='failed') {
      List resBody = response;

      return resBody;
    }
  }
  Future getSpec() async {
    var response = await _info.getRequest("${serverLink}/specialization/${lectureLevelValue}");

    if (response!='failed') {
      List resBody = response;

      return resBody;
    }
    return null;
  }
  Future getGroup() async {

    if (lectureSpecializationValue==null) {
      var response = await _info.getRequest("${serverLink}/level_groups/${lectureLevelValue}");
      if (response!='failed') {
        List resBody = response;
        return resBody;
      }
    }
    else{
      var response = await _info.getRequest("${serverLink}/spec_groups/${lectureSpecializationValue}");
      if (response!='failed') {
        List resBody = response;
        return resBody;
      }
    }

  }
  Future AddData() async {
    var response = await _info.postRequest("${serverLink}/lecture",
        {
          "DepartmentId":deptValue,
          "LevelId":"$lectureLevelValue",
          "GroupId":lectureGroupValue!=null?"$lectureGroupValue":'0',
          "SpecId":lectureSpecializationValue!=null?"$lectureSpecializationValue":'0',
          "SubjectId":"$lectureSubjectValue",
          "TeacherId":"$lectureTeacherValue",
        });
    if (response==true){
      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();
    }
    else{
      Text("${response.statusCode}");
    }
  }
  Future putData() async {
    var response = await _info.putRequest("http://127.0.0.1:8000/API/lecture/${id.toString()}",
        {
          "DepartmentId":deptValue,
          "LevelId":"$lectureLevelValue",
          "GroupId":lectureGroupValue!=null?"$lectureGroupValue":'0',
          "SpecId":lectureSpecializationValue!=null?"$lectureSpecializationValue":'0',
          "SubjectId":"$lectureSubjectValue",
          "TeacherId":"$lectureTeacherValue",
        });
    if (response==true){
      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();
    }
    else{
      Text("Error");
    }
  }
  Future deleteData() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/lecture/${id.toString()}");
    if (response==true){

      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();

    }
    else{
      Text("Error");
    }
  }

  String? selectedSub = "1";
  String? updatedSubType;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              //color: TColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Lectures", style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                        MaterialButton(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Create Timetable",
                              style: TextStyle(color: TColors.white),),
                          ),
                          color: TColors.darkBlue,
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Padding(
                                      padding: const EdgeInsets.only( left: 40, right: 40),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: TColors.black),),
                                        ],
                                      ),
                                    ),
                                    content: Container(
                                      width: 200,
                                      height: 100,
                                      margin: EdgeInsets.only(left: 50, right: 50),
                                      child: Center(
                                        child: FutureBuilder(
                                          future: createTimeTable(),
                                          builder: (context, snap){
                                            if (snap.connectionState == ConnectionState.waiting) {
                                              return Center(child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("The Timetable is being created, \n you will receive a notification if is complete",
                                                    style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)
                                                ],
                                              ));
                                            }
                                            return Center(child: Text(""));
                                          },
                                        ),
                                      )
                                    ),
                                    actions: [
                                          Center(
                                            child: Container(
                                              width: 120,
                                              height: 38,
                                              child: ElevatedButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("OK", style: TextStyle(color: TColors.white)),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: TColors.darkBlue,

                                              ),
                                            ),
                                            ))],
                                  );
                                }
                            );


                          },
                        ),

                      ],
                    ),

                    lectureCreated == false? MaterialButton(
                      onPressed:() {
                        createLectures();
                        lectureCreated=true;
                      },
                      color: TColors.darkBlue,

                      child: Padding(
                        padding:EdgeInsets.all(20),
                        child: Text('Create lectures',style: TextStyle(color: TColors.white),),
                      ),) : Text(''),
                    SingleChildScrollView(
                      child: Container(
                        height: 400,
                        child: FutureBuilder(
                          future: getLectures(),
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snap.connectionState == ConnectionState.done) {
                              if (snap.hasError) {
                                return Center(child: Text("${snap.error}"));
                              }
                              if (snap.hasData && snap.data!=[]) {
                                return GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, childAspectRatio: 4,  crossAxisSpacing: 6, mainAxisSpacing: 6),
                                    itemCount: snap.data.length,
                                    itemBuilder: (context, i) {
                                      return lectureCard(
                                        // ------------------------------------ Lecture Data ------------------------------------
                                          snap.data[i]['SubjectId']['SubjectId']['Name'],
                                          snap.data[i]['TeacherId']['Name'],
                                          snap.data[i]['LevelId']!=null?snap.data[i]['LevelId']['Name']:'',
                                          snap.data[i]['SpecId']!=null?snap.data[i]['SpecId']['Name']:'',
                                          snap.data[i]['SubjectId']['IsLab']==true?'Lab':'Theory',
                                          snap.data[i]['GroupId']!=null?snap.data[i]['GroupId']['Name']:'',

                                          // ------------------------------------ onClickEdit ------------------------------------
                                              () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  lectureSubjectValue=snap.data[i]['SubjectId']['id'].toString();
                                                  lectureTeacherValue=snap.data[i]['TeacherId']['id'].toString();
                                                  lectureLevelValue=snap.data[i]['LevelId']!=null?snap.data[i]['LevelId']['id'].toString():null;
                                                  lectureSpecializationValue=snap.data[i]['SpecId']!=null?snap.data[i]['SpecId']['id'].toString():null;
                                                  lectureGroupValue=snap.data[i]['GroupId']!=null?snap.data[i]['GroupId']['id'].toString():null;
                                                  selectedSubject=true;
                                                  selectedTeacher=true;
                                                  id=snap.data[i]['id'];
                                                  selectedLevel=snap.data[i]['LevelId']!=null?true:false;
                                                  selectedSpec=snap.data[i]['SpecId']!=null?true:false;
                                                  return StatefulBuilder(
                                                    builder: (context,setState) {
                                                      return AlertDialog(
                                                        title: Padding(
                                                          padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Edit Lecture", style: TextStyle( fontWeight: FontWeight.bold, color: TColors.black),),
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
                                                          width: 885,
                                                          height: 800,
                                                          margin: EdgeInsets.only(left: 50, right: 50),
                                                          child: SingleChildScrollView(
                                                            child: Form(
                                                              child: Column(
                                                                children: [
                                                                  FutureBuilder<dynamic>(
                                                                      future:getSubject(),
                                                                      builder: (context,snp) {
                                                                        if (snp.hasData) {
                                                                          return DropdownButtonFormField<String>(
                                                                            value: lectureSubjectValue,
                                                                            hint:Text('select the subject'),
                                                                            onChanged: (newValue) {
                                                                              setState(() {
                                                                                lectureSubjectValue = newValue!;

                                                                                selectedSubject=true;
                                                                              });
                                                                              (context as Element).markNeedsBuild();
                                                                            },
                                                                            items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: value['subject']['id'].toString(),
                                                                                child: Text('${value['subject']['SubjectId']['Name']}'+' (${value['subject']['IsLab']==true?'lab':'theory'})'),
                                                                              );
                                                                            }).toList(),
                                                                          );
                                                                        }
                                                                        else{
                                                                          return Text("");
                                                                        }
                                                                      }
                                                                  ),
                                                                  SizedBox(height: 16,),
                                                                  selectedSubject==true?
                                                                  FutureBuilder<dynamic>(
                                                                      future:getTeacher(),
                                                                      builder: (context,snp) {
                                                                        if (snp.hasData) {
                                                                          return DropdownButtonFormField<String>(
                                                                            value: lectureTeacherValue,
                                                                            hint:Text('select the teacher'),
                                                                            onChanged: (newValue) {

                                                                              setState(() {
                                                                                lectureTeacherValue = newValue!;
                                                                                selectedTeacher=true;
                                                                              });

                                                                              (context as Element).markNeedsBuild();
                                                                            },
                                                                            items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: value['id'].toString(),
                                                                                child: Text('${value['Name']}'),
                                                                              );
                                                                            }).toList(),
                                                                          );
                                                                        }
                                                                        else{
                                                                          return Text("");
                                                                        }
                                                                      }
                                                                  ):
                                                                  Text(''),
                                                                  SizedBox(height: 16,),
                                                                  selectedTeacher==true?
                                                                  FutureBuilder<dynamic>(
                                                                      future:getLevel(),
                                                                      builder: (context,snp) {
                                                                        if (snp.hasData) {
                                                                          return DropdownButtonFormField<String>(
                                                                            value: lectureLevelValue,
                                                                            hint:Text('select the level'),
                                                                            onChanged: (newValue) {
                                                                              setState(() {
                                                                                lectureLevelValue = newValue!;
                                                                                selectedLevel=true;
                                                                              });
                                                                              (context as Element).markNeedsBuild();
                                                                            },
                                                                            items: snp.data.map<DropdownMenuItem<String>>((value) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: value['level']['id'].toString(),
                                                                                child: Text('${value['level']['Name']}'),
                                                                              );
                                                                            }).toList(),
                                                                          );
                                                                        }
                                                                        else{
                                                                          return Text("");
                                                                        }

                                                                      }
                                                                  ):
                                                                  Text(""),
                                                                  SizedBox(height: 16,),
                                                                  selectedLevel==true?
                                                                  FutureBuilder<dynamic>(
                                                                      future:getSpec(),
                                                                      builder: (context,snp) {
                                                                        if (snp.hasData) {

                                                                          if (snp.data.length>=1){
                                                                            existSpec=true;
                                                                            return DropdownButtonFormField<String>(
                                                                              value: lectureSpecializationValue,
                                                                              hint:Text('select the specialization'),
                                                                              onChanged: (newValue) {
                                                                                setState(() {
                                                                                  lectureSpecializationValue = newValue!;
                                                                                  selectedSpec=true;
                                                                                });
                                                                                (context as Element).markNeedsBuild();
                                                                              },
                                                                              items: snp.data.map<DropdownMenuItem<String>>((value) {
                                                                                return DropdownMenuItem<String>(
                                                                                  value: value['id'].toString(),
                                                                                  child: Text('${value['Name']}'),
                                                                                );
                                                                              }).toList(),
                                                                            );}
                                                                          else{
                                                                            return FutureBuilder<dynamic>(
                                                                                future:getGroup(),
                                                                                builder: (context,snp) {
                                                                                  if (snp.hasData) {
                                                                                    return DropdownButtonFormField<String>(
                                                                                      value: lectureGroupValue,
                                                                                      hint:Text('select the group'),
                                                                                      onChanged: (newValue) {
                                                                                        setState(() {
                                                                                          lectureGroupValue = newValue!;
                                                                                        });
                                                                                        (context as Element).markNeedsBuild();
                                                                                      },
                                                                                      items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                                                        return DropdownMenuItem<String>(
                                                                                          value: value['id'].toString(),
                                                                                          child: Text('${value['Name']}'),
                                                                                        );
                                                                                      }).toList(),
                                                                                    );
                                                                                  }
                                                                                  else{
                                                                                    return Text("");
                                                                                  }

                                                                                }
                                                                            );
                                                                          }
                                                                        }
                                                                        else{
                                                                          return Text("");

                                                                        }

                                                                      }
                                                                  )
                                                                      :Text(''),
                                                                  SizedBox(height: 16,),
                                                                  selectedSpec==true?
                                                                  FutureBuilder<dynamic>(
                                                                      future:getGroup(),
                                                                      builder: (context,snp) {
                                                                        if (snp.hasData) {
                                                                          return DropdownButtonFormField<String>(
                                                                            value: lectureGroupValue,
                                                                            hint:Text('select the group'),
                                                                            onChanged: (newValue) {
                                                                              setState(() {
                                                                                lectureGroupValue = newValue!;
                                                                              });
                                                                              (context as Element).markNeedsBuild();
                                                                            },
                                                                            items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: value['id'].toString(),
                                                                                child: Text('${value['Name']}'),
                                                                              );
                                                                            }).toList(),
                                                                          );
                                                                        }
                                                                        else{
                                                                          return Text("");
                                                                        }
                                                                      }
                                                                  )
                                                                      :Text(''),
                                                                  SizedBox(height: 16,),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        actions: [
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              putData();
                                                            },
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(color: TColors.darkBlue,),
                                                            ),
                                                            style: OutlinedButton.styleFrom(
                                                                side: BorderSide(
                                                                    color: TColors.darkBlue, width: 1)),
                                                          ),

                                                          // Edite Button
                                                          ElevatedButton(
                                                            onPressed: () {
                                                               putData();
                                                            },
                                                            child: Text("Edit", style: TextStyle(color: TColors.lightGray),),
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: TColors.darkBlue,
                                                                textStyle: TextStyle(color: TColors.lightGray)),
                                                          ),
                                                        ],
                                                        actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                                                      );
                                                    }
                                                  );
                                                });
                                          },

                                          // ------------------------------------ onClickDelete ------------------------------------
                                              () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Container(
                                                    width:400,
                                                    height: 180,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                                                      child: Column(
                                                        children: [
                                                          CircleAvatar(child: Icon(Symbols.warning_rounded, color: TColors.red,), backgroundColor: Color.fromRGBO(255, 31, 31, 0.1),),
                                                          SizedBox(height: 22,),
                                                          Text("Are you sure?",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                                                          SizedBox(height: 11,),
                                                          Text("The Lecture will be deleted.", style: TextStyle( color: TColors.darkGray), ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 120,
                                                          height: 38,
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text("No", style: TextStyle(color: TColors.red),),
                                                            style: OutlinedButton.styleFrom(
                                                                side: BorderSide(
                                                                    color: TColors.red, width: 1)),
                                                          ),
                                                        ),
                                                        SizedBox(width: 32,),
                                                        Container(
                                                          width: 120,
                                                          height: 38,
                                                          child: ElevatedButton(
                                                            onPressed: ()async{
                                                              id=snap.data[i]['id'];
                                                              deleteData();
                                                            },
                                                            child: Text("Yes", style: TextStyle(color: TColors.white),),
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: TColors.red,
                                                                textStyle: TextStyle(color: TColors.white)
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                  actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
                                                );
                                              },
                                            );
                                          }

                                      );
                                    });
                              }
                            }
                            return Text("");
                          },
                        ),
                      ),
                    ),
                  ],
                )

            ),
          ),
          addLectureButton(),
        ]);
  }

  Widget lectureCard(String lectureSubjectName, String lectureTeacherName,
      String lectureLevel, String lectureSpecialization,String subjectType,
      String lectureGroupNumber, void Function()? onClickEdit, void Function()? onClickDelete ) {
    return Container(
      padding: EdgeInsets.only(  left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: TColors.darkBlue,),
      child: Column(
          children:[

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton( icon: Icon( Symbols.more_horiz_rounded, color: TColors.white,),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "0",
                        child: Text("Edit"),
                        onTap: onClickEdit,
                      ),
                      PopupMenuItem(
                        value: "1",
                        child: Text("Delete", style: TextStyle(color: TColors.red),),
                        onTap: onClickDelete,
                      )
                    ]),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${lectureSubjectName}", maxLines: 2, overflow: TextOverflow.visible, style: TextStyle(fontSize: 15, color: TColors.white)),
                    SizedBox(height: 6,),
                    Text("${lectureTeacherName}", style: TextStyle(fontSize: 14, color: TColors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: TColors.white),
                            child: Text("${lectureLevel}", style: TextStyle(fontSize: 14, color: TColors.black))
                        ),
                        SizedBox(height: 6,),
                        Text("${lectureSpecialization}", style: TextStyle(fontSize: 14, color: TColors.white)),
                      ],
                    ),
                    SizedBox(width: 4,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: TColors.white),
                            child: Text("${subjectType}", style: TextStyle(fontSize: 14, color: TColors.black))
                        ),
                        SizedBox(height: 6,),
                        Text("${lectureGroupNumber}", style: TextStyle(fontSize: 14, color: TColors.white)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ]
      ),
    );
  }


  Widget addLectureButton(){

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 15),
      child: Align(
        alignment: Alignment.bottomRight,
        child: MaterialButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  lectureSubjectValue=null;
                  lectureTeacherValue=null;
                  lectureLevelValue=null;
                  lectureSpecializationValue=null;
                  lectureGroupValue=null;
                  selectedSubject=false;
                  selectedTeacher=false;
                  selectedLevel=false;
                  selectedSpec=false;

                  return StatefulBuilder(
                    builder: (context,setState) {
                      return AlertDialog(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Add new Lecture", style: TextStyle( fontWeight: FontWeight.bold, color: TColors.black),),
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
                          width: 885,
                          height: 800,
                          margin: EdgeInsets.only(left: 50, right: 50),
                          child: SingleChildScrollView(
                            child: Form(
                              child: Column(
                                children: [
                                  FutureBuilder<dynamic>(
                                      future:getSubject(),
                                      builder: (context,snp) {
                                        if (snp.hasData) {
                                          return DropdownButtonFormField<String>(
                                            value: lectureSubjectValue,
                                            hint:Text('select the subject'),
                                            onChanged: (newValue) {
                                              setState(() {
                                                lectureSubjectValue = newValue!;

                                                selectedSubject=true;
                                              });
                                              (context as Element).markNeedsBuild();
                                            },
                                            items: snp.data!.map<DropdownMenuItem<String>>((value) {

                                              return DropdownMenuItem<String>(
                                                value: value['subject']['id'].toString(),
                                                child: Text('${value['subject']['SubjectId']['Name']}'+' (${value['subject']['IsLab']==true?'lab':'theory'})'),
                                              );
                                            }).toList(),
                                          );
                                        }
                                        else{
                                          return Text("");
                                        }
                                      }
                                  ),
                                  SizedBox(height: 16,),
                                  selectedSubject==true?
                                  FutureBuilder<dynamic>(
                                      future:getTeacher(),
                                      builder: (context,snp) {
                                        if (snp.hasData) {
                                          return DropdownButtonFormField<String>(
                                            value: lectureTeacherValue,
                                            hint:Text('select the teacher'),
                                            onChanged: (newValue) {

                                              setState(() {
                                                lectureTeacherValue = newValue!;
                                                selectedTeacher=true;
                                              });

                                              (context as Element).markNeedsBuild();
                                            },
                                            items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['id'].toString(),
                                                child: Text('${value['Name']}'),
                                              );
                                            }).toList(),
                                          );
                                        }
                                        else{
                                          return Text("");
                                        }
                                      }
                                  ):
                                  Text(''),
                                  SizedBox(height: 16,),
                                  selectedTeacher==true?
                                  FutureBuilder<dynamic>(
                                      future:getLevel(),
                                      builder: (context,snp) {
                                        if (snp.hasData) {
                                          return DropdownButtonFormField<String>(
                                            value: lectureLevelValue,
                                            hint:Text('select the level'),
                                            onChanged: (newValue) {
                                              setState(() {
                                                lectureLevelValue = newValue!;
                                                selectedLevel=true;
                                              });
                                              (context as Element).markNeedsBuild();
                                            },
                                            items: snp.data.map<DropdownMenuItem<String>>((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['level']['id'].toString(),
                                                child: Text('${value['level']['Name']}'),
                                              );
                                            }).toList(),
                                          );
                                        }
                                        else{
                                          return Text("");
                                        }

                                      }
                                  ):
                                  Text(""),
                                  SizedBox(height: 16,),
                                  selectedLevel==true?
                                  FutureBuilder<dynamic>(
                                      future:getSpec(),
                                      builder: (context,snp) {
                                        if (snp.hasData) {

                                          if (snp.data.length>=1){
                                            existSpec=true;
                                            return DropdownButtonFormField<String>(
                                              value: lectureSpecializationValue,
                                              hint:Text('select the specialization'),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  lectureSpecializationValue = newValue!;
                                                  selectedSpec=true;
                                                });
                                                (context as Element).markNeedsBuild();
                                              },
                                              items: snp.data.map<DropdownMenuItem<String>>((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value['id'].toString(),
                                                  child: Text('${value['Name']}'),
                                                );
                                              }).toList(),
                                            );}
                                          else{
                                            return FutureBuilder<dynamic>(
                                                future:getGroup(),
                                                builder: (context,snp) {
                                                  if (snp.hasData) {
                                                    return DropdownButtonFormField<String>(
                                                      value: lectureGroupValue,
                                                      hint:Text('select the group'),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          lectureGroupValue = newValue!;
                                                        });
                                                        (context as Element).markNeedsBuild();
                                                      },
                                                      items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value['id'].toString(),
                                                          child: Text('${value['Name']}'),
                                                        );
                                                      }).toList(),
                                                    );
                                                  }
                                                  else{
                                                    return Text("");
                                                  }

                                                }
                                            );
                                          }
                                        }
                                        else{
                                          return Text("");

                                        }

                                      }
                                  )
                                      :Text(''),
                                  SizedBox(height: 16,),
                                  selectedSpec==true?
                                  FutureBuilder<dynamic>(
                                      future:getGroup(),
                                      builder: (context,snp) {
                                        if (snp.hasData) {
                                          return DropdownButtonFormField<String>(
                                            value: lectureGroupValue,
                                            hint:Text('select the group'),
                                            onChanged: (newValue) {
                                              setState(() {
                                                lectureGroupValue = newValue!;
                                              });
                                              (context as Element).markNeedsBuild();
                                            },
                                            items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['id'].toString(),
                                                child: Text('${value['Name']}'),
                                              );
                                            }).toList(),
                                          );
                                        }
                                        else{
                                          return Text("");
                                        }
                                      }
                                  )
                                      :Text(''),
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
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: TColors.darkBlue,),
                            ),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: TColors.darkBlue, width: 1)),
                          ),

                          // Save Button
                          ElevatedButton(
                            onPressed: () {
                           AddData();
                            },
                            child: Text("add", style: TextStyle(color: TColors.lightGray),),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.darkBlue,
                                textStyle: TextStyle(color: TColors.lightGray)),
                          ),
                        ],
                        actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                      );
                    }
                  );
                });
          },
          color: TColors.orange,
          textColor: TColors.black,
          child: Icon(
            Symbols.add_rounded,
            size: 24,
          ),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
