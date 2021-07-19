import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:inventam_flutter_task/Transition/Scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

const kPrimaryColor = Color(0xff821D67);
const kPrimaryLightColor = Color(0xFFC7A98F);

const kScafolfColor = Color(0xFFFFE9EB);

const kSecondaryColor = Color(0xFFE4C1A1);
const klightbackground = Color.fromRGBO(243, 245, 248, 1);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);

const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

const kTextFieldFill = Color(0xff1E1C24);
// TextStyles
const kHeadline = TextStyle(
  color: kPrimaryColor,
  fontSize: 34,
  fontWeight: FontWeight.bold,
);

const kHeadline1 = TextStyle(
  color: kPrimaryColor,
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

const kBodyText = TextStyle(
  color: Colors.grey,
  fontSize: 15,
);

const kButtonText = TextStyle(
  color: Colors.black87,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const kBodyText2 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w500, color: kPrimaryLightColor);

const kBodyText3 = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w500, color: kPrimaryLightColor);

const kBodyText4 =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: kPrimaryColor);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.4,
);

final headingStyle1 = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1,
);

const defaultDuration = Duration(milliseconds: 250);

//login
const String txtEmail = "Please Enter Email";
const String txtEmailValid = "Please Enter Valid Email";
const String txtPassword = "Please Enter Password";
const String txtPasswordRange = "Please Enter Minimum 6 Digit Password";

//task
const String txtTaskName = "Please Enter Task Name";
const String txtTaskDescription = "Please Task Description";
const String txtTaskStartDate = "Please Enter Task Start Date";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

const kLocalKey = {"task": "task"};

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class setting {
  Future<dynamic> sky(BuildContext con, pag) {
    Navigator.push(con, ScaleRoute(page: pag));
  }

  Future<dynamic> skys(pag) {
    Navigator.push(Get.context, ScaleRoute(page: pag))
        .then((value) => keyboard(Get.context));
  }

  String getCurrantDateTime() {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();
    return formattedDateTime;
  }

  tostMessage(String message) {
    Fluttertoast.showToast(
        msg: "${message.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showInSnackBar(String value, BuildContext tostcontext, _scaffoldKey) {
    // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    FocusScope.of(Get.context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      margin: EdgeInsets.only(bottom: 100),
      behavior: SnackBarBehavior.floating,
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: kPrimaryLightColor,
      duration: Duration(seconds: 3),
    ));
  }

  void loading(BuildContext contextz) {
    Get.dialog(Container(
      margin: EdgeInsets.only(
          bottom: (MediaQuery.of(Get.context).size.height / 2) - 50,
          top: (MediaQuery.of(Get.context).size.height / 2) - 50,
          left: (MediaQuery.of(Get.context).size.width / 2) - 50,
          right: (MediaQuery.of(Get.context).size.width / 2) - 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: SpinKitPouringHourglass(
        //color: Colors.black,
        color: Theme.of(Get.overlayContext).primaryColor,
        size: 50.0,
      ),
    ));
  }

  setStatusBar(Color colo) async {
    // change the status bar color to material color [green-400]
    await FlutterStatusbarcolor.setStatusBarColor(colo);
    if (useWhiteForeground(colo)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

// change the navigation bar color to material color [orange-200]
    await FlutterStatusbarcolor.setNavigationBarColor(colo);

    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);

// get statusbar color and navigationbar color
    Color statusbarColor = await FlutterStatusbarcolor.getStatusBarColor();
    Color navigationbarColor =
        await FlutterStatusbarcolor.getNavigationBarColor();
  }

  void keyboard(BuildContext keCon) {
    FocusScopeNode currentFocus = FocusScope.of(keCon);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
