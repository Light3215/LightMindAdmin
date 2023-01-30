import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

screenheight(context) {
  return MediaQuery.of(context).size.height;
}

screenwidth(context) {
  return MediaQuery.of(context).size.width;
}

String driveLink() {
  return "drive.google.com/drive/folders/1eRAXFAkSBEm98jqWMw0YiK_dkhMRW1PE";
}

String linkManipualtion(String texts) {
  if (texts.length >= 8) {
    return texts.substring(8);
  } else {
    return "";
  }
}
