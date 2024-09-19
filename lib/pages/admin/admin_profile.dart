import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/constant/t_colors.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {

  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController adminNameController = TextEditingController();
  TextEditingController adminEmailController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();

  String adminName = 'Ahmed Ali';
  String adminEmail = 'Ahmed@gmail.com';
  String adminPassword = '*********';

  bool isEditing = false;
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.darkBlue,
        title: Text("Admin Profile Page"),

      ),
      body: Stack(
        children:[
          Container(
          color: TColors.lightGray,
          child: isEditing ? EditProfile() : ShowProfile(),),
          isEditing ? SaveBtn() : EditBtn(),
        ]),
    );
  }


  // Edite Profile Content
  Widget EditProfile(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, top: 30),
            child: Row(
              children: [
                SizedBox(width: 20,),
                Icon(Symbols.manage_accounts_rounded),
                SizedBox(width: 10,),
                Text("Edit Admin Information",style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TColors.black, fontSize: 16), )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              color: TColors.darkGray,
            ),
          ),
          Form(
            key: formState,
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 350, top: 50, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text("Admin Name", style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColors.black),),
                  SizedBox(height: 6,),
                  TextFormField(
                    controller: adminNameController,

                    decoration: InputDecoration(
                        hintText: "Admin name",
                        border: OutlineInputBorder()),

                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter your name";
                      }
                    },
                  ),
                  SizedBox(height: 16,),

                  // Email
                  Text("Admin Email", style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColors.black), ),
                  SizedBox(height: 6,),
                  TextFormField(
                    controller: adminEmailController,

                    decoration: InputDecoration(
                        hintText: "Admin Email",
                        border: OutlineInputBorder()),

                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter your Email";
                      }
                    },

                  ),
                  SizedBox(height: 16,),


                  // Password
                  Text("Admin Password", style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColors.black), ),
                  SizedBox(height: 6,),
                  TextFormField(
                    controller: adminPasswordController,

                    decoration: InputDecoration(
                        hintText: "Admin password",
                        border: OutlineInputBorder()),

                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter your password";
                      }
                    },

                  ),
                  SizedBox(height: 16,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show Profile Content
  Widget ShowProfile(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, top: 30),
            child: Row(
              children: [
                SizedBox(width: 20,),
                Icon(Symbols.person_pin_rounded),
                SizedBox(width: 10,),
                Text("Admin Information",style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TColors.black, fontSize: 16), )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Divider(
              color: TColors.darkGray,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 50, right: 350, top: 30, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text("Admin Name", style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColors.black),),
                  SizedBox(height: 6,),
                  Text("$adminName"),
                  SizedBox(height: 16,),

                  // Email
                  Text("Admin Email", style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColors.black), ),
                  SizedBox(height: 6,),
                  Text("$adminEmail"),
                  SizedBox(height: 16,),


                  // Password
                  Text("Admin Password", style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColors.black), ),
                  SizedBox(height: 6,),
                  Text("$adminPassword"),
                  SizedBox(height: 16,),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Edit Button
  Widget EditBtn(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, right: 30),
      child: Align(
        alignment: Alignment.bottomRight,
        child: MaterialButton(
          onPressed: (){
            setState(() {
              toggleEditing();
            });
          },
          color: TColors.darkBlue,
          textColor: Colors.white,
          child: Icon(
            Symbols.edit_rounded,
            size: 24,
          ),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
      ),
    );
  }

  Widget SaveBtn(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, right: 30),
      child: Align(
        alignment: Alignment.bottomRight,
        child: MaterialButton(
          onPressed: (){
            setState(() {
              adminName = adminNameController.text;
              adminEmail = adminEmailController.text;
              adminPassword = adminPasswordController.text;
              toggleEditing();
            });
          },
          color: TColors.darkBlue,
          textColor: Colors.white,
          child: Icon(
            Symbols.check_rounded,
            size: 24,
          ),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
