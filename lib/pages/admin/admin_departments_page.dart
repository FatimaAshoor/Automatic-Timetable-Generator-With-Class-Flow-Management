import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:timetable_admin/Business%20Logic/components/link_api.dart';
import 'package:timetable_admin/Business%20Logic/models/departments_model.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timetable_admin/pages/admin/admin_main.dart';
import 'package:timetable_admin/widgets/two_actions.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';


class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({super.key});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  Info _info =Info();

  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController Id = TextEditingController();
  TextEditingController depValue = TextEditingController();
  TextEditingController levelValue = TextEditingController();
  TextEditingController periodValue = TextEditingController();
  TextEditingController teacherValue = TextEditingController();
  String? selectedTeacher;
  String? selectedPeriod;
  String? id;

  String depName ="IT" ;
  String levels ="4" ;
  String managerName ="Ali Ahmed";

  bool isEditing = false;
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }


  Future getData() async {
    var response = await _info.getRequest("http://127.0.0.1:8000/API/department");

    if (response!='failed') {
      List resBody =response;
      return resBody;
    }}
  getTeacher() async {
    //الأي دي لازم يتغير يكون لكل قسم مدرسينه
    var response = await _info.getRequest("http://127.0.0.1:8000/API/teacher");
    if (response!='failed') {

      return response;
    }
    return [{'':''}] ;
  }

  Future postNestedData() async {
    dynamic map={
      "Department":
    jsonEncode({
        "Id":Id.text,
        "Name":depValue.text,
        "Levels":levelValue.text,
        "period":periodValue.text
      }),
      "DM":
    jsonEncode({
        "id":teacherValue.text
      })
    };

    var response = await _info.postRequest("http://127.0.0.1:8000/API/department",map );
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminMainPage(pageIndex:0)));
    }
    else{
      Text("${response.statusCode}");
    }
  }

  Future putNestedData() async {
    var dep={
      'Id':Id.text,
      'Name':depValue.text,
      'Levels':levelValue.text,
      'period':periodValue.text
    };
    var dm={
      'id':teacherValue.text
    };
    Map<String,dynamic> map={
      'Department':jsonEncode(dep),
      'DM':jsonEncode(dm)

    };

    var response = await _info.putRequest("http://127.0.0.1:8000/API/department/${Id.text}",map);
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminMainPage(pageIndex:0)));
    }
    else{
      print("Error");
    }
  }

  Future deleteData() async {
    var response = await _info.deleteRequest("${serverLink}/department/${id.toString()}");
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminMainPage(pageIndex:0)));
    }
    else{
      Text("Error");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(children: [
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
            right: 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: TColors.darkBlue,
              ),
              height: 38,
              width: 100,
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
                  Text("Sort by", style: TextStyle(fontWeight: FontWeight.bold,color: TColors.white),),
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
                    Text("ID", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Department Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Levels", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Duration", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Dep. manager name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
          ),

          // Table Content
          Container(
            margin: EdgeInsets.only(top: 50,),
            padding: EdgeInsets.only(top: 38),
            child: FutureBuilder(
              future: getData(),
              builder: (context, snap){
                if(snap.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(snap.connectionState==ConnectionState.done){
                  if(snap.hasError){
                    return Center(child: Text("${snap.error}"));
                  }

                  if(snap.hasData){
                    return SingleChildScrollView(
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          for (int i = 0; i < snap.data!.length; i++)
                            TableRow(
                                children: List.generate(6, (index) =>
                                    index==5?
                                    TableCell(child: TwoActions(
                                      onClickDelete: () async {
                                        id=snap.data[i]['Department']['Id'];
                                        await deleteData();
                                      },
                                      onClickUpdate: (){
                                        showDialog(context: context,
                                            builder: (BuildContext context) {
                                               Id = TextEditingController(text:"${snap.data[i]['Department']['Id']}");
                                               depValue = TextEditingController(text: "${snap.data![i]['Department']['Name']}");
                                               levelValue = TextEditingController(text: "${snap.data![i]['Department']['Levels']}");
                                               periodValue = TextEditingController(text: "${snap.data![i]['Department']['period']}");
                                               teacherValue = TextEditingController(text: "${snap.data![i]['DM']['TeacherId']['id']}");
                                               selectedTeacher=snap.data![i]['DM']['TeacherId']['id'].toString();

                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("Update department", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                                                          IconButton(onPressed: (){
                                                            Id = TextEditingController();
                                                            depValue = TextEditingController();
                                                            levelValue = TextEditingController();
                                                            periodValue = TextEditingController();
                                                            teacherValue = TextEditingController();
                                                            selectedTeacher=null;

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

                                                            TextFormField(

                                                              controller: depValue,
                                                              decoration: InputDecoration(
                                                                  hintText: "Department Name",
                                                                  border: OutlineInputBorder()),
                                                            ),
                                                            SizedBox(height: 16,),
                                                            TextFormField(
                                                              controller: levelValue,
                                                              decoration: InputDecoration(
                                                                  hintText: "Years",
                                                                  border: OutlineInputBorder()),
                                                            ),
                                                            SizedBox(height: 16,),
                                                            DropdownButtonFormField<String>(
                                                              value: periodValue.text,
                                                              hint:Text('select the duration'),
                                                              onChanged: (newValue) {

                                                                periodValue.text=newValue!;
                                                                (context as Element).markNeedsBuild();
                                                              },
                                                              items: {'am','pm'}.map<DropdownMenuItem<String>>((value) {
                                                                return DropdownMenuItem<String>(
                                                                  value:value ,
                                                                  child: Text('$value'),
                                                                );
                                                              }).toList(),
                                                            ),
                                                            SizedBox(height: 16,),
                                                            FutureBuilder<dynamic>(
                                                                future:getTeacher(),
                                                                builder: (context,snp) {


                                                                  if (snp.hasData) {
                                                                    return DropdownButtonFormField<String>(
                                                                      value: selectedTeacher,
                                                                      onChanged: (newValue) {
                                                                        selectedTeacher = newValue!;
                                                                        teacherValue.text=newValue;
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
                                                                    return Text("No data");
                                                                  }

                                                                }
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    actions: [
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Id = TextEditingController();
                                                          depValue = TextEditingController();
                                                          levelValue = TextEditingController();
                                                          periodValue = TextEditingController();
                                                          teacherValue = TextEditingController();
                                                          selectedTeacher=null;
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Cancel", style: TextStyle(color: TColors.darkBlue),),
                                                        style: OutlinedButton.styleFrom(
                                                            side: BorderSide(
                                                                color: TColors.darkBlue, width: 1)),
                                                      ),

                                                      // Save Button
                                                      ElevatedButton(
                                                        onPressed: ()async {
                                                          await putNestedData();
                                                        },
                                                        child: Text("Update", style:TextStyle(color: TColors.lightGray) ),
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: TColors.darkBlue,
                                                        ),
                                                      ),
                                                    ],
                                                    actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                                                  );
                                                }
                                              );
                                            }
                                        );
                                        },
                                    )
                                    ) :
                                    TableCell(
                                      child:   (index==0)?
                                      Padding(padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['Department']['Id']}" + "  "),
                                      )
                                          : (index == 1) ?
                                      Padding( padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['Department']['Name']}" + "  "),
                                      )
                                          : (index==2)?
                                      Padding( padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['Department']['Levels']}" + "  "),
                                      )
                                          : (index==3)?
                                      Padding( padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['Department']['period']}" + "  "),
                                      )
                                          : (index==4)?
                                      Padding( padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['DM']['TeacherId']['Name']}" + "  "),
                                      )
                                          : Text(""))
                                )
                            )])
                    );
                  }
                }
                return Text("");
              },
            ),
          ),

          // add button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                onPressed: () {
                  Id = TextEditingController();
                  depValue = TextEditingController();
                  levelValue = TextEditingController();
                  periodValue = TextEditingController();
                  teacherValue = TextEditingController();
                  selectedTeacher=null;

                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Add new department", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                                IconButton(onPressed: (){
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
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: Id,
                                    decoration: InputDecoration(
                                        hintText: "Department Id",
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: 16,),
                                  TextFormField(
                                    controller: depValue,
                                    decoration: InputDecoration(
                                        hintText: "Department name",
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: 16,),
                                  TextFormField(
                                    controller: levelValue,
                                    decoration: InputDecoration(
                                        hintText: "Levels",
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: 16,),
                              DropdownButtonFormField<String>(
                                value: selectedPeriod,
                                hint:Text('select the duration'),
                                onChanged: (newValue) {
                                  selectedPeriod = newValue!;
                                  periodValue.text=newValue;
                                  (context as Element).markNeedsBuild();
                                },
                                items: {'am','pm'}.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value:value ,
                                    child: Text('$value'),
                                  );
                                }).toList(),
                              ),
                                  SizedBox(height: 16,),
                                  FutureBuilder<dynamic>(
                                      future:getTeacher(),
                                      builder: (context,snp) {
                                        if (snp.hasData) {
                                          return DropdownButtonFormField<String>(
                                            value: selectedTeacher,
                                            hint:Text('select the department manager'),
                                            onChanged: (newValue) {
                                              selectedTeacher = newValue!;
                                              teacherValue.text=newValue;
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
                                          return Text("No data");
                                        }

                                      }
                                  )
                                ],
                              ),
                            ),
                          ),



                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel", style: TextStyle(color: TColors.darkBlue),),
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: TColors.darkBlue, width: 1)),
                            ),

                            // Save Button
                            ElevatedButton(
                              onPressed: () async {
                                await postNestedData();
                              },
                              child: Text("Save", style: TextStyle(color: TColors.white),),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.darkBlue,
                              ),
                            ),
                          ],
                          actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                        );
                      });
                },
                color: TColors.darkBlue,
                textColor: Colors.white,
                child: Icon(
                  Symbols.add_rounded,
                  size: 24,
                ),
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
              ),
            ),
          )
        ]),
    );
  }
}


