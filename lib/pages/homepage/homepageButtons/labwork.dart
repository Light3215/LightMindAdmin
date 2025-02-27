import 'package:flutter/material.dart';
import 'package:iiestadmin/components/extraSub/extraSubject.dart';
import 'package:iiestadmin/components/subjectcomp.dart';

class Labwork extends StatefulWidget {
  const Labwork({Key? key}) : super(key: key);

  @override
  State<Labwork> createState() => _LabworkState();
}

class _LabworkState extends State<Labwork> {
  var lists = [
    "Basic Electrical Engineering",
    "Chemistry",
    "Computer Science",
    "Physics",
    "Engineering Drawing",
    "Workshop"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: appbarName("Lab work", context),
          body: Container(
            padding: const EdgeInsets.all(2),
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              for (var item in lists)
                subparts(item, context,
                    extraSubject(type: "Lab work", subjectName: item)),
            ]),
          ),
        ));
  }
}
