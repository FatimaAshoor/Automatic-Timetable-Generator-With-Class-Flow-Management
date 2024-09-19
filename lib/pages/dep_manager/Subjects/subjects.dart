import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_main.dart';
import '../../../constant/t_colors.dart';
import '../../../main.dart';
import '../../../widgets/three_actions.dart';

class Subject extends StatefulWidget {
  const Subject({super.key});

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController NameValue = TextEditingController();
  TextEditingController THoursValue = TextEditingController();
  bool? hasLabValue = false ;
  TextEditingController labHoursValue = TextEditingController();
  int? id;
  var dmId = sharedPref.getString("dm_id");
  String? subName;
  String? subHours;

  String? newSubType = "0";
  String? updatedSubType;
  Info _info=Info();
  String? deptValue = sharedPref.getString("dm_id");

  Future getData() async {
    var response = await _info.getRequest("${serverLink}/dep_subject/${deptValue}");

    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }
  Future add_sem_subject() async {
    var response = await _info.postRequest("http://127.0.0.1:8000/API/semester_subject",{
      "SubjectId":"$id",
      "IsLab":"$hasLabValue",
    });
    if (response==true){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The subject is added'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          duration: Duration(seconds: 4), // Duration for how long the snack bar should be displayed
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The subject is already exists in semester subject'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          duration: Duration(seconds: 4), // Duration for how long the snack bar should be displayed
        ),
      );
    }
  }
  Future postData() async {
    var response = await _info.postRequest("http://127.0.0.1:8000/API/subject",{
      "Name":NameValue.text,
      "DepartmentId":dmId,
      "HasLab":"$hasLabValue",
      "TheoreticalHours":THoursValue.text,
      "LabHours":labHoursValue.text

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
    var response = await _info.putRequest("http://127.0.0.1:8000/API/subject/${id.toString()}",{
      "Name":NameValue.text,
      "DepartmentId": dmId,
      "HasLab":"$hasLabValue",
      "TheoreticalHours":THoursValue.text,
      "LabHours":labHoursValue.text

    });
    if (response==true){
      (context as Element).markNeedsBuild();
      Navigator.of(context).pop(); }
    else{
      Text("Error");
    }
  }
  Future deleteData() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/subject/${id.toString()}");
    if (response==true){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DepManagerMainPage(pageIndex:1)));
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
                              Text("Theoretical Hours", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("Lab Hours", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                margin: EdgeInsets.only(top: 50),
                                padding: EdgeInsets.only(top: 38 ),
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
                                                    id=snap.data[i]['id'];
                                                    await deleteData();
                                                  },


                                                  onClickUpdate: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          NameValue = TextEditingController(text:"${snap.data![i]['Name']}");
                                                          THoursValue = TextEditingController(text:"${snap.data![i]['TheoreticalHours']}");
                                                          hasLabValue=snap.data![i]['HasLab'] ;
                                                          labHoursValue = TextEditingController(text:"${snap.data![i]['LabHours']==null?'':snap.data![i]['LabHours']}");
                                                          id=snap.data![i]['id'] ;
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
                                                                        Text("Edit the subject",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: TColors.black),
                                                                        ),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              NameValue = TextEditingController();
                                                                              THoursValue = TextEditingController();
                                                                              hasLabValue=false ;
                                                                              labHoursValue = TextEditingController();

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
                                                                            controller: NameValue,
                                                                            decoration: InputDecoration(
                                                                                hintText: "Subject name",
                                                                                border: OutlineInputBorder()),
                                                                          ),
                                                                          SizedBox(height: 16,),
                                                                          SizedBox(height: 16,),
                                                                          TextFormField(
                                                                            controller: THoursValue,
                                                                            decoration: InputDecoration(
                                                                                hintText: "Teoritical Hours",
                                                                                border: OutlineInputBorder()),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text("has Lab:"),
                                                                              Checkbox(value: hasLabValue, onChanged: (val){
                                                                                (context as Element).markNeedsBuild();
                                                                                hasLabValue=val;
                                                                              }
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 16,),
                                                                          TextFormField(
                                                                            enabled: hasLabValue,
                                                                            controller: labHoursValue,
                                                                            decoration: InputDecoration(
                                                                                hintText: "Lab Hours",
                                                                                border: OutlineInputBorder()),
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    OutlinedButton(
                                                                      onPressed: () {
                                                                        NameValue = TextEditingController();
                                                                        THoursValue = TextEditingController();
                                                                        hasLabValue=false ;
                                                                        labHoursValue = TextEditingController();
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
                                                              }
                                                          );
                                                        });
                                                  },


                                                  onClickAdd: () async{
                                                    id=snap.data[i]['id'];
                                                    hasLabValue=snap.data![i]['HasLab'] ;
                                                    await add_sem_subject();

                                                    if (snap.data[i]['HasLab']){
                                                      hasLabValue=false;
                                                      await add_sem_subject();

                                                    }
                                                  },
                                                ))
                                                : TableCell(
                                                child: (index == 0) ?
                                                Padding(padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['Name']}" + "  "),
                                                )
                                                    : (index == 1) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "        ${snap.data![i]['TheoreticalHours']}" + "  "),
                                                )
                                                    : (index == 2) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "    ${snap.data![i]['LabHours']==null?'___':snap.data![i]['LabHours']}" + "  "),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom:0, right: 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          onPressed: () {
                            NameValue = TextEditingController();
                            THoursValue = TextEditingController();
                            hasLabValue = false ;
                            labHoursValue = TextEditingController();

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Add new subject",
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
                                        child:  Column(
                                          children: [
                                            TextFormField(
                                              controller: NameValue,
                                              decoration: InputDecoration(
                                                  hintText: "Subject name",
                                                  border: OutlineInputBorder()),
                                            ),
                                            SizedBox(height: 16,),

                                            TextFormField(
                                              controller: THoursValue,
                                              decoration: InputDecoration(
                                                  hintText: "Teoritical Hours",
                                                  border: OutlineInputBorder()),
                                            ),
                                            SizedBox(height: 16,),
                                            Row(
                                              children: [
                                                Text("has Lab:"),
                                                Checkbox(value: hasLabValue, onChanged: (val){
                                                  (context as Element).markNeedsBuild();
                                                  hasLabValue=val;
                                                }
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16,),
                                            TextFormField(
                                              enabled: hasLabValue,
                                              controller: labHoursValue,
                                              decoration: InputDecoration(
                                                  hintText: "Lab Hours",
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
                                        onPressed: () {
                                           postData();

                                        },
                                        child: Text("Save", style: TextStyle(color: TColors.white),),
                                        style: ElevatedButton.styleFrom(backgroundColor: TColors.darkBlue),
                                      ),
                                    ],
                                    actionsPadding:
                                        EdgeInsets.only(right: 32, bottom: 32),
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
