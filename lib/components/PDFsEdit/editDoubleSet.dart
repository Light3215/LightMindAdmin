import 'package:flutter/material.dart';
import 'package:iiestadmin/components/loginComp.dart';
import 'package:iiestadmin/components/subjectcomp.dart';
import 'package:iiestadmin/model/pdfData.dart';
import 'package:iiestadmin/utils/constants.dart';

class editDoubleSet extends StatefulWidget {
  final snap;
  final String subject;
  final String type;
  final String chapter;

  editDoubleSet(
      {required this.type,
      required this.subject,
      required this.snap,
      required this.chapter,
      super.key});

  @override
  State<editDoubleSet> createState() => _editDoubleSetState();
}

class _editDoubleSetState extends State<editDoubleSet> {
  get type => widget.type;
  get subject => widget.subject;
  get snap => widget.snap;
  get chapter => widget.chapter;
  bool isloading = false;

  @override
  void initState() {
    QuesDescController.text = snap["question desc"];
    AnsDescController.text = snap["answer desc"];
    QuesLinkController.text = snap["question link"];
    AnsLinkController.text = snap["answer link"];
    // TODO: implement initState
    super.initState();
  }

  TextEditingController QuesDescController = TextEditingController();
  TextEditingController AnsDescController = TextEditingController();
  TextEditingController QuesLinkController = TextEditingController();
  TextEditingController AnsLinkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appbarName("Edit double set", context),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenheight(context) * 0.03,
              horizontal: screenwidth(context) * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "Enter Question PDF data",
                    style: TextStyle(fontSize: 27),
                  ),
                  SizedBox(
                    height: screenheight(context) * 0.02,
                  ),
                  TextFormField(
                    controller: QuesDescController,
                    decoration: const InputDecoration(
                        labelText: 'Enter Question description'),
                  ),
                  TextFormField(
                    controller: QuesLinkController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            openPDF(driveLink());
                          },
                          icon: const Icon(Icons.upload_file_outlined),
                        ),
                        labelText: 'Enter Question link'),
                  ),
                ],
              ),
              SizedBox(
                height: screenheight(context) * 0.04,
              ),
              Column(
                children: [
                  const Text(
                    "Enter Answer PDF data",
                    style: TextStyle(fontSize: 27),
                  ),
                  SizedBox(
                    height: screenheight(context) * 0.02,
                  ),
                  TextFormField(
                    controller: AnsDescController,
                    decoration: const InputDecoration(
                        labelText: 'Enter Answer description'),
                  ),
                  TextFormField(
                    controller: AnsLinkController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            openPDF(driveLink());
                          },
                          icon: const Icon(Icons.upload_file_outlined),
                        ),
                        labelText: 'Enter Answer link'),
                  ),
                ],
              ),
              SizedBox(
                height: screenheight(context) * 0.3,
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
                      PdfData.editPDFs(
                          snap,
                          type,
                          subject,
                          chapter,
                          QuesDescController.text,
                          QuesLinkController.text,
                          AnsDescController.text,
                          AnsLinkController.text);
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
