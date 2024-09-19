import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/Business%20Logic/components/info.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:flutter/material.dart';
import 'package:timetable_admin/main.dart';

import '../Business Logic/components/valid.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailValue = TextEditingController();
  TextEditingController passwordValue = TextEditingController();
  String? dmId ;

  bool passwordToggle = true;
  Info _info = Info();
  Future getTB() async{
    var response = await _info.getRequest("${serverLink}/get_timetable/$dmId");

    await sharedPref.setBool("created_timetable",response['bool']);
    return [];

  }
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      var loginResponse = await _info.Login("http://127.0.0.1:8000/API/LogIn", {
        "Email": emailValue.text,
        "Password": passwordValue.text,
      });
      if(loginResponse == 'failed'){
        Text("${loginResponse.statusCode}");
      }
      else if(loginResponse == 'not_acceptable'){
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width:400,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                  child: Column(
                    children: [
                      CircleAvatar(child: Icon(Symbols.lock_rounded, color: TColors.darkBlue,size: 60,), backgroundColor: Color.fromRGBO(48, 57, 114, 0.1)),
                      SizedBox(height: 22,),
                      Text("Verify Your Password",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                      SizedBox(height: 11,),
                      Text("The password you entered are not corrected.", style: TextStyle( color: TColors.darkGray), ),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Container(
                    width: 200,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("OK", style: TextStyle(color: TColors.white),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.darkBlue,
                          textStyle: TextStyle(color: TColors.white)
                      ),
                    ),
                  ),
                ),
              ],
              actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
            );
          },
        );
      }
      else if(loginResponse == 'not_found'){
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width:400,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                  child: Column(
                    children: [
                      CircleAvatar(child: Icon(Symbols.warning_rounded, color: TColors.red, size: 60,), backgroundColor: Color.fromRGBO(255, 31, 31, 0.1),),
                      SizedBox(height: 22,),
                      Text("Verify Your Account",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                      SizedBox(height: 11,),
                      Text("The account you entered are not found.", style: TextStyle( color: TColors.darkGray), ),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Container(
                    width: 200,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("OK", style: TextStyle(color: TColors.white),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.red,
                          textStyle: TextStyle(color: TColors.white)
                      ),
                    ),
                  ),
                ),
              ],
              actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
            );
          },
        );
      }
      else {
          if (loginResponse['roles']?.contains("DM") && loginResponse['roles']?.contains("Teacher")) {

            if (loginResponse['DM'].length == 1) {
              await sharedPref.setString("dm_id", loginResponse['DM'][0]['DepartmentId']['Id'].toString());
             await sharedPref.setString("dm_name", loginResponse['DM'][0]['DepartmentId']['Name']);
              await sharedPref.setString('period', loginResponse['DM'][0]['DepartmentId']['period']);
              await sharedPref.setInt("dm_counter", loginResponse['DM'].length);
              await sharedPref.setString("dm_teacher", loginResponse['data']['Name']);
              dmId=await sharedPref.getString("dm_id");

              await getTB();
              Navigator.of(context).pushReplacementNamed("depManagerMainPage");
            }


            if (loginResponse['DM'].length > 1) {
              for (int i = 0; i < loginResponse['DM'].length; i++) {
                sharedPref.setString('period$i', loginResponse['DM'][i]['DepartmentId']['period']);
                sharedPref.setString('dm_id$i', loginResponse['DM'][i]['DepartmentId']['Id']);
                sharedPref.setString("dm_name$i", loginResponse['DM'][i]['DepartmentId']['Name']);
              }
              sharedPref.setString("dm_teacher", loginResponse['data']['Name']);
              sharedPref.setInt("dm_counter", loginResponse['DM'].length);
              sharedPref.setString('role', 'DM');
              Navigator.of(context).pushNamed("chooseDepPage");
            }
          }

          else if(loginResponse['roles']?.contains('Admin')){
            sharedPref.setString('role', 'Admin');
            Navigator.of(context).pushNamed("adminMainPage");
          }

          else if(loginResponse['roles']?.contains('Teacher')){
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    width:400,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                      child: Column(
                        children: [
                          CircleAvatar(child: Icon(Symbols.lock_rounded, color: TColors.darkBlue,size: 60,), backgroundColor: Color.fromRGBO(48, 57, 114, 0.1)),
                          SizedBox(height: 18,),
                          Text("You are a teacher",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                          SizedBox(height: 8,),
                          Text("you are not allowed to pass this system.", style: TextStyle( color: TColors.darkGray), ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Center(
                      child: Container(
                        width: 200,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("OK", style: TextStyle(color: TColors.white),),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.darkBlue,
                              textStyle: TextStyle(color: TColors.white)
                          ),
                        ),
                      ),
                    ),
                  ],
                  actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
                );
              },
            );
          }

          else if(loginResponse['roles']?.contains('Student')){
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    width:400,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                      child: Column(
                        children: [
                          CircleAvatar(child: Icon(Symbols.lock_rounded, color: TColors.darkBlue,size: 60,), backgroundColor: Color.fromRGBO(48, 57, 114, 0.1)),
                          SizedBox(height: 18,),
                          Text("You are a student",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                          SizedBox(height: 8,),
                          Text("you are not allowed to pass this system.", style: TextStyle( color: TColors.darkGray), ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Center(
                      child: Container(
                        width: 200,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("OK", style: TextStyle(color: TColors.white),),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.darkBlue,
                              textStyle: TextStyle(color: TColors.white)
                          ),
                        ),
                      ),
                    ),
                  ],
                  actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
                );
              },
            );
          }
          else {
            Text("${loginResponse.statusCode}");
          }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          color: TColors.darkBlue,
          width: width,
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: TColors.darkBlue,
                  child: Center(
                    child: Image.asset("images/WebSchedule.png", width: 250, height: 250,),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 60, left: 60),
                  height: height,
                  color: TColors.lightGray,
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: TColors.black,),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                validator: (value){

                                  _usernamePart(String email) {
                                    final localPartRegex = r'^[\w-]{1,15}$';
                                    return RegExp(localPartRegex).hasMatch(email.split('@').first);
                                  }

                                  _middlePart(String email) {
                                    final domainNameRegex = r'@hu\.(edu\.ye)$';
                                    return RegExp(domainNameRegex).hasMatch(email);
                                  }

                                  _lastPart(String email) {
                                    final tldRegex = r'\.ye$';
                                    return RegExp(tldRegex).hasMatch(email.split('@').last);
                                  }

                                  if (value!.isEmpty) {
                                    return "This field can't be empty";
                                  }
                                  if (!_usernamePart(value)) {
                                    return "username should contain only alphanumeric characters and '-'";
                                  }

                                  if (!_middlePart(value)) {
                                    return "after @ should write 'hu.edu'";
                                  }
                                  if (!_lastPart(value)) {
                                    return "last part of email should be '.ye'";
                                  }
                                  return null;
                                },
                                controller: emailValue,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                ),

                              ),
                              SizedBox(height: 15,),
                              TextFormField(
                                validator: (value){
                                  if (value!.isEmpty) {
                                    return "This field can't be empty";
                                  }
                                  else if (value.length < 8) {
                                    return "Password must be at least 8 characters long";
                                  }
                                  else if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                    return "Password must contain at least one letter";
                                  }
                                  else if (!RegExp(r'\d').hasMatch(value)) {
                                    return "Password must contain at least one number";
                                  }
                                  else if (!RegExp(r'[!#$%&? "]').hasMatch(value)) {
                                    return "Password must contain at least one special character (!#%&? \")";
                                  }
                                  return null;
                                },
                                controller: passwordValue,
                                decoration: InputDecoration(
                                  hintText: "password",
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordToggle? Symbols.visibility: Symbols.visibility_off, size: 20,),
                                    onPressed: (){
                                      setState(() {
                                        passwordToggle =! passwordToggle;
                                      });
                                    },
                                  )
                                ),
                                obscureText: passwordToggle,

                              ),
                              SizedBox(height: 50,),
                              MaterialButton(
                                onPressed: ()async{await login();},
                                color: TColors.darkBlue,
                                minWidth: 200,
                                height: 56,
                                child: Text("Login", style: TextStyle(fontSize: 16, color: TColors.white,),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
