import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

screenheight(context) {
  return MediaQuery.of(context).size.height;
}

screenwidth(context) {
  return MediaQuery.of(context).size.width;
}

String driveLink() {
  return "drive.google.com/drive/folders/1leEZpcp7ZA21p7zUctMiVV_KXJSJuNcZ";
}

String linkManipualtion(String texts) {
  return texts.substring(8);
}
