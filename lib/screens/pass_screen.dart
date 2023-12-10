import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_sdk_demo/screens/dashboard_screen.dart';

class PassScreen extends StatefulWidget {
  const PassScreen({super.key});

  @override
  State<PassScreen> createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  late Stream<DocumentSnapshot> passDataStream;
  Map<String, dynamic>? passData;

  final TextStyle myStyle = TextStyle(fontSize: 15, color: Colors.black);

  List<Color> colors = [
    Color.fromARGB(255, 103, 180, 243),
    Color.fromARGB(255, 32, 201, 239)
  ];

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 69, 139, 251),
      Color.fromARGB(250, 78, 114, 245)
    ],
  ).createShader(Rect.fromLTWH(100.0, 50.0, 200.0, 70.0));

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    passDataStream =
        FirebaseFirestore.instance.collection('pass-info').doc(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: passDataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("Data not available"));
        }

        passData = snapshot.data!.data() as Map<String, dynamic>?;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Preview Pass',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24.0,
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  " Preview Your Pass ",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  " Thank You ! For Purchasing ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (passData?['amount'] <= 0)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Your Pass limit is exhausted, please buy a new pass.",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      height: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/user_profile.png"),
                            radius: 40,
                          ),
                          Text(
                            passData?['name'] ?? "",
                            style: myStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_pin),
                              Text(
                                " Rajkot ",
                                style: myStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " Gender ",
                                style: myStyle,
                              ),
                              Text(
                                passData?['gender'] ?? "",
                                style: myStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " Age : ",
                                style: myStyle,
                              ),
                              Text(
                                passData?['age'] ?? "",
                                style: myStyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " Purchase Date : ",
                                style: myStyle,
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(
                                    passData?['passPurchaseDate']?.toDate() ??
                                        DateTime.now()),
                                style: myStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " Expires At : ",
                                style: myStyle,
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(
                                    passData?['passExpiryDate']?.toDate() ??
                                        DateTime.now()),
                                style: myStyle,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => DashBoardScreen());
                  },
                  child: Text(
                    " Your Amount : ${passData?['amount'] ?? 0}",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
