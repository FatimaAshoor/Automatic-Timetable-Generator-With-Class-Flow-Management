import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/widgets/two_actions.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_main.dart';
import '../../../constant/t_colors.dart';
import '../../../main.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});
  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController groupNameValue = TextEditingController();
  String? groupSpecializationValue ;
  TextEditingController groupNoOfStudentsValue = TextEditingController();
  TextEditingController groupLevelValue = TextEditingController();
  int? id;
  int? levelId;
  Info _info =Info();
  String? DepValue = sharedPref.getString("dm_id");

  Future getData() async {
    var response = await _info.getRequest("${serverLink}/dep_groups/${DepValue}");
    if (response!='failed') {
      List resBody =response;
      print(resBody);
      return resBody;
    }}

  getSpec() async{
    var response = await _info.getRequest("${serverLink}/specialization/${levelId}");
    if (response!='failed') {
      List resBody =response;
      print(resBody);
      return resBody;
    }
    return null;
  }



  Future putData() async {
    var response = await _info.putRequest("${serverLink}/groups/${id.toString()}",{
      "Name":groupNameValue.text,
      "LevelId":"${levelId}",
      "SpecializationId":groupSpecializationValue==null?"1":groupSpecializationValue,
      "number_of_students":groupNoOfStudentsValue.text
    });
    if (response==true){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DepManagerMainPage(pageIndex:3,levelIndex: 1,)));
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
                              Text("Group Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text(" Level", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),

                              Text("Specialization", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                              Text("No. Of Students", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                            children: List.generate(5, (index) =>
                                            index == 4 ? TableCell(
                                                child: TwoActions(
                                                  onClickDelete: () {


                                                  },


                                                  onClickUpdate: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          groupNameValue = TextEditingController(text: "${snap.data![i]['Name']}");
                                                          groupSpecializationValue =snap.data![i]['SpecializationId']!=null?snap.data![i]['SpecializationId']['id']:null;
                                                          groupNoOfStudentsValue = TextEditingController(text:"${snap.data![i]['number_of_students']}");
                                                          groupLevelValue = TextEditingController(text:"${snap.data![i]['LevelId']['Name']}");
                                                          id=snap.data![i]['id'];
                                                          levelId=snap.data![i]['LevelId']['id'];
                                                          return AlertDialog(
                                                            title: Padding(
                                                              padding:
                                                              const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text("Edit the group",
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
                                                                child: SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      TextFormField(
                                                                        controller: groupNameValue,
                                                                        decoration: InputDecoration(
                                                                            hintText: "Group name",
                                                                            border: OutlineInputBorder()),
                                                                      ),
                                                                      SizedBox(height: 16,),
                                                                      TextFormField(
                                                                        controller: groupNoOfStudentsValue,
                                                                        decoration: InputDecoration(
                                                                            hintText: "No. of Students",
                                                                            border: OutlineInputBorder()),
                                                                      ),
                                                                      SizedBox(height: 16,),
                                                                      TextFormField(
                                                                        enabled: false,
                                                                        controller: groupLevelValue,
                                                                        decoration: InputDecoration(
                                                                            hintText: "Level",
                                                                            border: OutlineInputBorder()),
                                                                      ),
                                                                      SizedBox(height: 16,),
                                                                      FutureBuilder<dynamic>(
                                                                          future:getSpec(),
                                                                          builder: (context,snp) {
                                                                            if (snp.hasData) {
                                                                              if (snp.data.length>=1){
                                                                                return DropdownButtonFormField<String>(
                                                                                  value: groupSpecializationValue,
                                                                                  hint:Text('select the specialization'),
                                                                                  onChanged: (newValue) {
                                                                                    setState(() {
                                                                                      groupSpecializationValue = newValue;

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
                                                                                return Text("");

                                                                              }
                                                                            }
                                                                            else{
                                                                              return Text("");

                                                                            }

                                                                          }
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
                                                                onPressed: () {

                                                                  putData();
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
                                                  child: Text( "${snap.data![i]['LevelId']['Name']}" + "  "),
                                                )
                                                    : (index == 2) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['SpecializationId']!=null?snap.data![i]['SpecializationId']['Name']:'___'}" + "  "),
                                                ) : (index == 3) ?
                                                Padding( padding: const EdgeInsets.all(10),
                                                  child: Text( "${snap.data![i]['number_of_students']}" + "  "),
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

                  ],
                ),
              );
  }
}
