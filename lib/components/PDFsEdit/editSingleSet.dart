// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iiestadmin/components/loginComp.dart';
import 'package:iiestadmin/components/subjectcomp.dart';
import 'package:iiestadmin/model/pdfData.dart';
import 'package:iiestadmin/utils/constants.dart';

class editSingleSet extends StatefulWidget {
  final String subject;
  final String type;
  final String chapter;
  final snap;
  editSingleSet(
      {super.key,
      required this.subject,
      required this.snap,
      required this.chapter,
      required this.type});

  @override
  State<editSingleSet> createState() => _editSingleSetState();
}

class _editSingleSetState extends State<editSingleSet> {
  get type => widget.type;
  get subject => widget.subject;
  get chapter => widget.chapter;
  get snap => widget.snap;
  bool isloading = false;

  @override
  void initState() {
    DescController.text = snap["desc"];
    LinkController.text = snap["link"];
    // TODO: implement initState
    super.initState();
  }

  TextEditingController DescController = TextEditingController();
  TextEditingController LinkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appbarName("Edit Single set", context),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenheight(context) * 0.03,
              horizontal: screenwidth(context) * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Enter PDF data",
                style: TextStyle(fontSize: 27),
              ),
              SizedBox(
                height: screenheight(context) * 0.02,
              ),
              TextFormField(
                controller: DescController,
                decoration:
                    const InputDecoration(labelText: 'Enter description'),
              ),
              TextFormField(
                controller: LinkController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        openPDF(driveLink());
                      },
                      icon: const Icon(Icons.upload_file_outlined),
                    ),
                    labelText: 'Enter link'),
              ),
              SizedBox(
                height: screenheight(context) * 0.53,
              ),
              Material(
                child: Ink(
                  height: screenheight(context) * 0.07,
                  width: screenwidth(context) * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.amber,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    splashColor: Colors.yellow[800],
                    onTap: () {
                      PdfData.editPDFs(snap, type, subject, chapter,
                          DescController.text, LinkController.text, "", "");
                      Navigator.pop(context);
                    },
                    child: isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add),
                              Center(child: Text("Edit")),
                            ],
                          ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
