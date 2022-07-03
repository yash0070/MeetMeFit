import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mmet_me_fit/Pages/LogIN/login_page.dart';
import 'package:mmet_me_fit/Screens/CreateProfile/create_profile.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email required";
        } else {
          return null;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // passwordField
    final passField = TextFormField(
      autofocus: false,
      controller: _password,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password required";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.remove_red_eye_sharp,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        hintText: "Password",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // confirm password field

    final confirmField = TextFormField(
      autofocus: false,
      controller: _confirm,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password required";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.remove_red_eye_sharp,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        hintText: "Confirm password",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      height: size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.1),
              Image(
                image: AssetImage("images/Image 1.png"),
                height: size.height * 0.13,
              ),
              SizedBox(
                height: size.height * 0.12,
              ),
              emailField,
              SizedBox(
                height: size.height * 0.05,
              ),
              passField,
              SizedBox(
                height: size.height * 0.05,
              ),
              confirmField,
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                height: 45,
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.6),
                    width: 4,
                  ),
                ),
                child: FlatButton(
                  child: Text(
                    "SignUp",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 65, 175, 203),
                                ),
                              ),
                              SizedBox(width: 18),
                              Text(
                                "Working....",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 65, 175, 203),
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                      var auth = FirebaseAuth.instance;
                      UserCredential user =
                          await auth.createUserWithEmailAndPassword(
                              email: _email.text, password: _password.text);
                      assert(user != null);
                      if (user != null) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Successfully created");

                        // FirebaseFirestore.instance
                        //     .collection('Users')
                        //     .add({"email": _email});
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateProfile()));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Email already taken");
                      } else if (e.code == 'invalid-email') {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "invalid Email");
                      } else if (e.code == 'weak-password') {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Passwor should be atleast 6 characters");
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ? ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInPage()));
                      });
                    },
                    child: Text(
                      "LogIn",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
