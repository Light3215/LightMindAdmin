// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iiestadmin/components/PDFsEdit/editSingleSet.dart';
import 'package:iiestadmin/components/reportComp.dart';
import 'package:iiestadmin/model/pdfData.dart';
import 'package:iiestadmin/utils/constants.dart';
import '../subjectcomp.dart';

class singleSetCard extends StatefulWidget {
  final snap;

  const singleSetCard({
    Key? key,
    required this.snap,
  });

  @override
  State<singleSetCard> createState() => _singleSetCardState();
}

class _singleSetCardState extends State<singleSetCard> {
  // var likes = Icons.favorite_border;
  var bookmarks = Icons.bookmark_border;

  get snap => widget.snap;
  var username = FirebaseAuth.instance.currentUser?.uid;

  // likeSystem() {
  //   if (snap["liked user"].contains(username)) {
  //     likes = Icons.favorite_border;
  //   } else {
  //     likes = Icons.favorite;
  //   }
  //   PdfData.updateLikes(username!, snap);
  //   PdfData.updateBookmarkedLike(username!, snap);
  // }

  bookmarkSystem() {
    if (snap["bookmarked user"].contains(username)) {
      bookmarks = Icons.bookmark_border;
    } else {
      bookmarks = Icons.bookmark;
    }
    PdfData.updateBookmark(snap, username!);
  }

  @override
  void initState() {
    setState(() {
      // if (snap["liked user"].contains(username)) {
      //   likes = Icons.favorite;
      // } else {
      //   likes = Icons.favorite_border;
      // }
      if (snap["bookmarked user"].contains(username)) {
        bookmarks = Icons.bookmark;
      } else {
        bookmarks = Icons.bookmark_border;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: screenwidth(context) * 0.02,
            right: screenwidth(context) * 0.02,
            bottom: screenheight(context) * 0.01),
        margin: EdgeInsets.symmetric(
            horizontal: screenwidth(context) * 0.04,
            vertical: screenheight(context) * 0.013),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
                spreadRadius: 3,
                offset: Offset(2, 3))
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.amber,
              Colors.yellowAccent,
            ],
          ),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    Text(
                      "  ${snap["liked user"].length} likes",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Row(children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          bookmarkSystem();
                        });
                      },
                      icon: Icon(
                        bookmarks,
                        color: Colors.green,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          // edit button to be made here **
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => editSingleSet(
                                    type: snap["type"],
                                    subject: snap["subject"],
                                    chapter: snap["chapter"] ?? "",
                                    snap: snap)),
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          //delete system to be made here
                          areYouSure(context, snap);
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red)),
                  // IconButton(
                  //     onPressed: () {
                  //       report(context, snap, username);
                  //     },
                  //     icon: Icon(
                  //       Icons.report,
                  //       color: Colors.amber[800],
                  //     ))
                ]),
              ],
            ),
            Container(
              height: screenheight(context) * 0.13,
              width: screenwidth(context) * 0.85,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.blue,
                      Colors.lightBlue,
                    ],
                  ),
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue),
              child: GestureDetector(
                  child: Center(
                      child: Text(
                    snap["desc"],
                    textAlign: TextAlign.center,
                  )),
                  onTap: () {
                    openPDF(snap['link']);
                  }),
            )
          ],
        ));
  }
}
