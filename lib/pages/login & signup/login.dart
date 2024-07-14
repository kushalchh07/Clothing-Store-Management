// ignore_for_file: prefer_const_constructors, unnecessary_import, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepstyle_management_system/Logic/Bloc/LoginBloc/login_bloc.dart';
import 'package:nepstyle_management_system/pages/Home/mainlayout.dart';
import 'package:nepstyle_management_system/pages/login%20&%20signup/forgetpassword.dart';
import 'package:nepstyle_management_system/pages/login%20&%20signup/signup.dart';

import '../../constants/color/color.dart';
import '../../constants/size/size.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  bool _isRememberMe = false;
  bool loginError = true;
  bool agreeTerms = false;

  void toggleRememberMe() {
    setState(() {
      _isRememberMe = !_isRememberMe;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  // RegisterRepository registerRepository = RegisterRepository();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  login() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(LoginTappedEvent(
          email: emailController.text, password: passController.text));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = AppSize(context: context);
    return loginwidget(context, size);
  }

  loginwidget(BuildContext context, AppSize size) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Get.offAll(() => MainLayout());
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
              height: Get.height * 0.6,
              width: Get.width * 0.60,
              decoration: BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/login.png',
                            width: Get.width * 0.3,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Form(
                                key: formKey,
                                child: Container(
                                  width: Get.width * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Get.width * 0.2,
                                        child: Text(
                                          "Clothing Store Management System",
                                          style: GoogleFonts.inter(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w600,
                                            color: myBlack,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.045,
                                      ),
                                      Container(
                                        width: Get.width * 0.2,
                                        child: TextFormField(
                                          cursorColor: primaryColor,
                                          controller: emailController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your Email';
                                            }
                                            if (value.length < 10) {
                                              return 'Please enter valid Email';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              floatingLabelStyle:
                                                  floatingLabelTextStyle(),
                                              prefixIcon: Icon(
                                                Icons.email,
                                                color: greyColor,
                                              ),
                                              focusedBorder:
                                                  customFocusBorder(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: primaryColor,
                                                      width: 2)),
                                              labelText: "Email",
                                              labelStyle: TextStyle(
                                                  color: greyColor,
                                                  fontSize: 13),
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
                                            if (value == null ||
                                                value.isEmpty) {
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
                                              focusedBorder:
                                                  customFocusBorder(),
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
                                                    _showPassword =
                                                        !_showPassword;
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
                                                  color: greyColor,
                                                  fontSize: 13),
                                              hintText: 'Password'),
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.035),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _isRememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isRememberMe = !value!;
                                                  });
                                                  toggleRememberMe();
                                                },
                                              ),
                                              Text("Remember Me.",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 14,
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Forgetpassword()));
                                              },
                                              child: Text(
                                                'Forgot Password?',
                                                style: GoogleFonts.inter(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: myBlack,
                                                  // decoration: TextDecoration.underline,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child:
                                            BlocBuilder<LoginBloc, LoginState>(
                                          builder: (context, state) {
                                            if (state is LoginLoadingState) {
                                              return const SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child:
                                                      CupertinoActivityIndicator());
                                            }
                                            return SizedBox(
                                              height: 45,
                                              width: 250,
                                              child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35)),
                                                // height: 50,
                                                color: primaryColor,
                                                onPressed: login,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Login',
                                                      style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          color: whiteColor,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("New User? "),
                                          GestureDetector(
                                            onTap: () {
                                              Get.off(() => SignUp());
                                            },
                                            child: Text(
                                              "Register",
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
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
}

OutlineInputBorder customFocusBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: primaryColor, width: 2));
}

TextStyle floatingLabelTextStyle() {
  return TextStyle(color: primaryColor, fontSize: 13);
}
