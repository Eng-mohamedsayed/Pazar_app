import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pazar/shared/styles/colors.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (Route<dynamic> route) => false);

Widget defaultButton({
  final Function()? function,
  Color? background,
  String? text,
  Color? textColor,
  double textFontSize = 22.0,
  double width = double.infinity,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: background,
    ),
    child: MaterialButton(
      onPressed: function,
      child: Text(text!,
          style: TextStyle(color: textColor, fontSize: textFontSize)),
    ),
  );
}

Widget defaultTextField({
  TextEditingController? controller,
  IconData? suffixIcon,
  String? hintText,
  IconData? prefixIcon,
  Color? iconColor,
  required Color borderColor,
  FormFieldValidator? validate,
  TextInputType? type,
  bool isPassword = false,
  bool read = false,
  void onChange(String value)?,
  void onSubmit(String value)?,
  Function()? suffixPressed,
}) {
  return TextFormField(
    cursorColor: defaultColor,
    keyboardType: type,
    obscureText: isPassword,
    readOnly: read,
    onChanged: onChange,
    onFieldSubmitted: onSubmit,
    validator: validate,
    controller: controller,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintText: hintText,
      suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffixIcon,
            color: iconColor,
          )),
      prefixIcon: Icon(
        prefixIcon,
        color: iconColor,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: borderColor,
          width: 2.0,
        ),
      ),
    ),
  );
}

void showToast({@required String? text, @required ToastStates? states}) =>
    Fluttertoast.showToast(
        msg: text.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(states!),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
