import 'package:inventam_flutter_task/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {Key key,
      @required this.hintText,
      @required this.inputType,
      @required this.inputController,
      @required this.suffix,
      @required this.prefix,
      this.textAction = TextInputAction.next,
      this.maxLine = 1})
      : super(key: key);
  final String hintText;
  final TextInputType inputType;
  final TextEditingController inputController;
  final int maxLine;
  final IconData suffix;
  final IconData prefix;
  final TextInputAction textAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        cursorColor: kPrimaryColor,
        onChanged: (val) {
          // debugPrint(val.length.toString());
        },
        onSubmitted: (String txt) {
          setting().keyboard(Get.context);
        },
        maxLines: maxLine,
        controller: inputController,
        style: kBodyText.copyWith(color: kPrimaryColor),
        keyboardType: inputType,
        textInputAction: textAction,
        // expands: false,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              prefix,
              color: kPrimaryColor,
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              suffix,
              color: kPrimaryColor,
            ),
          ),
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: kBodyText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
