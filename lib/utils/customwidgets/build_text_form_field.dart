// TextFormField(
//                     decoration: InputDecoration(
//                         floatingLabelStyle: floatingLabelTextStyle(),
//                         focusedBorder: customFocusBorder(),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide:
//                                 BorderSide(color: primaryColor, width: 2)),
//                         labelStyle: TextStyle(color: greyColor, fontSize: 13),
//                         hintText: 'Email Address'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the email address';
//                       }
//                       return null;
//                     },
//                     controller: _emailController,
//                   ),

                  import 'package:flutter/material.dart';
import 'package:nepstyle_management_system/pages/Home/customers.dart';

import '../../constants/color/color.dart';

 _buildTextFormField(TextEditingController controller, String hint,){
  return 
  TextFormField(
                    decoration: InputDecoration(
                        floatingLabelStyle: floatingLabelTextStyle(),
                        focusedBorder: customFocusBorder(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: primaryColor, width: 2)),
                        labelStyle: TextStyle(color: greyColor, fontSize: 13),
                        labelText: hint,
                        hintText: hint),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the  ${hint}';
                      }
                      return null;
                    },
                    controller: controller,
                  );

}