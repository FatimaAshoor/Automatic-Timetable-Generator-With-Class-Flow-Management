import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../constant/t_colors.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import '../../../main.dart';
import '../../../widgets/three_actions.dart';


class ToTeachersSemesterSubjects extends StatefulWidget {
  const ToTeachersSemesterSubjects({super.key});

  @override
  State<ToTeachersSemesterSubjects> createState() => _ToTeachersSemesterSubjectsState();
}

class _ToTeachersSemesterSubjectsState extends State<ToTeachersSemesterSubjects> {

  GlobalKey<FormState> formState = GlobalKey();

  var subjectValue ;
  var teacherValue ;
  int? id;

  Info _info=Info();

  String? subName;
  String? subHours;

  String? newSubType = "0";
  String? updatedSubType;
  String? deptValue = sharedPref.getString("dm_id");


  Future getData() async {
    var response = await _info.getRequest("${serverLink}/dep_sem_subject/${deptValue}");
    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }

  Future getTeacher() async {
    var response = await _info.getRequest("${serverLink}/teacher_with_shared/${deptValue}");
    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }

  Future AddTeacher() async {
    var response = await _info.postRequest("${serverLink}/teacher_subject",{
      "Subject":"$subjectValue",
      "teacher":"$teacherValue",
    });
    if (response==true){
      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();
    }
    else{
      Text("${response.statusCode}");
    }
  }

  Future deleteData() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/semester_subject/${id.toString()}");
    if (response==true){
      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();
    }
    else{
      Text("Error");
    }
  }

  Future deleteTeacher() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/teacher_subject/${subjectValue}/${teacherValue}");
    if (response==true){
      (context as Element).markNeedsBuild();
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
                              Text("Subject Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Type", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Teachers", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                            index == 3 ? TableCell(
                                                child: ThreeActions(
                                                  onClickDelete: () async{
                                                    id=snap.data[i]['subject']['id'];
                                                    await deleteData();
                                                  },


                                                  onClickUpdate: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {


                                                          return StatefulBuilder(
                                                              builder: (BuildContext context,setState) {
                                                                return AlertDialog(
                                                                  title: Padding(
                                                                    padding:
                                                                    const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text("edit semester subject",
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
                                                                    child: ListView.builder(
                                                                        itemCount:snap.data![i]['teachers'].length,
                                                                        itemBuilder: ( context,I){
                                                                          return StatefulBuilder(
                                                                              builder: (context,setState) {
                                                                                return ListTile(
                                                                                  title: Text("${snap.data![i]['teachers'][I]['Name']}"),
                                                                                  trailing: IconButton(
                                                                                      onPressed:
                                                                                          () {
                                                                                        teacherValue=snap.data![i]['teachers'][I]['id'];
                                                                                        subjectValue=snap.data![i]['subject']['id'];

                                                                                        deleteTeacher();
                                                                                        setState(() { });
                                                                                        (context as Element).markNeedsBuild();


                                                                                      },
                                                                                      icon: Icon(Symbols.delete_rounded,
                                                                                        color: TColors.red,
                                                                                      )),
                                                                                );
                                                                              }
                                                                          );
                                                                        }),
                                                                  ),
                                                                  actions: [


                                                                    // Save Button
                                                                    ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Text("OK"),
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


                                                  onClickAdd: () async{
                                                    subjectValue=snap.data[i]['subject']['id'];
                                                    showDialog(context: context,
                                                        builder: (BuildContext context) {
                                                          return Builder(
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Padding(
                                                                    padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text("Add Teacher", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                                                                        IconButton(onPressed: (){
                                                                          teacherValue=null;
                                                                          Navigator.of(context).pop();
                                                                        }, icon: Icon(Symbols.close_rounded, color: TColors.black,))
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  content: Container(
                                                                    width: 909,
                                                                    height: 824,
                                                                    margin: EdgeInsets.only(left: 50, right: 50),
                                                                    child: Form(
                                                                      key: formState,
                                                                      child: Column(
                                                                        children: [
                                                                          FutureBuilder<dynamic>(
                                                                              future:getTeacher(),
                                                                              builder: (context,snp) {

                                                                                if (snp.connectionState == ConnectionState.waiting) {
                                                                                  return Center(child: CircularProgressIndicator());
                                                                                }
                                                                                if (snp.connectionState == ConnectionState.done) {
                                                                                  if (snp.hasError) {
                                                                                    return Center(child: Text("${snap.error}"));
                                                                                  }
                                                                                  if (snp.hasData) {
                                                                                    return DropdownButtonFormField<String>(

                                                                                      value: teacherValue,
                                                                                      hint: Text('select a teacher'),
                                                                                      onChanged: (newValue) {
                                                                                        teacherValue = newValue!;

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

                                                                                }
                                                                                return Text('');
                                                                              }
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  actions: [
                                                                    OutlinedButton(
                                                                      onPressed: () {
                                                                        teacherValue=null;

                                                                        Navigator.of(context).pop();

                                                                      },
                                                                      child: Text("Cancel", style: TextStyle(color: TColors.darkBlue),),
                                                                      style: OutlinedButton.styleFrom(
                                                                          side: BorderSide(
                                                                              color: TColors.darkBlue, width: 1)),
                                                                    ),

                                                                    // Save Button
                                                                    ElevatedButton(
                                                                      onPressed: () {
                                                                        AddTeacher();
                                                                        teacherValue=null;


                                                                      },
                                                                      child: Text("Add"),
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: TColors.darkBlue,
                                                                          textStyle: TextStyle(color: TColors.lightGray)
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                                                                );
                                                              }
                                                          );

                                                        });
                                                  },
                                                ))
                                                : TableCell(
                                                child: (index == 0) ?
                                                Padding(padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['subject']['SubjectId']['Name']}" + "  "),
                                                )
                                                    : (index == 1) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['subject']['IsLab']?"Lab":"theoretic"}" + "  "),
                                                )
                                                    : (index == 2) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: snap.data![i]['teachers']==[]?Text( "___"+ "  "):
                                                  Container(
                                                    height: 20,
                                                    child: ListView.builder(
                                                      itemCount: snap.data![i]['teachers']!.length,
                                                      itemBuilder: (context,l){
                                                        return  Text("${snap.data![i]['teachers'][l]['Name']}");
                                                      }
                                                      ,

                                                    ),
                                                  ),)
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

                  ],
                ),
              );
  }
}
