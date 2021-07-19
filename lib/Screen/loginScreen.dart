import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:inventam_flutter_task/Widgets/myPassword.dart';
import 'package:inventam_flutter_task/Widgets/mytextField.dart';
import 'package:inventam_flutter_task/Widgets/textButton.dart';
import 'package:inventam_flutter_task/home.dart';
import 'package:inventam_flutter_task/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  bool isPasswordVisible = true;
  bool isSendOtp = false;
  bool isresendOtp = false;
  bool isremember = true;
  final _auth = FirebaseAuth.instance;

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    userController.text = "akash@gmail.com";
    passwordController.text = "123456";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back.",
                            style: kHeadline,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You've been missed!",
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 200, width: 200, child: FlutterLogo()),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Sign In / Sign Up :",
                            style: kBodyText4,
                          ),
                          MyTextField(
                            suffix: Icons.text_snippet,
                            prefix: Icons.mobile_friendly,
                            inputController: userController,
                            hintText: 'Email Id',
                            inputType: TextInputType.emailAddress,
                          ),
                          MyPasswordField(
                            inputController: passwordController,
                            isPasswordVisible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Sign Up',
                      onTap: () {
                        if (userController.text.isEmpty) {
                          setting().tostMessage(txtEmail);
                        } else if (!userController.text.isEmail) {
                          setting().tostMessage(txtEmailValid);
                        } else if (passwordController.text.isEmpty) {
                          setting().tostMessage(txtPassword);
                        } else if (passwordController.text.length < 6) {
                          setting().tostMessage(txtPasswordRange);
                        } else {
                          signUp();
                        }
                      },
                      bgColor: kPrimaryColor,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Sign In',
                      onTap: () {
                        if (userController.text.isEmpty) {
                          setting().tostMessage(txtEmail);
                        } else if (!userController.text.isEmail) {
                          setting().tostMessage(txtEmailValid);
                        } else if (passwordController.text.isEmpty) {
                          setting().tostMessage(txtPassword);
                        } else if (passwordController.text.length < 6) {
                          setting().tostMessage(txtPasswordRange);
                        } else {
                          SignIn();
                        }
                      },
                      bgColor: kPrimaryColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async {
    setting().loading(Get.context);
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: userController.text.toString(),
          password: passwordController.text.toString());
      if (newUser != null) {
        Get.back();
        Get.offAll(HomeScreen());
      }
    } catch (e) {
      Get.back();
      setting().showInSnackBar(e.toString(), context, scaffoldKey);
    }
  }

  Future<void> SignIn() async {
    setting().loading(Get.context);
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: userController.text.toString(),
          password: passwordController.text.toString());
      if (user != null) {
        Get.back();
        Get.offAll(HomeScreen());
      }
    } catch (e) {
      Get.back();
      setting().showInSnackBar(e.toString(), context, scaffoldKey);
    }
  }
}
