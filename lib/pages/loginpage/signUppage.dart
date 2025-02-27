// ignore_for_file: camel_case_types, non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iiestadmin/model/users.dart';
import 'package:iiestadmin/utils/constants.dart';
import 'package:iiestadmin/pages/loginpage/emailVerify.dart';
import 'package:iiestadmin/pages/loginpage/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/loginComp.dart';

GlobalKey<ScaffoldMessengerState> signUpscaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
var signUpShowSnack = signUpscaffoldMessengerKey.currentState;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  @override
  void initState() {
    rememberMeLogic();
    super.initState();
  }

  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    UsernameController.dispose();
    super.dispose();
  }

  TextEditingController EmailController = TextEditingController();
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  bool isloading = false;
  bool cond = true;
  var pref;
  void rememberMeLogic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var prefs = sharedPreferences;
    setState(() {
      pref = prefs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: signUpscaffoldMessengerKey,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Container(
              decoration: backgrdImage(),
              child: SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(),
                  titleHeader("Sign up", context),
                  //email box
                  Column(
                    children: [
                      //Email
                      Container(
                        padding: EdgeInsets.only(
                            left: screenwidth(context) * 0.08,
                            right: screenwidth(context) * 0.08),
                        child: TextFormField(
                          controller: UsernameController,
                          decoration: const InputDecoration(
                              labelText: 'Enter Username'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: screenwidth(context) * 0.08,
                            right: screenwidth(context) * 0.08),
                        child: TextFormField(
                            controller: EmailController,
                            decoration:
                                const InputDecoration(labelText: 'Enter Email'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) {
                              if (email != null &&
                                  !EmailValidator.validate(email)) {
                                return "Enter a valid email";
                              } else {
                                return null;
                              }
                            }),
                      ),
                      //Password
                      Container(
                        padding: EdgeInsets.only(
                            left: screenwidth(context) * 0.08,
                            right: screenwidth(context) * 0.08),
                        child: TextFormField(
                            controller: PasswordController,
                            obscureText: cond,
                            decoration: const InputDecoration(
                              labelText: 'Create Password',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (pword) {
                              if (pword != null && (pword.length) < 7) {
                                return "Enter minimum 8 characters";
                              } else {
                                return null;
                              }
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                right: screenwidth(context) * 0.05),
                            child: TextButton(
                              child: const Text("Show password"),
                              onPressed: (() => {
                                    setState(() => {cond = !cond})
                                  }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: screenwidth(context) * 0.08,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            YellowButton(const Text("Sign Up"), signUp,
                                Icons.person_add, context, isloading),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                    child: const Text(
                                      "Log In",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: (() => {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    loginpage()),
                                          ),
                                        })),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            )),
      ),
    );
  }

  Future<void> signUp() async {
    setState(() {
      isloading = true;
    });
    try {
      if (EmailController.text.isNotEmpty ||
          PasswordController.text.isNotEmpty) {
        UserCredential cred =
            (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: EmailController.text.trim(),
          password: PasswordController.text.trim(),
        ));
        pref.setString("admin Username", UsernameController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const emailVerify()),
        );
        users user1 = users(
          Username: UsernameController.text.trim(),
          Email: EmailController.text.trim(),
          Uid: cred.user!.uid,
          isVerified: FirebaseAuth.instance.currentUser!.emailVerified,
        );
        await _firestore
            .collection("adminUser")
            .doc(cred.user!.uid)
            .set(user1.toJson());
      }
    } on FirebaseAuthException catch (err) {
      showSnack(err.code);
      setState(() {
        isloading = false;
      });
    }
  }
}

void showSnack(String error) {
  if (error == "network-request-failed") {
    signUpShowSnack?.showSnackBar(snackbar("No internet"));
  } else if (error == "email-already-in-use") {
    signUpShowSnack?.showSnackBar(snackbar("Account already created"));
  } else {
    signUpShowSnack?.showSnackBar(snackbar("Enter valid email"));
  }
}
