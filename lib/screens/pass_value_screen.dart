import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_sdk_demo/screens/dashboard_screen.dart';

class PassValue extends StatefulWidget {
  const PassValue({Key? key}) : super(key: key);

  @override
  State<PassValue> createState() => _PassValueState();
}

class _PassValueState extends State<PassValue> {
  GetStorage storage = GetStorage();
  String fromValue = "";
  String toValue = "";
  late int a;
  late int b;
  late int c;
  late int cost;
  var amount;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    fromValue = storage.read("FromValue") ?? "";
    toValue = storage.read("toValue") ?? "";
  }

  void initializeData() {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;

    FirebaseFirestore.instance.collection("history-info").doc(uid).set({
      'fromPlace': fromValue,
      'toPlace': toValue,
      'travelDate': DateTime.now(),
      'userId': uid,
    });
    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'isTravelled': true,
    });
    a = int.parse(fromValue.replaceAll(RegExp(r'[^0-9]'), ''));
    b = int.parse(toValue.replaceAll(RegExp(r'[^0-9]'), ''));

    // Perform a - b operation
    c = a - b;

    // If the result is negative, make it positive
    if (c < 0) {
      c = -c;
    }

    // Multiply c by 5 and store it in cost
    cost = c * 2;

    print("cost: $cost"); // Output: 35

    FirebaseFirestore.instance
        .collection("pass-info")
        .doc(uid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        amount = docSnapshot.data()?['amount'];

        int newAmount = amount - cost;
        print("===============================");
        print(uid);
        print("newAmount:  $newAmount");
        print("amount:  $amount");
        print("cost:  $cost");
        print("===============================");
        FirebaseFirestore.instance.collection("pass-info").doc(uid).update({
          'amount': newAmount,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeData();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Image.asset('assets/images/payment.gif'),
          Text(
            '$cost is deducted',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
                "Back To DashBoard",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Get.offAll(() => DashBoardScreen());
              }),
        ]),
      ),
    );
  }
}
