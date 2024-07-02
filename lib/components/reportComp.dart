// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iiestadmin/components/subjectcomp.dart';
import 'package:iiestadmin/model/pdfData.dart';
import '../utils/constants.dart';

TextEditingController reportController = TextEditingController();

report(context, snap, username) {
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Report'),
            content: SizedBox(
              height: screenheight(context) * 0.15,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        "Please tell us about the problem you faced while using this PDF."),
                    TextFormField(
                      controller: reportController,
                    ),
                  ]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  reportController.text = "";
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // PdfData.reportPDF(
                  //     snap, username, reportController.text.trim());
                  reportController.text = "";
                  Navigator.pop(context);
                  done(context);
                },
                child: const Text("Report"),
              )
            ],
          )));
}

done(context) {
  return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Thank you"),
            content: const SizedBox(
                child: Text(
                    "Your issue has been registered successfully and will be rectified soon")),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Done"))
            ],
          )));
}

ReportList(context, snap) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.amber),
    margin: EdgeInsets.symmetric(
      vertical: screenheight(context) * 0.01,
      horizontal: screenwidth(context) * 0.03,
    ),
    padding: EdgeInsets.symmetric(
      vertical: screenheight(context) * 0.01,
      horizontal: screenwidth(context) * 0.03,
    ),
    // height: screenheight(context) * 0.15,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: screenwidth(context) * 0.75,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text("Pid: "),
              Text(
                snap['Pid'].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ]),
            Text("\n" + snap["type"]),
            Text(snap["subject"]),
            Text(snap["chapter"] + "\n" ?? "\n"),
            Column(
              children: [
                for (String item in snap["report"].keys)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Uid: "),
                          Text(
                            reportMap(
                              item.toString(),
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "-> " + snap["report"][item].toString(),
                      ),
                    ],
                  ),
              ],
            ),
          ]),
        ),
        Container(
            child: IconButton(
                onPressed: () {
                  areYouSureReport(context, snap);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )))
      ],
    ),
  );
}

reportMap(String snap) {
  print(snap);
  return snap.substring(1, snap.length - 1);
}
