import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iiestadmin/components/reportComp.dart';
import 'package:iiestadmin/components/subjectcomp.dart';
import 'package:iiestadmin/utils/constants.dart';

class PDFsReport extends StatefulWidget {
  const PDFsReport({super.key});

  @override
  State<PDFsReport> createState() => _PDFsReportState();
}

class _PDFsReportState extends State<PDFsReport> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> dataLoaded;
  Stream<QuerySnapshot<Map<String, dynamic>>> readData() =>
      FirebaseFirestore.instance.collection("report").snapshots();

  @override
  void initState() {
    var hello = readData();
    setState(() {
      dataLoaded = hello;
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: appbarName("Report list", context),
        body: StreamBuilder(
          stream: dataLoaded,
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Center(
                child: Text(" something went wrong"),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) =>
                      ReportList(context, snapshot.data!.docs[index].data()));
            }
          },
        ),
      ),
    );
  }
}
