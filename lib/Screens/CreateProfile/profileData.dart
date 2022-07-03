import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  const ProfileData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget profileData() {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('images').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.docs.length != 0
                  ? ProfileTile(
                      imageUrl: snapshot.data.docs[0]['imgUrl'],
                      name: snapshot.data.docs[0]['name'],
                      about: snapshot.data.docs[0]['about'],
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "No Image found!",
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
            } else {
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          });
    }

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
        body: Container(
          child: profileData(),
        ));
  }
}

class ProfileTile extends StatelessWidget {
  final String imageUrl;
  String name, about;

  ProfileTile({
    required this.imageUrl,
    required this.name,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        height: size.height,
        width: double.infinity,
        child: Form(
            child: Column(
          children: [
            SizedBox(
              height: size.height * 0.08,
            ),
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.6), width: 2),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
              // child: Image.network(
              //   imageUrl,
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              height: 120,
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.black.withOpacity(0.7), width: 3),
              ),
              child: Center(
                child: Text(
                  about,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        )));
  }
}
