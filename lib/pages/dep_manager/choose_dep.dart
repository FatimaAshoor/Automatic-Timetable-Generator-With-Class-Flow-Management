import 'package:flutter/material.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/Business%20Logic/components/info.dart';


import '../../main.dart';

class ChooseDep extends StatelessWidget {
  ChooseDep({super.key});
  Info _info = Info();
  String? dmId ;
  Future getTB() async{
    var response = await _info.getRequest("${serverLink}/get_timetable/$dmId");

    await sharedPref.setBool("created_timetable",response['bool']);
    return [];

  }

  @override
  Widget build(BuildContext context) {
    String? depManagerName = sharedPref.getString("dm_teacher");




    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: TColors.darkBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 554,
              height: 301,
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome " + "$depManagerName" + " !",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: TColors.black,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "You manage more than one of departments.\nSelect which department you want to enter to it.",
                    style: TextStyle(
                      color: TColors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 18,),
                  Container(
                    width: 178,
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sharedPref.getInt("dm_counter")!,
                        itemBuilder: (context, i){
                          var id =  sharedPref.getString('dm_id$i');
                          var name = sharedPref.getString('dm_name$i');
                          var period = sharedPref.getString('period$i');
                          return Container(
                            padding: EdgeInsets.only(right: 10),
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                await sharedPref.setString('dm_id', id! );
                                await sharedPref.setString('period', period! );
                                await sharedPref.setString("dm_name", name! );
                                dmId=await sharedPref.getString('dm_id');
                                await getTB();
                                Navigator.of(context).pushReplacementNamed("depManagerMainPage");
                              },
                              child: Text("${name}",style: TextStyle(color: TColors.white,fontSize: 16),),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.darkBlue,
                                  textStyle: TextStyle(color: TColors.white)),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
