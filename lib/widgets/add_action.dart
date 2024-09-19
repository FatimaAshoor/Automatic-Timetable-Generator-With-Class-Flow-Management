import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../constant/t_colors.dart';

class AddAction extends StatelessWidget {
  const AddAction({super.key, this.onClickAdd});

  final Function()? onClickAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: onClickAdd,
              icon: Icon(
                Symbols.add_rounded,
                color: TColors.black,
              )
          ),
        ],
      ),
    );
  }
}
