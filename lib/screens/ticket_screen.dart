import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:new_sdk_demo/screens/dashboard_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  var name = "";
  var email = "";
  var fromPlace = "";
  var toPlace = "";
  Timestamp purchaseDate = Timestamp.now();
  var userData;
  var ticketData;

  final TextStyle myStyle = TextStyle(
      fontSize: 15, color: Colors.black); // You can adjust the style as needed

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    checkTicketExpiryOnLoad();

    // Check ticket expiry every 1 minute
    const updateInterval = Duration(minutes: 1);
    Timer.periodic(updateInterval, (Timer timer) {
      if (mounted) {
        checkTicketExpiry();
      }
    });
  }

  Future<void> checkTicketExpiryOnLoad() async {
    if (isTicketExpired()) {
      await showExpiredTicketScreen();
    }
  }

  Future<void> checkTicketExpiry() async {
    if (isTicketExpired()) {
      await showExpiredTicketScreen();
    }
  }

  Future<void> showExpiredTicketScreen() async {
    // Navigate to the ticket expired screen
    var currUserId = Get.arguments.toString();
    await Get.offAll(() => DashBoardScreen(), arguments: currUserId);
  }

  Future<void> getData() async {
    var currId = Get.arguments.toString();

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(currId).get();

    final DocumentSnapshot ticketDoc = await FirebaseFirestore.instance
        .collection('ticket-info')
        .doc(currId)
        .get();

    userData = userDoc.data();
    ticketData = ticketDoc.data();

    setState(() {
      name = userData['name'];
      email = userData['email'];
      fromPlace = ticketData['fromPlace'];
      toPlace = ticketData['toPlace'];
      purchaseDate = ticketData['purchaseDate'];
    });
  }

  bool isTicketExpired() {
    DateTime expirationTime = purchaseDate
        .toDate()
        .add(Duration(hours: 2)); // Calculate expiration time
    DateTime now = DateTime.now();

    return now.isAfter(expirationTime);
  }

  @override
  Widget build(BuildContext context) {
    if (isTicketExpired()) {
      // Show the ticket expired screen
      return Scaffold(
        backgroundColor: Colors.red, // You can customize the color
        appBar: AppBar(
          title: Text(
            'Ticket Expired',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Your ticket has expired.',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Center(
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  // Navigate back to the dashboard or any other screen
                  var currUserId = Get.arguments.toString();
                  Get.offAll(() => DashBoardScreen(), arguments: currUserId);
                },
                child: Text(
                  'Go back to Dashboard',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
          'Preview Ticket',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            " Preview Your Ticket ",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            " Thank You ! For Purchasing ",
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 450,
              //color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/user_profile.png"),
                    radius: 40,
                  ),
                  Text(
                    name,
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
                        " Email Address : ",
                        style: myStyle,
                      ),
                      Text(
                        email,
                        style: myStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " From : ",
                        style: myStyle,
                      ),
                      Text(
                        fromPlace,
                        style: myStyle,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " To : ",
                        style: myStyle,
                      ),
                      Text(
                        toPlace,
                        style: myStyle,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Purchased At : ",
                        style: myStyle,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(purchaseDate.toDate()),
                        style: myStyle,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            color: const Color.fromARGB(255, 1, 72, 130),
            height: 20.h,
            minWidth: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            child: Text(
              " Close ",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              var currUserId = Get.arguments.toString();
              Get.offAll(() => DashBoardScreen(), arguments: currUserId);
            },
          ),
        ],
      ),
    );
  }
}
