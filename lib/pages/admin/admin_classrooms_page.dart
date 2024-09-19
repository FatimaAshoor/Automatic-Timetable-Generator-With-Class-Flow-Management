import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import 'package:timetable_admin/pages/admin/admin_main.dart';
import 'package:timetable_admin/widgets/two_actions.dart';

import '../../main.dart';


class ClassroomsPage extends StatefulWidget {
  const ClassroomsPage({super.key});

  @override
  State<ClassroomsPage> createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {

  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController searchController = TextEditingController();

  List allData = [];
  List _filteredData = [];

  Info _info =Info();
  Future getData() async {
    var response = await _info.getRequest("http://127.0.0.1:8000/API/classroom");

    if (response!='failed') {
       allData = await response.map((item) => item).toList();
       _filteredData=allData;
       print(sharedPref.getString('role'));
        return response;
    } else {
      print("The request failed.");
    }
  }

  @override
  initState() {
    super.initState();
  }

  void _runFilter(String enteredKeyword) async{
    List results = [];
    if (enteredKeyword.isEmpty) {
      print('empty');
      results = allData;
    } else {
      results = await allData.where((element) =>
      (element["Name"].toLowerCase()).contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredData = results;
    });
  }


  TextEditingController classNameValue = TextEditingController();
  TextEditingController seatingCapacityValue = TextEditingController();
  TextEditingController classTypeValue = TextEditingController();
  int? id;
  String? selectedValue;


  bool isEditing = false;
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  getType() async {
    var response = await _info.getRequest("http://127.0.0.1:8000/API/classType");
    if (response!='failed') {
      var resBody =response;
      return resBody;
    }
    return [{'':''}] ;
  }

  Future postData() async {
    var response = await _info.postRequest("http://127.0.0.1:8000/API/classroom",{
      "Name":classNameValue.text,
      "seating_capacity":seatingCapacityValue.text,
      "ClassTypeId":classTypeValue.text
    });
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminMainPage(pageIndex:1)));
    }
    else{
      Text("${response.statusCode}");
    }
  }

  Future putData() async {
    var response = await _info.putRequest("http://127.0.0.1:8000/API/classroom/${id.toString()}",{
      "Name":classNameValue.text,
      "seating_capacity":seatingCapacityValue.text,
      "ClassTypeId":classTypeValue.text
    });
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminMainPage(pageIndex:1)));
    }
    else{
      Text("Error");
    }
  }

  Future deleteData() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/classroom/${id.toString()}");
    if (response==true){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminMainPage(pageIndex:1)));
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
                    controller: searchController,
                    onChanged: (value) => _runFilter(value),
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
                      Text("Classroom Name", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                      Text("no. Of Seets", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                      Text("Classroom Type", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                      Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
            ),
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
                      return _filteredData.isNotEmpty ? SingleChildScrollView(
                          child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: [
                                for (int i = 0; i < _filteredData.length; i++)
                                  TableRow(
                                      children: List.generate(4, (index) =>
                                      index==3?
                                      TableCell(child: TwoActions(
                                        onClickDelete: () async {
                                          id=snap.data![i]['id'];
                                          await deleteData();
                                        },
                                        //################################################## Update #############################################################3
                                        onClickUpdate: (){
                                          showDialog(context: context,
                                              builder: (BuildContext context) {
                                                classNameValue = TextEditingController(text: "${snap.data![i]['Name']}");
                                                seatingCapacityValue = TextEditingController(text:"${snap.data![i]['seating_capacity']}");
                                                classTypeValue = TextEditingController(text:"${snap.data![i]['ClassTypeId']['id']}");

                                                selectedValue= snap.data![i]['ClassTypeId']['id'].toString();
                                                id=snap.data![i]['id'];


                                                return Builder(
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Padding(
                                                          padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Update classroom", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                                                              IconButton(onPressed: (){
                                                                classNameValue = TextEditingController();
                                                                seatingCapacityValue = TextEditingController();
                                                                classTypeValue = TextEditingController();
                                                                selectedValue= null;
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

                                                                  controller: classNameValue,
                                                                  decoration: InputDecoration(
                                                                      hintText: "Classroom Name",
                                                                      border: OutlineInputBorder()),
                                                                ),
                                                                SizedBox(height: 16,),
                                                                TextFormField(
                                                                  controller: seatingCapacityValue,
                                                                  decoration: InputDecoration(
                                                                      hintText: "no. Of Seets",
                                                                      border: OutlineInputBorder()),
                                                                ),
                                                                SizedBox(height: 16,),
                                                                FutureBuilder<dynamic>(
                                                                    future:getType(),
                                                                    builder: (context,snp) {


                                                                      if (snp.hasData) {
                                                                        return DropdownButtonFormField<String>(
                                                                          value: selectedValue,
                                                                          onChanged: (newValue) {
                                                                            selectedValue = newValue!;
                                                                            classTypeValue.text=newValue;
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
                                                              classNameValue = TextEditingController(text:"");
                                                              seatingCapacityValue = TextEditingController(text: "");
                                                              classTypeValue = TextEditingController(text: "");
                                                              selectedValue= null;
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
                                                              await putData();
                                                            },
                                                            child: Text("Update", style: TextStyle(color: TColors.white),),
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
                                          );},)) :
                                      TableCell(
                                          child:   (index==0)?
                                          Padding(padding: const EdgeInsets.all(10),
                                            child: Text( "${_filteredData[i]['Name']}" + "  "),
                                          )
                                              : (index == 1) ?
                                          Padding( padding: const EdgeInsets.all(10),
                                            child: Text( "${_filteredData[i]['seating_capacity']}" + "  "),
                                          )
                                              : (index==2)?
                                          Padding( padding: const EdgeInsets.all(10),
                                            child: Text( "${_filteredData[i]['ClassTypeId']['Name']}" + "  "),
                                          )
                                              : Text(""))
                                      )
                                  )])
                      ) : Center(child: Text("${_filteredData}"));
                    }
                  }
                  return Center(child: Text("there is no data"));
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
                    classNameValue = TextEditingController();
                    seatingCapacityValue = TextEditingController();
                    classTypeValue = TextEditingController();
                    selectedValue= null;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Add new classroom", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
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
                                      controller: classNameValue,
                                      decoration: InputDecoration(
                                          hintText: "Classroom Name",
                                          border: OutlineInputBorder()),
                                      validator: (v){},

                                    ),
                                    SizedBox(height: 16,),
                                    TextField(
                                      controller: seatingCapacityValue,
                                      decoration: InputDecoration(
                                          hintText: "no. Of Seets",
                                          border: OutlineInputBorder()),
                                    ),
                                    SizedBox(height: 16,),
                                    FutureBuilder<dynamic>(
                                        future:getType(),
                                        builder: (context,snp) {
                                          if (snp.hasData) {
                                            return DropdownButtonFormField<String>(
                                              value: selectedValue,
                                              hint:Text('select a type'),
                                              onChanged: (newValue) {
                                                selectedValue = newValue!;
                                                classTypeValue.text=newValue;
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
                                child: Text("Save",style:TextStyle(color: Colors.white)),
                                onPressed:()async{await postData();},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.darkBlue,
                                    textStyle: TextStyle(color: Colors.white)
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


