import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmet_me_fit/Screens/CreateProfile/profileData.dart';
import 'package:mmet_me_fit/Services/methods.dart';
import 'package:random_string/random_string.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //
  TextEditingController _name = TextEditingController();
  TextEditingController _about = TextEditingController();

  // pick a image from ImageSource
  File? selectedImage;
  final picker = ImagePicker();

  CrudMethods crudMethods = CrudMethods();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print("No Image selected");
      }
    });
  }

  // Upload Image and extra details on firebase

  Future<void> createProfile() async {
    if (selectedImage != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "Uploading......",
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
        ),
      );

      Reference FirebasetoRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = FirebasetoRef.putFile(selectedImage!);

      var imageUrl;
      await task.whenComplete(() async {
        try {
          imageUrl = await FirebasetoRef.getDownloadURL();
        } catch (e) {
          print("Error");
        }

        print(imageUrl);
      });

      Map<String, dynamic> blogData = {
        "imgUrl": imageUrl,
        "name": _name.text.trim(),
        "about": _about.text.trim(),
        "time": DateTime.now()
      };

      crudMethods.addData(blogData, _name.text).then((value) {
        Fluttertoast.showToast(msg: "Image Added");
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileData()));
        // Navigator.pop(context);
        // Navigator.pop(context);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 30),
              Expanded(
                child: Text("Image Required"),
              ),
            ],
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Okay",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // name field
    final nameField = TextFormField(
      autofocus: false,
      controller: _name,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password required";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        hintText: "Name",
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
                SizedBox(
                  height: size.height * 0.08,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      getImage();
                    });
                  },
                  child: selectedImage != null
                      ? Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.6),
                                  width: 2),
                              image: DecorationImage(
                                  image: FileImage(selectedImage!),
                                  fit: BoxFit.fill)),
                        )
                      : Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.6), width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                nameField,
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  height: 120,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black.withOpacity(0.7), width: 3),
                  ),
                  child: TextField(
                    controller: _about,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "About...",
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      createProfile();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.6),
                        width: 4,
                      ),
                    ),
                    child: Text(
                      "Create Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
