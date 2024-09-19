import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/Business Logic/components/info.dart';
import '../../../constant/t_colors.dart';
import '../../../main.dart';


class TeacherNotes extends StatefulWidget {
  const TeacherNotes({super.key});

  @override
  State<TeacherNotes> createState() => _TeacherNotesState();
}

class _TeacherNotesState extends State<TeacherNotes> {

  Info _info=Info();
  String? DepValue = sharedPref.getString("dm_id");
  Future getData() async {
    var response = await _info.getRequest("${serverLink}/show_teacher_notes/${DepValue}");
    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: snap.data!.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: i % 2 == 0 ? TColors.white : TColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: Offset(
                                  1, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(
                                "${snap.data[i]['Title']}",
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ],
                            ),
                            Text("${snap.data[i]['Content']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,),
                          ],
                        ),
                      ),
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${snap.data[i]['Title']}", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                                        IconButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, icon: Icon(Symbols.close_rounded, color: TColors.black,))
                                      ],
                                    ),
                                  ),
                                  content: Text(
                                    "${snap.data[i]['Content']}",
                                  )
                              );
                            }
                        );
                      },
                    );
                  });
            }
          }
          return Center(child: Text("there is no notes"));
        });
  }
}
