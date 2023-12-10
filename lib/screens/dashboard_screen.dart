import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:new_sdk_demo/screens/history_screen.dart';
import 'package:new_sdk_demo/screens/login.dart';
import 'package:new_sdk_demo/screens/pass_screen.dart';
import 'package:new_sdk_demo/screens/purchase_pass_screen.dart';
import 'package:new_sdk_demo/screens/purchase_ticket_screen.dart';
import 'package:new_sdk_demo/screens/qr_screen.dart';
import 'package:new_sdk_demo/screens/ticket_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  var data;
  var name = "";
  var isPassBought = false;
  var isTicketBought = false;
  var currId = Get.arguments.toString();
  var isTravelled = false;
  var passData;
  int amount = 0;

  List<Color> colors = [
    Color.fromARGB(255, 103, 180, 243),
    Color.fromARGB(255, 32, 201, 239)
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var currentUserId = user?.uid;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    final DocumentSnapshot passDoc = await FirebaseFirestore.instance
        .collection('pass-info')
        .doc(currentUserId)
        .get();

    data = userDoc.data();
    passData = passDoc.data();

    setState(() {
      name = data['name'];
      isPassBought = data['isPassBought'] ?? false;
      isTicketBought = data['isTicketBought'] ?? false;
      isTravelled = data['isTravelled'] ?? false;
      passData == null ? amount = 0 : amount = passData['amount'] ?? 0;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('Hello ,',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                  subtitle: Text(name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  trailing: InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Get.offAll(() => LoginScreen());
                    },
                    child: CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard(
                      'View Ticket', Icons.notes_outlined, Colors.deepOrange),
                  itemDashboard('View Pass', Icons.perm_contact_cal_outlined,
                      Colors.blue),
                  itemDashboard('Purchase Ticket', Icons.toc, Colors.purple),
                  itemDashboard('Purchase Pass', Icons.text_snippet_outlined,
                      Colors.green),
                  itemDashboard('History', Icons.history, Colors.brown),
                  itemDashboard('QR Scan', Icons.qr_code, Colors.indigo),
                  itemDashboard('LogOut', Icons.logout, Colors.teal),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) =>
      GestureDetector(
          onTap: () {
            if (title == 'View Ticket') {
              if (isTicketBought == true) {
                currId = Get.arguments.toString();
                Get.to(() => TicketScreen(), arguments: currId);
              } else if (isPassBought == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please Buy Ticket First "),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }
            }
            if (title == 'View Pass') {
              if (isPassBought == true) {
                currId = Get.arguments.toString();
                Get.to(() => PassScreen(), arguments: currId);
              } else if (isPassBought == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please Buy Pass First "),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }
            }
            if (title == 'Purchase Ticket') {
              currId = Get.arguments.toString();
              Get.to(() => PurchaseTicket(), arguments: name);
            }
            if (title == 'Purchase Pass') {
              if (isPassBought == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You have already bought pass "),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              } else if (isPassBought == false) {
                Get.to(() => PurchasePass());
              }
            }
            if (title == 'LogOut') {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginScreen());
            }
            if (title == 'QR Scan') {
              if (isPassBought == true && amount > 0) {
                Get.to(() => ScanScreen(), arguments: 1);
              } else if (isPassBought == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(" Please Buy Pass First "),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              } else if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(" You have exhausted your pass limit "),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }
            }
            if (title == 'History') {
              if (isTicketBought == true ||
                  (isPassBought == true && isTravelled == true)) {
                Get.to(() => HistoryScreen());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(" You dont have any history "),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 5),
                      color: Theme.of(context).primaryColor.withOpacity(.2),
                      spreadRadius: 2,
                      blurRadius: 5)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, color: Colors.white)),
                const SizedBox(height: 8),
                Text(title.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium)
              ],
            ),
          ));
}
