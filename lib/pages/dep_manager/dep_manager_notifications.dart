import 'package:flutter/material.dart';
import 'package:timetable_admin/Business%20Logic/components/info.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:intl/intl.dart';

import '../../main.dart';



class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {

  String contentNotifications =
      "Registration will close at 10:00 pm today. We will only accept registered students for the symposium and inform them of their name to apologize for not attending the lectures.";

  var dmId = sharedPref.getString("dm_id");
  Info _info = Info();
  Future getData() async {
      var response = await _info.getRequest("${serverLink}/DM_notification/$dmId");
      if (response!='failed') {
        List resBody = response;
        return resBody;
      }
  }
  bool newNotification = false;
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 8),
          padding: EdgeInsets.only(top: 8, left: 30, right: 30, bottom: 10),
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: TColors.darkBlue,
                    indicatorWeight: 4,
                    indicatorPadding: EdgeInsets.only(bottom: 8),
                    labelColor: TColors.darkBlue,
                    unselectedLabelColor: TColors.darkBlue,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: "Notifications",),
                    ]),
              ),
              Container(
                  width: double.maxFinite,
                  height: 430,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FutureBuilder(
                          future: getData(),
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.waiting)
                            {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snap.connectionState == ConnectionState.done)
                            {
                              if (snap.hasError)
                              {
                                return Center(child: Text("${snap.error}"));
                              }
                              if (snap.hasData && snap.data!=[])
                              {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: ListView.builder(
                                      itemCount: snap.data!.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 14),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top:
                                              BorderSide(width: 0.5, color: TColors.darkGray),
                                              bottom:
                                              BorderSide(width: 0.5, color: TColors.darkGray),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [


                                                  Text(
                                          "${DateFormat('yy-MM-dd HH:mm').format(DateTime.parse(snap.data[i]['date']))}",
                                                    style: TextStyle(color: TColors.darkGray),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "${snap.data[i]['Content']}",
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  if(newNotification)
                                                    Container(
                                                      margin: EdgeInsets.only(top: 10, right: 10),
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: TColors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                );
                              }
                              else
                              {
                                return Text("there is no new notifications");
                              }
                            }
                            return Text("");
                          }),
                    ],
                  )
              ),
            ],
          ),
        ),],
    );
  }
}

