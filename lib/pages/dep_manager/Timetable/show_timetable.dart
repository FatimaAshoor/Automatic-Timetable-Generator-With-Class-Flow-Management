import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import 'package:timetable_admin/main.dart';
import 'package:timetable_admin/main.dart';

import '../dep_manager_main.dart';

class ShowTimetable extends StatefulWidget {
  final VoidCallback onDelete;
  const ShowTimetable({super.key, required this.onDelete});

  @override
  State<ShowTimetable> createState() => _ShowTimetableState();
}

class _ShowTimetableState extends State<ShowTimetable> {


  Info _info=Info();
  String? lectureSubjectValue;
  String? lectureTeacherValue;
  String? lectureLevelValue;
  String? lectureSpecializationValue;
  String? lectureGroupValue;
  bool? SubjectType;
  int? id;
  int? sem_subject_id;
  bool selectedSubject=false;
  bool selectedTeacher=false;
  bool selectedLevel=false;
  bool selectedSpec=false;
  bool existSpec = false;
  bool lectureCreated=true;

  int levelBtnIndex = 0;
  List? x11=[];
  List? x12=[];
  List? x13=[];
  List? x14=[];
  List? x15=[];
  List? x21=[];
  List? x22=[];
  List? x23=[];
  List? x24=[];
  List? x25=[];
  List? x31=[];
  List? x32=[];
  List? x33=[];
  List? x34=[];
  List? x35=[];
  int? levelValue=0;
  bool getTable=false;
  String? deptValue = sharedPref.getString("dm_id");

  showLevelTable() {
    switch (levelBtnIndex) {
      case 1:
        return customTable(context, "Level 2", x11, x12, x13, x14, x15,
             x21, x22, x23, x24, x25, x31, x32, x33, x34, x35);
      case 2:
        return customTable(context, "Level 3",x11, x12, x13, x14, x15,
            x21, x22, x23, x24, x25, x31, x32, x33, x34, x35);
      case 3:

        return customTable(context, "Level 4",x11, x12, x13, x14, x15,
            x21, x22, x23, x24, x25, x31, x32, x33, x34, x35);
      default:
        return customTable(context, "Level 1",x11, x12, x13, x14, x15,
            x21, x22, x23, x24, x25, x31, x32, x33, x34, x35);
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
  Future getTimeTable() async {
    var response = await _info.getRequest("${serverLink}/level_timetable/${deptValue}/${levelValue}");

    if (response!='failed') {
      List resBody = response;
      for (var lec in resBody){
        if (lec['Time']=="08:00 - 10:00"||lec['Time']=="2:00 - 4:00"){
         if (lec['Day']=='Sunday'){
           x11!.add(lec);

         }
         else if (lec['Day']=='Monday'){
           x12!.add(lec);

         }
         else if (lec['Day']=='Tuesday'){
           x13!.add(lec);

         }
         else if (lec['Day']=='Wednesday'){
           x14!.add(lec);

         }
         else if (lec['Day']=='Thursday'){
           x15!.add(lec);

         }
        }
        else if(lec['Time']=="10:00 - 12:00"||lec['Time']=="4:00 - 6:00"){
          if (lec['Day']=='Sunday'){
            x21!.add(lec);

          }
          else if (lec['Day']=='Monday'){
            x22!.add(lec);

          }
          else if (lec['Day']=='Tuesday'){
            x23!.add(lec);

          }
          else if (lec['Day']=='Wednesday'){
            x24!.add(lec);

          }
          else if (lec['Day']=='Thursday'){
            x25!.add(lec);

          }

        }
        else if(lec['Time']=="12:00 - 2:00"||lec['Time']=="6:00 - 8:00"){
          if (lec['Day']=='Sunday'){
            x31!.add(lec);

          }
          if (lec['Day']=='Monday'){
            x32!.add(lec);

          }
          if (lec['Day']=='Tuesday'){
            x33!.add(lec);

          }
          if (lec['Day']=='Wednesday'){
            x34!.add(lec);

          }
          if (lec['Day']=='Thursday'){
            x35!.add(lec);

          }
        }
      }

      return [1];


    }
  }
  Future getLevel() async {
    var response = await _info.getRequest("${serverLink}/dep_levels/${deptValue}");

    if (response!='failed') {
      List resBody = response;

      return resBody;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          publishDeleteButton(),
          SizedBox(height: 15,),
          
          FutureBuilder<dynamic>(
              future:getTimeTable(),
              builder: (context,snap) {

                if (snap.connectionState == ConnectionState.done) {
                  if (snap.hasError) {
                    return Center(child: Text("${snap.error}"));
                  }
                  if (snap.hasData && snap.data!=[]) {

                    return showLevelTable();}
                }
                return Text('');
              }
          ),
          SizedBox(height: 20,),
         FutureBuilder<dynamic>(
              future:Future.delayed(Duration(seconds: 1),()=>getLevel()),
              builder: (context,snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snap.connectionState == ConnectionState.done) {
                  if (snap.hasError) {
                    return Center(child: Text("${snap.error}"));
                  }
                  if (snap.hasData && snap.data!=[]) {
                       return SizedBox(
                         height: 50,
                         width: 300,
                         child: ListView.builder(
                           scrollDirection: Axis.horizontal,
                            itemCount:snap.data.length ,
                            itemBuilder: (BuildContext context,i) {
                              return Row(
                                children: [
                                  ElevatedButton(
                                  onPressed: () async{

                                       levelBtnIndex = i;

                                       levelValue=snap.data[i]['level']['id'];
                                       x11=[];
                                       x12=[];
                                       x13=[];
                                       x14=[];
                                        x15=[];
                                        x21=[];
                                        x22=[];
                                        x23=[];
                                        x24=[];
                                        x25=[];
                                        x31=[];
                                        x32=[];
                                        x33=[];
                                        x34=[];
                                        x35=[];
                                       await getTimeTable();
                                       setState(() {});

                                  },
                                    child: Text("${i+1}",
                                    style: TextStyle(
                                     color: levelBtnIndex == i
                                         ? TColors.lightGray
                                         : TColors.darkBlue),
                                                           ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      levelBtnIndex == i ? TColors.darkBlue : TColors.lightGray,
                                      shape: RoundedRectangleBorder(
                                   side: BorderSide(
                                     color:TColors.darkBlue,  // Specify the border color here
                                     width: 1, // Specify the border width here
                                   ),
                                   borderRadius: BorderRadius.circular(4),
                                                             ),
                                                           ),
                                                         ),
                                  SizedBox(width: 7,)
                                ],
                              );
                            }
                          ),
                       );}
                  }
                return Text('');
              }
          ),
        ],
      ),
    )
    ;
  }
}

class publishDeleteButton extends StatefulWidget {
  const publishDeleteButton({super.key});

  @override
  State<publishDeleteButton> createState() => _publishDeleteButtonState();
}

class _publishDeleteButtonState extends State<publishDeleteButton> {

  Info _info=Info();

  Future deleteData() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/timetable/${sharedPref.getString("dm_id")}");
    if (response==true){
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DepManagerMainPage()));
      sharedPref.setBool('createdTT', false);
    }
    else{
      Text("Error");
    }
  }

  var dmId = sharedPref.getString("dm_id");
  Future publishTimetable() async{
    var response = await _info.getRequest("${serverLink}/publish/$dmId");
    if (response!='failed') {
      List resBody = response;
      return resBody;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      width:400,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                        child: Column(
                          children: [
                            CircleAvatar(child: Icon(Symbols.warning_rounded, color: TColors.red,), backgroundColor: Color.fromRGBO(255, 31, 31, 0.1),),
                            SizedBox(height: 22,),
                            Text("Are you sure?",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                            SizedBox(height: 11,),
                            Text("The Timetable will be deleted.", style: TextStyle( color: TColors.darkGray), ),
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
                              onPressed: (){
                                deleteData();
                                sharedPref.setBool("created_timetable",false);
                                setState(() {

                                });
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
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Delete", style: TextStyle(color: TColors.white),),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: TColors.red,
                textStyle: TextStyle(color: TColors.white)),
          ),

          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      width:400,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                        child: Column(
                          children: [
                            CircleAvatar(child: Icon(Symbols.check_rounded, color: TColors.darkBlue,size: 60,), backgroundColor: Color.fromRGBO(48, 57, 114, 0.1)),
                            SizedBox(height: 20,),
                            Text("Timetable was published",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                            SizedBox(height: 10,),
                            Text("The Timetable was published to teachers and students.", style: TextStyle( color: TColors.darkGray), textAlign: TextAlign.center,) ,
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Center(
                        child: Container(
                          width: 200,
                          height: 38,
                          child: ElevatedButton(
                            onPressed: () async {
                              await publishTimetable();
                              Navigator.of(context).pop();
                            },
                            child: Text("OK", style: TextStyle(color: TColors.white),),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.darkBlue,
                                textStyle: TextStyle(color: TColors.white)
                            ),
                          ),
                        ),
                      ),
                    ],
                    actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Publish",
                style: TextStyle(color: TColors.darkBlue),
              ),
            ),
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: TColors.darkBlue, width: 1)),
          ),
        ],
      ),
    );
  }
}


Widget customTable(BuildContext context, String level,[List? x11,List? x12,List? x13,List? x14,List? x15,
    List? x21,List? x22,List? x23,List? x24,List? x25,List? x31,List? x32,List? x33,List? x34,List? x35]) {
  double widthTableCell = 120;
  double heightTableCell = 149;
  var period = sharedPref.getString('period');
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: TColors.darkBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Text(
            level,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColors.white,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10),
        child: Container(
          color: TColors.white,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
                color: TColors.darkGray, style: BorderStyle.solid, width: 0.5),
            children: [
              // Days
              TableRow(children: [
                TableCell(child: customTimeCell("Time"),),
                TableCell(child: customDayCell("Sun"),),
                TableCell(child: customDayCell("Mon"),),
                TableCell(child: customDayCell("Tue"),),
                TableCell(child: customDayCell("Wed"),),
                TableCell(child: customDayCell("Thu"),),
              ]),

              //08-10
              TableRow(children: [
                customTimeCell(period =='am'? "08 - 10":"12 - 02"),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x11!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x11[i]['Time'],
                              subject: x11[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x11[i]['LectureId']['TeacherId']['Name'],
                              classroom: x11[i]['ClassRoomId']['Name'],
                                group: x11[i]['LectureId']['GroupId']!=null?x11[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x11[i]['LectureId']['SpecId']!=null?x11[i]['LectureId']['SpecId']['Name']:'',

                                data:x11[i]

                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x12!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x12[i]['Time'],
                              subject: x12[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x12[i]['LectureId']['TeacherId']['Name'],
                              classroom: x12[i]['ClassRoomId']['Name'],
                                group: x12[i]['LectureId']['GroupId']!=null?x12[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x12[i]['LectureId']['SpecId']!=null?x12[i]['LectureId']['SpecId']['Name']:'',

                                data:x12[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x13!.length ,
                        itemBuilder: (context, i) {

                          return TableCell(
                            child: customTableCell(
                              time: x13[i]['Time'],
                              subject: x13[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x13[i]['LectureId']['TeacherId']['Name'],
                              classroom: x13[i]['ClassRoomId']['Name'],
                              group: x13[i]['LectureId']['GroupId']!=null?x13[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x13[i]['LectureId']['SpecId']!=null?x13[i]['LectureId']['SpecId']['Name']:'',

                                data:x13[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x14!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x14[i]['Time'],
                              subject: x14[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x14[i]['LectureId']['TeacherId']['Name'],
                              classroom: x14[i]['ClassRoomId']['Name'],
                                group: x14[i]['LectureId']['GroupId']!=null?x14[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x14[i]['LectureId']['SpecId']!=null?x14[i]['LectureId']['SpecId']['Name']:'',

                                data:x14[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x15!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x15[i]['Time'],
                              subject: x15[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x15[i]['LectureId']['TeacherId']['Name'],
                              classroom: x15[i]['ClassRoomId']['Name'],
                                group: x15[i]['LectureId']['GroupId']!=null?x15[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x15[i]['LectureId']['SpecId']!=null?x15[i]['LectureId']['SpecId']['Name']:'',
                                data:x15[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
              ]),

              //10-12
              TableRow(children: [
                customTimeCell(period =='am'? "10 - 12":"02 - 04"),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x21!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x21[i]['Time'],
                              subject: x21[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x21[i]['LectureId']['TeacherId']['Name'],
                              classroom: x21[i]['ClassRoomId']['Name'],
                                group: x21[i]['LectureId']['GroupId']!=null?x21[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x21[i]['LectureId']['SpecId']!=null?x21[i]['LectureId']['SpecId']['Name']:'',
                                data:x21[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x22!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x22[i]['Time'],
                              subject: x22[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x22[i]['LectureId']['TeacherId']['Name'],
                              classroom: x22[i]['ClassRoomId']['Name'],
                                group: x22[i]['LectureId']['GroupId']!=null?x22[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x22[i]['LectureId']['SpecId']!=null?x22[i]['LectureId']['SpecId']['Name']:'',
                                data:x22[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x23!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x23[i]['Time'],
                              subject: x23[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x23[i]['LectureId']['TeacherId']['Name'],
                              classroom: x23[i]['ClassRoomId']['Name'],
                                group: x23[i]['LectureId']['GroupId']!=null?x23[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x23[i]['LectureId']['SpecId']!=null?x23[i]['LectureId']['SpecId']['Name']:'',
                                data:x23[i]
                            ),
                          );
                        }
                    ),
                  ),
                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x24!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x24[i]['Time'],
                              subject: x24[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x24[i]['LectureId']['TeacherId']['Name'],
                              classroom: x24[i]['ClassRoomId']['Name'],
                                group: x24[i]['LectureId']['GroupId']!=null?x24[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x24[i]['LectureId']['SpecId']!=null?x24[i]['LectureId']['SpecId']['Name']:'',
                                data:x24[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x25!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x25[i]['Time'],
                              subject: x25[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x25[i]['LectureId']['TeacherId']['Name'],
                              classroom: x25[i]['ClassRoomId']['Name'],
                                group: x25[i]['LectureId']['GroupId']!=null?x25[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x25[i]['LectureId']['SpecId']!=null?x25[i]['LectureId']['SpecId']['Name']:'',
                                data:x25[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
              ]),

              //12-02
              TableRow(children: [
                customTimeCell(period =='am'? "12 - 02":"04 - 06"),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x31!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x31[i]['Time'],
                              subject: x31[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x31[i]['LectureId']['TeacherId']['Name'],
                              classroom: x31[i]['ClassRoomId']['Name'],
                                group: x31[i]['LectureId']['GroupId']!=null?x31[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x31[i]['LectureId']['SpecId']!=null?x31[i]['LectureId']['SpecId']['Name']:'',
                                data:x31[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x32!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x32[i]['Time'],
                              subject: x32[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x32[i]['LectureId']['TeacherId']['Name'],
                              classroom: x32[i]['ClassRoomId']['Name'],
                                group: x32[i]['LectureId']['GroupId']!=null?x32[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x32[i]['LectureId']['SpecId']!=null?x32[i]['LectureId']['SpecId']['Name']:'',
                              data: x32[i],
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x33!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x33[i]['Time'],
                              subject: x33[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x33[i]['LectureId']['TeacherId']['Name'],
                              classroom: x33[i]['ClassRoomId']['Name'],
                                group: x33[i]['LectureId']['GroupId']!=null?x33[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x33[i]['LectureId']['SpecId']!=null?x33[i]['LectureId']['SpecId']['Name']:'',
                              data: x33[i],
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x34!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                              time: x34[i]['Time'],
                              subject: x34[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                              teacher: x34[i]['LectureId']['TeacherId']['Name'],
                              classroom: x34[i]['ClassRoomId']['Name'],
                                group: x34[i]['LectureId']['GroupId']!=null?x34[i]['LectureId']['GroupId']['Name']:"",
                                specialization: x34[i]['LectureId']['SpecId']!=null?x34[i]['LectureId']['SpecId']['Name']:''
                                 ,data:x34[i]
                            ),
                          );
                        }
                    ),
                  ),

                ),
                Container(
                  height: heightTableCell,
                  width: widthTableCell,
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:x35!.length ,
                        itemBuilder: (context, i) {
                          return TableCell(
                            child: customTableCell(
                                time: x35[i]['Time'],
                                subject: x35[i]['LectureId']['SubjectId']['SubjectId']['Name'],
                                teacher: x35[i]['LectureId']['TeacherId']['Name'],
                                classroom: x35[i]['ClassRoomId']['Name'],
                                group: x35[i]['LectureId']['GroupId']!=null?x35[i]['LectureId']['GroupId']['Name']:" ",
                                specialization: x35[i]['LectureId']['SpecId']!=null?x35[i]['LectureId']['SpecId']['Name']:'',
                                data: x35[i],
                            ),
                          );
                        }
                    ),
                  ),

                ),
              ]),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget customDayCell(String day) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Text( day, style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
      ],
    ),
  );
}

Widget customTimeCell(String day) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Text( day, style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
      ],
    ),
  );
}

class customTableCell extends StatefulWidget {
  final String time;
  final String subject;
  final String teacher;
  final String classroom;
  final Map data;

  String? group ;
  String? specialization;
  customTableCell({super.key, required this.time, required this.subject, required this.teacher, required this.classroom, this.group,this.specialization,required this.data});

  @override
  State<customTableCell> createState() => _customTableCellState();
}

class _customTableCellState extends State<customTableCell> {
  Info _info=Info();
  int? id;
  String? TbId;
  String? lectureSubjectValue;
  String? lectureTeacherValue;
  int? lectureValue;
  String? classRoomValue;
  String? lectureTimeValue;
  String? lectureDayValue;


  bool? SubjectType;

  bool lectureCreated=true;
  String? deptValue = sharedPref.getString("dm_id");
  List days=
  [{'day': "Sunday"},
    {'day': "Monday"},
    {'day': "Tuesday"},
    {'day': "Wednesday"},
    {'day':"Thursday"}] ;
 List times=
 [{'Time': "08:00 - 10:00"},
   {'Time': "10:00 - 12:00"},
   {'Time': "12:00 - 2:00"},
   {'Time': "2:00 - 4:00"},
   {'Time': "4:00 - 6:00"}] ;


  Future getClassRooms() async {
    var response = await _info.getRequest("${serverLink}/classroom");
     String? time=await sharedPref.getString('period');
    if(time=='am') {
      times=
      [{'Time': "08:00 - 10:00"},
        {'Time': "10:00 - 12:00"},
        {'Time': "12:00 - 2:00"},
       ] ;
    }
    else{
      times=
      [
        {'Time': "12:00 - 2:00"},
        {'Time': "2:00 - 4:00"},
        {'Time': "4:00 - 6:00"}
      ] ;
    }
    if (response!='failed') {
      List resBody = response;

      return resBody;
    }

  }



  Future putData() async {
    var response = await _info.putLecture("http://127.0.0.1:8000/API/timetable/${id.toString()}",
        {
          "id":"$id",
          "TimetableId":"$TbId",
          "LectureId":"$lectureValue",
          "ClassRoomId":"$classRoomValue",
          "Time":"$lectureTimeValue",
          "Day":"$lectureDayValue",
        });
    if (response==true){
      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("depManagerMainPage");
    }
    else{
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width:400,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                child: Column(
                  children: [
                    CircleAvatar(child: Icon(Symbols.warning_rounded, color: TColors.red, size: 60,), backgroundColor: Color.fromRGBO(255, 31, 31, 0.1),),
                    SizedBox(height: 18,),
                    Text("you can't edit",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                    SizedBox(height: 8,),
                    Text("${response['message']}", style: TextStyle( color: TColors.darkGray), ),
                  ],
                ),
              ),
            ),
            actions: [
              Center(
                child: Container(
                  width: 200,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("OK", style: TextStyle(color: TColors.white),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.red,
                        textStyle: TextStyle(color: TColors.white)
                    ),
                  ),
                ),
              ),
            ],
            actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 3,),
                  Row(
                    children: [
                      Text("${widget.subject}", style: TextStyle(color: TColors.black, fontWeight: FontWeight.bold),),
                      IconButton(
                          onPressed:  () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  lectureSubjectValue=widget.subject;
                                  TbId=widget.data['TimetableId'].toString();
                                  lectureTeacherValue=widget.data['LectureId']['TeacherId']['Name'].toString();
                                  lectureDayValue=widget.data['Day'];
                                  lectureTimeValue=widget.data['Time'];
                                  lectureValue=widget.data['LectureId']['id'];
                                  classRoomValue=widget.data['ClassRoomId']['id'].toString();
                                  id=widget.data['id'];

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
                                                    TextFormField(
                                                      initialValue: lectureSubjectValue,
                                                      enabled: false,
                                                    ),
                                                    SizedBox(height: 16,),
                                                    TextFormField(
                                                      initialValue: lectureTeacherValue,
                                                      enabled: false,
                                                    ),
                                                    SizedBox(height: 16,),
                                                    FutureBuilder<dynamic>(
                                                        future:getClassRooms(),
                                                        builder: (context,snp) {

                                                          if (snp.hasData) {
                                                            return DropdownButtonFormField<String>(
                                                              value: classRoomValue,
                                                              hint:Text('select the classroom'),
                                                              onChanged: (newValue) {
                                                                setState(() {
                                                                  classRoomValue = newValue!;


                                                                });
                                                                (context as Element).markNeedsBuild();
                                                              },
                                                              items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                                return DropdownMenuItem<String>(
                                                                  value: value['id'].toString(),
                                                                  child: Text('${value['Name']}'+' (${value['ClassTypeId']['Name']}'),
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
                                                    DropdownButtonFormField<String>(
                                                      value: lectureDayValue,
                                                      hint:Text('select the day'),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          lectureDayValue = newValue!;


                                                        });
                                                        (context as Element).markNeedsBuild();
                                                      },
                                                      items: days!.map<DropdownMenuItem<String>>((value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value['day'].toString(),
                                                          child: Text('${value['day']}'),
                                                        );
                                                      }).toList(),
                                                    ),
                                                     SizedBox(height: 16,),
                                                    DropdownButtonFormField<String>(
                                                  value: lectureTimeValue,
                                                  hint:Text('select the time'),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      lectureTimeValue = newValue!;


                                                  });
                                                  (context as Element).markNeedsBuild();
                                                },
                                                items: times!.map<DropdownMenuItem<String>>((value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value['Time'].toString(),
                                                    child: Text('${value['Time']}'),
                                                  );
                                                }).toList(),
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
                          }
                          , icon: Icon(Symbols.edit_rounded, color: TColors.orange, size: 16,)
                      ),
                    ],
                  ),
                  SizedBox(height: 1,),
                  Text("${widget.teacher}", style: TextStyle(color: TColors.black),),
                  SizedBox(height: 1,),
                  Text("${widget.classroom}", style: TextStyle(color: TColors.black, fontWeight: FontWeight.bold),),
                  SizedBox(height: 1,),
                  Text("${widget.group}", style: TextStyle(color: TColors.black, fontWeight: FontWeight.bold),),
                  SizedBox(height: 1,),
                  Text("${widget.specialization}", style: TextStyle(color: TColors.black, fontWeight: FontWeight.bold),)
                  ,
                ],
              )

    );
  }
}

