// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepstyle_management_system/pages/login%20&%20signup/login.dart';

import '../../Logic/Bloc/signupBloc/signup_bloc.dart';
import '../../constants/color/color.dart';
import '../../constants/size/size.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();
TextEditingController nameController = TextEditingController();

TextEditingController shopNameController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController phoneController = TextEditingController();

bool _showPassword = false;
bool _isRememberMe = false;
bool loginError = true;
bool agreeTerms = false;

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return signupwidget(context, AppSize(context: context));
  }

  signupwidget(BuildContext context, size) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupLoadedState) {
          Fluttertoast.showToast(
              msg: "Account Created Successfully",
              gravity: ToastGravity.BOTTOM_RIGHT,
              backgroundColor: successColor);
          Get.offAll(() => Login());
        }
        if (state is SignupErrorState) {
          Fluttertoast.showToast(
              msg: "Something went wrong",
              gravity: ToastGravity.BOTTOM_RIGHT,
              backgroundColor: errorColor);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/icons/logo.png'),
          backgroundColor: primaryColor,
        ),
        backgroundColor: pageColor,
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: Get.height * 0.75,
              width: Get.width * 0.40,
              decoration: BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          // width: Get.width * 0.2,
                          child: Text(
                            "Clothing Store Management System",
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: myBlack,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: dreamGrey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 15),
                        child: Form(
                            key: formKey,
                            child: Container(
                              width: Get.width * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.025,
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        if (value.length < 10) {
                                          return 'Please enter valid name';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          floatingLabelStyle:
                                              floatingLabelTextStyle(),
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: greyColor,
                                          ),
                                          focusedBorder: customFocusBorder(),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 2)),
                                          labelText: "Your Name",
                                          labelStyle: TextStyle(
                                              color: greyColor, fontSize: 13),
                                          hintText: 'Your Name'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.015,
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: shopNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your shop name';
                                        }

                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          floatingLabelStyle:
                                              floatingLabelTextStyle(),
                                          prefixIcon: Icon(
                                            Icons.shop,
                                            color: greyColor,
                                          ),
                                          focusedBorder: customFocusBorder(),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 2)),
                                          labelText: "Shop Name",
                                          labelStyle: TextStyle(
                                              color: greyColor, fontSize: 13),
                                          hintText: 'Shop Name'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.015,
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: addressController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your shop address';
                                        }

                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          floatingLabelStyle:
                                              floatingLabelTextStyle(),
                                          prefixIcon: Icon(
                                            Icons.location_on,
                                            color: greyColor,
                                          ),
                                          focusedBorder: customFocusBorder(),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 2)),
                                          labelText: "Address",
                                          labelStyle: TextStyle(
                                              color: greyColor, fontSize: 13),
                                          hintText: 'Address'),
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.015),
                                  Container(
                                    width: Get.width * 0.2,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: phoneController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your PhoneNumber';
                                        }
                                        if (value.length < 10) {
                                          return 'Please enter Valid phone number';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          floatingLabelStyle:
                                              floatingLabelTextStyle(),
                                          prefixIcon: Icon(
                                            Icons.call,
                                            color: greyColor,
                                          ),
                                          focusedBorder: customFocusBorder(),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 2)),
                                          labelText: "Phone Number",
                                          labelStyle: TextStyle(
                                              color: greyColor, fontSize: 13),
                                          hintText: 'Phone Numberg'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.015,
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your Email';
                                        }
                                        if (value.length < 10) {
                                          return 'Please enter valid Email';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          floatingLabelStyle:
                                              floatingLabelTextStyle(),
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: greyColor,
                                          ),
                                          focusedBorder: customFocusBorder(),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 2)),
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                              color: greyColor, fontSize: 13),
                                          hintText: 'Email'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.015,
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: passController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.go,
                                      obscureText: !_showPassword,
                                      decoration: InputDecoration(
                                          floatingLabelStyle: TextStyle(
                                              color: primaryColor,
                                              fontSize: 13),
                                          focusedBorder: customFocusBorder(),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 2)),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: greyColor,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                            icon: (_showPassword)
                                                ? Icon(
                                                    Icons.visibility,
                                                    color: greyColor,
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: greyColor,
                                                  ),
                                          ),
                                          labelText: "Password",
                                          labelStyle: GoogleFonts.inter(
                                              color: greyColor, fontSize: 13),
                                          hintText: 'Password'),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            if (state is SignupLoadingState) {
                              return const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CupertinoActivityIndicator());
                            }
                            return SizedBox(
                              height: 45,
                              width: 250,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                                // height: 50,
                                color: primaryColor,
                                onPressed: signup,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SignUp',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: whiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: Get.height * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already Have an account? "),
                          GestureDetector(
                            onTap: () {
                              Get.off(() => Login());
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: greyDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signup() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<SignupBloc>(context).add(SignupAddButtonTappedEvent(
          id: DateTime.now().toString(),
          email: emailController.text.trim(),
          name: nameController.text.trim(),
          address: addressController.text.trim(),
          phone: phoneController.text.trim(),
          shopName: shopNameController.text.trim(),
          shopAddress: addressController.text.trim(),
          password: passController.text.trim()));
    }
  }
}
