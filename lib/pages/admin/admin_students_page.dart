import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timetable_admin/Business Logic/components/info.dart';


import 'package:timetable_admin/widgets/two_actions.dart';

import '../../Business Logic/components/valid.dart';


class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {

  GlobalKey<FormState> formState = GlobalKey();
  int? id;
  TextEditingController NameValue = TextEditingController();

  String? deptValue ;
  String? levelValue ;
  String? groupValue ;
  String? specializationValue ;
  TextEditingController emailValue = TextEditingController();
  TextEditingController passwordValue = TextEditingController();
  Info _info=Info();

  String? newDepartment ="0";
  String? updatedDepartment;



  bool selctedDept=false;
  bool selctedLevel=false;
  bool selctedSpec=false;
  bool existSpec=false;

  bool isEditing = false;
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }
  Future getData() async {
    var response = await _info.getRequest("${serverLink}/students");

    if (response!='failed') {
      List resBody = response;

      return resBody;
    }
  }
  Future getDept() async {
    var response = await _info.getRequest("${serverLink}/department");

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
    var response = await _info.getRequest("${serverLink}/specialization/${levelValue}");

    if (response!='failed') {
      List resBody = response;

      return resBody;
    }
    return null;
  }
  Future getGroup() async {

    if (specializationValue==null) {
       var response = await _info.getRequest("${serverLink}/level_groups/${levelValue}");
       if (response!='failed') {
         List resBody = response;
         print(resBody);
         return resBody;
       }
    }
    else{
       var response = await _info.getRequest("${serverLink}/spec_groups/${specializationValue}");
       if (response!='failed') {
         List resBody = response;
         return resBody;
       }
    }

  }
  Future AddData() async {
    var response = await _info.postRequest("${serverLink}/student",
        {
      "account":jsonEncode({"Email":emailValue.text,
      "Password":passwordValue.text,
        "roles":"${[3]}"}),
      "student":jsonEncode({"Name":NameValue.text,
      "LevelId":"$levelValue",
      "GroupId":"$groupValue",
      "SpecializationId":specializationValue!=null?"$specializationValue":'0',
      "DepartmentId":"$deptValue",})
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
    var response = await _info.putRequest("http://127.0.0.1:8000/API/student/${id.toString()}",
        {
    "account":jsonEncode({"Email":emailValue.text,
    "Password":passwordValue.text,
      "roles":"${3}"}),
    "student":jsonEncode({"Name":NameValue.text,
    "LevelId":"$levelValue",
    "GroupId":"$groupValue",
    "SpecializationId":specializationValue!=null?"$specializationValue":'0',
    "DepartmentId":"$deptValue",})
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
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/student/${id.toString()}");
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
                  Text("Student Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                  Text("Department", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                  Text("Level", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                  Text("Specialization", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),

                  Text("Group", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                  Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                  Text("Password", style: TextStyle( fontWeight: FontWeight.bold, color: TColors.black),),
                  Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), textAlign: TextAlign.center),
                ],
              ),
            ],
          ),
        ),

        //  table
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
                                  children: List.generate(8, (index) =>
                                  index==7?
                                  TableCell(child: TwoActions(
                                    onClickDelete: () async{
                                      id=snap.data![i]['id'];
                                      await deleteData();
                                    },
                                    onClickUpdate: (){
                                      id=snap.data![i]['id'];
                                      NameValue=TextEditingController(text:"${snap.data![i]['Name']}");
                                      emailValue=TextEditingController(text:"${snap.data![i]['AccountId']['Email']}");
                                      passwordValue=TextEditingController(text:"${snap.data![i]['AccountId']['Password']}");
                                      deptValue=snap.data![i]['DepartmentId']['Id'].toString();
                                      levelValue=snap.data![i]['LevelId']['id'].toString();
                                      specializationValue=snap.data![i]['SpecializationId']==null?null:snap.data![i]['SpecializationId']['id'].toString();
                                      groupValue=snap.data![i]['GroupId']['id'].toString();
                                      selctedDept=true;
                                      selctedLevel=true;
                                      selctedSpec= existSpec==true?true:false;
                                      showDialog(context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Padding(
                                                padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Edit Student", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                                child: SingleChildScrollView(
                                                  child: Form(
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller: NameValue,
                                                          decoration: InputDecoration(
                                                              hintText: "Student Name",
                                                              border: OutlineInputBorder()),
                                                        ),
                                                        SizedBox(height: 16,),
                                                        TextFormField(
                                                          validator: (value){
                                                            validEmailInput(value!);
                                                          },
                                                          controller: emailValue,
                                                          decoration: InputDecoration(
                                                              hintText: "Student Email",
                                                              border: OutlineInputBorder()),
                                                        ),
                                                        SizedBox(height: 16,),
                                                        TextFormField(
                                                          validator: (value){
                                                            validatePassword(value!);
                                                          },
                                                          controller: passwordValue,
                                                          decoration: InputDecoration(
                                                              hintText: "Student Password",
                                                              border: OutlineInputBorder()),
                                                        ),
                                                        SizedBox(height: 16,),
                                                        FutureBuilder<dynamic>(
                                                            future:getDept(),
                                                            builder: (context,snp) {
                                                              if (snp.hasData) {
                                                                return DropdownButtonFormField<String>(
                                                                  value: deptValue,
                                                                  hint:Text('select the department'),
                                                                  onChanged: (newValue) {

                                                                    setState(() {
                                                                      deptValue = newValue!;
                                                                      selctedDept=true;
                                                                    });

                                                                    (context as Element).markNeedsBuild();
                                                                  },
                                                                  items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                                    return DropdownMenuItem<String>(
                                                                      value: value['Department']['Id'].toString(),
                                                                      child: Text('${value['Department']['Name']}'),
                                                                    );
                                                                  }).toList(),
                                                                );
                                                              }
                                                              else
                                                              {
                                                                return Text("");
                                                              }
                                                            }
                                                        ),
                                                        SizedBox(height: 16,),
                                                        selctedDept==true?
                                                        FutureBuilder<dynamic>(
                                                            future:getLevel(),
                                                            builder: (context,snp) {
                                                              if (snp.hasData) {
                                                                return DropdownButtonFormField<String>(
                                                                  value: levelValue,
                                                                  hint:Text('select the level'),
                                                                  onChanged: (newValue) {
                                                                    setState(() {
                                                                      levelValue = newValue!;
                                                                      selctedLevel=true;
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
                                                        selctedLevel==true?
                                                        FutureBuilder<dynamic>(
                                                            future:getSpec(),
                                                            builder: (context,snp) {
                                                              if (snp.hasData) {
                                                                if (snp.data.length>=1){
                                                                  //عشان التعديل
                                                                  existSpec=true;
                                                                  return DropdownButtonFormField<String>(
                                                                    value: specializationValue,
                                                                    hint:Text('select the specialization'),
                                                                    onChanged: (newValue) {
                                                                      setState(() {
                                                                        specializationValue = newValue!;

                                                                        selctedSpec=true;
                                                                      });
                                                                      (context as Element).markNeedsBuild();
                                                                    },
                                                                    items: snp.data.map<DropdownMenuItem<String>>((value) {
                                                                      return DropdownMenuItem<String?>(
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
                                                                            value: groupValue,
                                                                            hint:Text('select the group'),
                                                                            onChanged: (newValue) {
                                                                              setState(() {
                                                                                groupValue = newValue!;
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
                                                        selctedSpec==true?
                                                        FutureBuilder<dynamic>(
                                                            future:getGroup(),
                                                            builder: (context,snp) {
                                                              if (snp.hasData) {
                                                                return DropdownButtonFormField<String>(
                                                                  value: groupValue,
                                                                  hint:Text('select the group'),
                                                                  onChanged: (newValue) {
                                                                    setState(() {
                                                                      groupValue = newValue!;
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
                                                  child: Text("Cancel", style: TextStyle(color: TColors.darkBlue),),
                                                  style: OutlinedButton.styleFrom(
                                                      side:BorderSide(
                                                      color:TColors.darkBlue, width: 1)),
                                                ),
                                                // Update Button
                                                ElevatedButton(
                                                  onPressed:(){
                                                    putData();},
                                                  child: Text("Update", style:TextStyle(color: TColors.lightGray) ),
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: TColors.darkBlue,
                                                      textStyle: TextStyle(color: TColors.lightGray)
                                                  ),
                                                ),
                                              ],
                                              actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                                            );
                                          }
                                      );}
                                    ,)
                                  ) :
                                  TableCell(
                                      child:   (index==0)?
                                      Padding(padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['Name']}" + "  "),
                                      )
                                          : (index==1)?
                                          Padding(padding: const EdgeInsets.all(10),
                                           child: Text( "${snap.data![i]['DepartmentId']['Name']}" + "  "),
                                      )

                                          : (index==2)?
                                      Padding(padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['LevelId']['Name']}" + "  "),
                                      )
                                          : (index==3)?
                                      Padding(padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['SpecializationId']==null?'___':snap.data![i]['SpecializationId']['Name']}" + "  "),
                                      ) : (index==4)?
                                      Padding(padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['GroupId']['Name']}" + "  "),
                                      )
                                          : (index==5)?
                                      Padding(padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['AccountId']['Email']}" + "  "),
                                      )
                                          : (index==6)?
                                      Padding(padding: const EdgeInsets.all(10),
                                        child: Text( "${snap.data![i]['AccountId']['Password']}" + "  "),
                                      )
                                          : Text(""))
                                  )
                              )])
                  );
                }
                else {
                  Text("There is no Data");
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
                id;
                NameValue=TextEditingController();
                emailValue=TextEditingController();
                passwordValue=TextEditingController();
                deptValue;
                levelValue;
                specializationValue;
                groupValue;
                selctedDept;
                selctedLevel;
                selctedSpec; existSpec;

                showDialog(
                    context: context,
                    builder: (context) {
                      NameValue=TextEditingController(text:"");
                      deptValue=null;
                      levelValue=null;
                      specializationValue=null;
                      groupValue=null;
                      selctedDept=false;
                      selctedLevel=false;
                      selctedSpec=false;
                      return StatefulBuilder(
                        builder: (BuildContext context,setState) {

                          return AlertDialog(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Add new student", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                              child: SingleChildScrollView(
                                child: Form(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: NameValue,
                                        decoration: InputDecoration(
                                            hintText: "Student Name",
                                            border: OutlineInputBorder()),
                                      ),
                                      SizedBox(height: 16,),
                                      TextFormField(
                                        validator: (value){
                                          validEmailInput(value!);
                                        },
                                        controller: emailValue,
                                        decoration: InputDecoration(
                                            hintText: "Student Email",
                                            border: OutlineInputBorder()),
                                      ),
                                      SizedBox(height: 16,),
                                      TextFormField(
                                        validator: (value){
                                          validatePassword(value!);
                                        },
                                        controller: passwordValue,
                                        decoration: InputDecoration(
                                            hintText: "Student Password",
                                            border: OutlineInputBorder()),
                                      ),
                                      SizedBox(height: 16,),
                                      FutureBuilder<dynamic>(
                                          future:getDept(),
                                          builder: (context,snp) {
                                            if (snp.hasData) {
                                              return DropdownButtonFormField<String>(
                                                value: deptValue,
                                                hint:Text('select the department'),
                                                onChanged: (newValue) {

                                                  setState(() {
                                                    deptValue = newValue!;
                                                    selctedDept=true;
                                                  });

                                                  (context as Element).markNeedsBuild();
                                                },
                                                items: snp.data!.map<DropdownMenuItem<String>>((value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value['Department']['Id'].toString(),
                                                    child: Text('${value['Department']['Name']}'),
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
                                      selctedDept==true?
                                      FutureBuilder<dynamic>(
                                          future:getLevel(),
                                          builder: (context,snp) {
                                            if (snp.hasData) {
                                              return DropdownButtonFormField<String>(
                                                value: levelValue,
                                                hint:Text('select the level'),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    levelValue = newValue!;
                                                    selctedLevel=true;
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
                                      selctedLevel==true?
                                      FutureBuilder<dynamic>(
                                          future:getSpec(),
                                          builder: (context,snp) {
                                            if (snp.hasData) {

                                             if (snp.data.length>=1){
                                              return DropdownButtonFormField<String>(
                                                value: specializationValue,
                                                hint:Text('select the specialization'),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    specializationValue = newValue!;
                                                    selctedSpec=true;
                                                  });
                                                  (context as Element).markNeedsBuild();
                                                },
                                                items: snp.data.map<DropdownMenuItem<String>>((value) {
                                                  return DropdownMenuItem<String?>(
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
                                                       value: groupValue,
                                                       hint:Text('select the group'),
                                                       onChanged: (newValue) {
                                                         setState(() {
                                                           groupValue = newValue!;
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
                                      selctedSpec==true?
                                      FutureBuilder<dynamic>(
                                          future:getGroup(),
                                          builder: (context,snp) {
                                            if (snp.hasData) {
                                              return DropdownButtonFormField<String>(
                                                value: groupValue,
                                                hint:Text('select the group'),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    groupValue = newValue!;
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
                                child: Text("Cancel", style: TextStyle(color: TColors.darkBlue),),
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: TColors.darkBlue, width: 1)),
                              ),

                              // Save Button
                              ElevatedButton(
                                onPressed: () {

                                  AddData();
                                },
                                child: Text("Save", style:TextStyle(color: TColors.lightGray) ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.darkBlue,
                                ),
                              ),
                            ],
                            actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                          );
                        }
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


