import 'package:flutter/material.dart';
import 'package:mmet_me_fit/Screens/CreateProfile/body.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MeetMeFit",
          style: TextStyle(
            fontSize: 28,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
