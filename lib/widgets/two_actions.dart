import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../constant/t_colors.dart';

class TwoActions extends StatelessWidget {
  TwoActions({super.key, this.onClickDelete, this.onClickUpdate, this.teacherRequest});

  final void Function()? onClickDelete;
  final Function()? onClickUpdate;
  bool? teacherRequest= false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        teacherRequest==true?
        IconButton(
            onPressed: (){},
            icon: Icon(Symbols.check_rounded, color: TColors.green,))
            :
        IconButton(
            onPressed: () {
      showDialog(
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
                    CircleAvatar(child: Icon(Symbols.warning_rounded, color: TColors.red,), backgroundColor: Color.fromRGBO(255, 31, 31, 0.1),),
                    SizedBox(height: 22,),
                    Text("Are you sure?",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                    SizedBox(height: 11,),
                    Text("The item will be deleted.", style: TextStyle( color: TColors.darkGray), ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 38,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No", style: TextStyle(color: TColors.red),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: TColors.red, width: 1)),
                    ),
                  ),
                  SizedBox(width: 32,),
                  Container(
                    width: 120,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: onClickDelete,
                      child: Text("Yes", style: TextStyle(color: TColors.white),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.red,
                          textStyle: TextStyle(color: TColors.white)
                      ),
                    ),
                  ),
                ],
              )
            ],
            actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
          );
        },
      );
    },
            icon: Icon(
              Symbols.delete_rounded,
              color: TColors.red,
            )),

        teacherRequest==true?
        IconButton(
            onPressed: (){},
            icon: Icon(Symbols.close_rounded, color: TColors.red,))
            :
        IconButton(
            onPressed: onClickUpdate,
            icon: Icon(
              Symbols.edit_rounded,
              color: TColors.black,
            )),
      ],
    );
  }
}
