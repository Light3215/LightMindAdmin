import 'package:flutter/material.dart';
import 'package:iiestadmin/components/extraSub/extraSubject.dart';
import 'package:iiestadmin/components/subjectcomp.dart';

class extra extends StatefulWidget {
  const extra({Key? key}) : super(key: key);

  @override
  State<extra> createState() => _extraState();
}

class _extraState extends State<extra> {
  var lists = [
    "Mechanics",
    "Basic Electrical Engineering",
    "Chemistry",
    "Mathematics I",
    "Mathematics II",
    "English",
    "Computer Science",
    "Environment and Ecology",
    "Sociology and Professional Ethics",
    "Physics"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: appbarName("Extra", context),
          body: Container(
            padding: const EdgeInsets.all(2),
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              for (var item in lists)
                subparts(item, context,
                    extraSubject(type: "Extra", subjectName: item)),
            ]),
          ),
          // not clear either - assignment or Theory
        ));
  }
}
