import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/widgets/two_actions.dart';
import 'dart:convert';
import 'package:timetable_admin/Business Logic/components/info.dart';

import '../../../constant/t_colors.dart';
import '../../../main.dart';

class Teachers extends StatefulWidget {
  const Teachers({super.key});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController NameValue = TextEditingController();
  String? AcademicLevelValue ;
  String? accountValue;
  TextEditingController ConstraintsValue = TextEditingController();
  TextEditingController emailValue = TextEditingController();
  TextEditingController passwordValue = TextEditingController();
 int? id;
  String? deptValue = sharedPref.getString("dm_id");


  Info _info=Info();


  Future getData() async {
    var response = await _info.getRequest("${serverLink}/dep_teachers/${deptValue}");

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
    var response = await _info.putRequest("http://127.0.0.1:8000/API/teacher/${id.toString()}",
        {
          "account":jsonEncode({"Email":emailValue.text,
            "Password":passwordValue.text,
            "roles":"${[1]}"}),
          "teacher":jsonEncode({"Name":NameValue.text,
          "AccountId":"${accountValue.toString()}",
            "Academic_Degree":"$AcademicLevelValue",
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
                              Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                                                    TextFormField(
                                                                      controller: emailValue,
                                                                      decoration: InputDecoration(
                                                                          hintText: "Email",
                                                                          border: OutlineInputBorder()),
                                                                    ),
                                                                    SizedBox(height: 16,),
                                                                    TextFormField(
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
                                ),
                              );
                            }
                          }
                          return Text("");
                        }),


                    // Add Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0, right: 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          onPressed: () {
                            NameValue=TextEditingController();
                            AcademicLevelValue=null;
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
                                            TextFormField(
                                              controller: emailValue,
                                              decoration: InputDecoration(
                                                  hintText: "Email",
                                                  border: OutlineInputBorder()),
                                            ),
                                            SizedBox(height: 16,),
                                            TextFormField(
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
                                        child: Text("Save"),
                                        style: ElevatedButton.styleFrom(backgroundColor: TColors.darkBlue, textStyle: TextStyle(color: TColors.lightGray)),
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
