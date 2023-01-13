// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iiestadmin/model/users.dart';
import 'package:iiestadmin/utils/constants.dart';
import 'package:iiestadmin/pages/homepage/homepagePart/homepage.dart';
import 'package:iiestadmin/components/loginComp.dart';
import 'package:iiestadmin/pages/loginpage/forgotPassword.dart';
import 'package:iiestadmin/pages/loginpage/signUppage.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldMessengerState> logInscaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  @override
  void initState() {
    rememberMeLogic();
    super.initState();
  }

  void rememberMeLogic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var prefs = sharedPreferences;
    setState(() {
      pref = prefs;
    });
  }

  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  late SharedPreferences pref;
  bool rememberMe = false;
  bool isloading = false;
  bool cond = true;
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScaffoldMessenger(
          key: logInscaffoldMessengerKey,
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
                    titleHeader("Log in", context),
                    //email box
                    Column(
                      children: [
                        //Email
                        Container(
                          padding: EdgeInsets.only(
                              left: screenwidth(context) * 0.08,
                              right: screenwidth(context) * 0.08),
                          child: TextFormField(
                              controller: EmailController,
                              decoration: const InputDecoration(
                                  labelText: 'Enter Email'),
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
                              obscureText: cond,
                              controller: PasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Enter Password',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (pword) {
                                if (pword != null && (pword.length) < 6) {
                                  return "Enter minimum 6 characters";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: (() => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const forgotPassword()),
                                    ),
                                  }),
                              child: const Text("Forgot password?"),
                            ),
                            TextButton(
                              onPressed: (() => {
                                    setState(() => {cond = !cond})
                                  }),
                              child: const Text("Show password"),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(right: screenwidth(context) * 0.08),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(
                                value: rememberMe,
                                onChanged: ((value) => setState(() {
                                      rememberMe = !rememberMe;
                                    }))),
                            const Text(
                              "Remember me",
                              style: TextStyle(fontSize: 16),
                            )
                          ]),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(right: screenwidth(context) * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          YellowButton(const Text("  Log in"), login,
                              Icons.login, context, isloading),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                  onPressed: (() => {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const signUpPage()),
                                        ),
                                      }),
                                  child: const Text(
                                    "Sign Up",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
              )),
        ),
      );

  Future login() async {
    setState(() {
      isloading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: EmailController.text.trim(),
        password: PasswordController.text.trim(),
      );
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        users.updateData("Is verified", true);
        if (rememberMe) {
          pref.setString("email", EmailController.text);
          pref.setString("password", PasswordController.text);
          pref.setBool("Remember me", rememberMe);
        }
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const homepage()),
        );
      } else {
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      showSnack(e.code);
      setState(() {
        isloading = false;
      });
    }
  }
}

void showSnack(String title) {
  if (title == "network-request-failed") {
    logInscaffoldMessengerKey.currentState
        ?.showSnackBar(snackbar("No internet"));
  } else if (title == "user-not-found") {
    logInscaffoldMessengerKey.currentState
        ?.showSnackBar(snackbar("Account does not exist"));
  } else if (title == "wrong-password") {
    logInscaffoldMessengerKey.currentState
        ?.showSnackBar(snackbar("Incorrect password"));
  } else {
    logInscaffoldMessengerKey.currentState
        ?.showSnackBar(snackbar("Enter valid email"));
  }
}
