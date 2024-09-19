import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/widgets/two_actions.dart';
import 'dart:convert';
import 'package:timetable_admin/Business Logic/components/info.dart';

import '../../../constant/t_colors.dart';
import '../../Business Logic/components/valid.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController NameValue = TextEditingController();
  String? AcademicLevelValue ;
  //Added by Fatima
  String? deptValue ;
  bool selectedDept = false;
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

  String? newSubType = "0";
  String? updatedSubType;

  Future getData() async {
    var response = await _info.getRequest("${serverLink}/teacher");

    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }

  //Added by Fatima
  Future getDept() async {
    var response = await _info.getRequest("${serverLink}/department");
    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }

  Future AddData() async {
    var response = await _info.postRequest("${serverLink}/teacher",
        {
          "account":jsonEncode({"Email":emailValue.text,
            "Password":passwordValue.text,
            "roles":"${[1]}"}),
          "teacher":jsonEncode({"Name":NameValue.text,
            "Academic_Degree":"$AcademicLevelValue",
            "DepartmentId":"$DepartmentValue",})
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
    var response = await _info.putRequest("http://127.0.0.1:8000/API/teacher/${id.toString()}",
        {
          "account":jsonEncode({"Email":emailValue.text,
            "Password":passwordValue.text,
            "roles":"${[1]}"}),
          "teacher":jsonEncode({"Name":NameValue.text,
            "AccountId":"${accountValue.toString()}",
            "Academic_Degree":"$AcademicLevelValue",
            "DepartmentId":"$DepartmentValue",})
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
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/teacher/${id.toString()}");
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
                    Text("Teacher Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Department", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Academic Level", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                    Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black,), textAlign: TextAlign.center,),
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
              future: getData() ,
              builder: (context,snap) {
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
                                index == 5? TableCell(
                                    child: TwoActions(
                                      onClickDelete: ()async {
                                        id=snap.data[i]['id'];
                                        await deleteData();
                                      },
                                      onClickUpdate: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              id=snap.data[i]['id'];
                                              NameValue=TextEditingController(text: '${snap.data[i]['Name']}');
                                              AcademicLevelValue=snap.data[i]['Academic_Degree'];
                                              //
                                              deptValue=snap.data![i]['DepartmentId']['Id'].toString();
                                              accountValue=snap.data[i]['AccountId']['id'].toString();
                                              emailValue=TextEditingController(text: '${snap.data[i]['AccountId']['Email']}');
                                              passwordValue=TextEditingController(text: '${snap.data[i]['AccountId']['Password']}');

                                              return AlertDialog(
                                                title: Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("Edit teacher",
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
                                                  child: Form(
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:NameValue,
                                                          decoration: InputDecoration(
                                                              hintText: "Teacher name",
                                                              border: OutlineInputBorder()),
                                                        ),
                                                        SizedBox(height: 16,),

                                                        DropdownButtonFormField<String>(
                                                          value: AcademicLevelValue,
                                                          hint:Text('select the the academic level'),
                                                          onChanged: (newValue) {
                                                            AcademicLevelValue = newValue!;
                                                            (context as Element).markNeedsBuild();
                                                          },
                                                          items: {
                                                            "Doctorate",
                                                            "master's",
                                                            "Bachelor's"

                                                          }.map<DropdownMenuItem<String>>((value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text('${value}'),
                                                            );
                                                          }).toList(),
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
                                                                    deptValue = newValue!;
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
                                                                return Text("No data");
                                                              }
                                                            }
                                                        ),
                                                        SizedBox(height: 16,),


                                                        TextFormField(
                                                          validator: (value){
                                                            validEmailInput(value!);
                                                          },
                                                          controller: emailValue,
                                                          decoration: InputDecoration(
                                                              hintText: "Email",
                                                              border: OutlineInputBorder()),
                                                        ),
                                                        SizedBox(height: 16,),
                                                        TextFormField(
                                                          validator: (value){
                                                            validatePassword(value!);
                                                          },
                                                          controller: passwordValue,
                                                          decoration: InputDecoration(
                                                              hintText: "Password",
                                                              border: OutlineInputBorder()),
                                                        ),
                                                      ],
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

                                                  // Edit Button
                                                  ElevatedButton(
                                                    onPressed: ()async {
                                                      await putData();
                                                    },
                                                    child: Text("Edit", style:TextStyle(color: TColors.lightGray) ),
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: TColors.darkBlue),
                                                  ),
                                                ],
                                                actionsPadding:
                                                EdgeInsets.only(
                                                    right: 32,
                                                    bottom: 32),
                                              );
                                            });
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
                                        : (index == 3) ?
                                    Padding( padding: const EdgeInsets.all(10),
                                      child: Text( "${snap.data![i]['AccountId']['Email']}" + "  "),
                                    ) : (index == 4) ?
                                    Padding( padding: const EdgeInsets.all(10),
                                      child: Text( "${snap.data![i]['AccountId']['Password']}" + "  "),
                                    )  : Text("")))),
                        ],
                      ),
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

          // Add Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                onPressed: () {
                  id;
                  NameValue=TextEditingController();
                  AcademicLevelValue;
                  deptValue;
                  accountValue;
                  emailValue=TextEditingController();
                  passwordValue=TextEditingController();

                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Add new teacher",
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
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller:NameValue,
                                    decoration: InputDecoration(
                                        hintText: "Teacher name",
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: 16,),

                                  DropdownButtonFormField<String>(
                                    value: AcademicLevelValue,
                                    hint:Text('select the the academic level'),
                                    onChanged: (newValue) {
                                      AcademicLevelValue = newValue!;
                                      (context as Element).markNeedsBuild();
                                    },
                                    items: {
                                      "Doctorate",
                                      "master's",
                                      "Bachelor's"
                                    }.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text('${value}'),
                                      );
                                    }).toList(),
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
                                              deptValue = newValue!;
                                              selectedDept=true;
                                              setState(() {
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

                                  TextFormField(
                                    validator: (value){
                                      validEmailInput(value!);
                                    },
                                    controller: emailValue,
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: 16,),
                                  TextFormField(
                                    validator: (value){
                                      validatePassword(value!);
                                    },
                                    controller: passwordValue,
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        border: OutlineInputBorder()),
                                  ),
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
                              style: OutlinedButton.styleFrom(side: BorderSide(color: TColors.darkBlue, width: 1)),
                            ),

                            // Save Button
                            ElevatedButton(
                              onPressed: () async{
                                await AddData();
                              },
                              child: Text("Save", style:TextStyle(color: TColors.lightGray) ,),
                              style: ElevatedButton.styleFrom(backgroundColor: TColors.darkBlue,),
                            ),
                          ],
                          actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
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
