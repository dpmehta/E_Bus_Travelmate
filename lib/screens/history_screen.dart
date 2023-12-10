import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Color> colors = [
    Color.fromARGB(255, 103, 180, 243),
    Color.fromARGB(255, 32, 201, 239)
  ];
  String uid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  // Function to retrieve travel history for a specific user
  Future<List<Map<String, dynamic>>> getTravelHistory(uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("history-info")
          .where('userId', isEqualTo: uid)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching travel history: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Travel History',
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
              end: Alignment.bottomCenter),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getTravelHistory(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  List<Map<String, dynamic>> travelHistory =
                      snapshot.data ?? [];

                  return ListView.separated(
                    itemBuilder: (context, index) {
                      var historyItem = travelHistory[index];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.pin_drop_outlined),
                          Text(" ${historyItem['fromPlace']} "),
                          Icon(Icons.arrow_circle_right_outlined),
                          Text(" ${historyItem['toPlace']} "),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Divider(height: 50, thickness: 3),
                    itemCount: travelHistory.length,
                  );
                },
              ),
            ),
            Image.asset('assets/images/history.png',
                width: double.infinity, height: 250),
          ],
        ),
      ),
    );
  }
}
