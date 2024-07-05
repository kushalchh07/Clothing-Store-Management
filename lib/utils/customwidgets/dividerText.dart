import 'package:flutter/material.dart';

import '../../constants/color/color.dart';

import '../../constants/size/size.dart';

dividerText({
  required dynamic context,
  required String dividerText,
  required String desc,

}) {
  AppSize size = AppSize(context: context);
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: ' $dividerText',
                  style: TextStyle(
                    color: myBlack,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.w500,
                    fontSize: size.boldText(),
                  ),
                ),
              ],
            ),
          ),
        )

      
      ],
    ),
  );
}
