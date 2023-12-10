import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:new_sdk_demo/screens/ticket_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PurchaseTicket extends StatefulWidget {
  const PurchaseTicket({Key? key}) : super(key: key);

  @override
  _PurchaseTicketState createState() => _PurchaseTicketState();
}

class _PurchaseTicketState extends State<PurchaseTicket> {
  String from = 'Madhapar Chowk';
  String to = 'Raiya Circle';
  String dateOfJourney = 'Saturday, 02 December 2023';
  TextEditingController dateInput = TextEditingController();

  List<Color> colors = [
    Color.fromARGB(255, 103, 180, 243),
    Color.fromARGB(255, 32, 201, 239)
  ];
  List<String> busStopOptions = [
    'Madhapar Chowk',
    'Ayodhya Chowk',
    'Sheetal Park',
    'Ramapir Chowkdi',
    'Nanavati Chowk',
    'Raiya Circle',
    'Raiya Telephone Exchange',
    'Indira Circle',
    'KKV Chowk',
    'West Zone Office',
    'Nana Mouva Chowk',
    'Mahapuja Dham Chowk',
    'Om Nagar',
    'Mavdi',
    'Umiya Chowk',
    'Ambedkar Chowk',
    'Govardhan Chowk',
    'Puneet Nagar',
    'Gondal Chowkdi',
  ];

  void updateFrom(String? newFrom) {
    setState(() {
      from = newFrom ?? from;
    });
  }

  void updateTo(String? newTo) {
    setState(() {
      to = newTo ?? to;
    });
  }

  void updateDateOfJourney(String newDateOfJourney) {
    setState(() {
      dateOfJourney = newDateOfJourney;
    });
  }

  void searchBus() {
    // Search for buses based on the current state
    print('Searching for buses from $from to $to on $dateOfJourney');

    makePayment();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    User? user = FirebaseAuth.instance.currentUser;

    String? uid = user?.uid;

    FirebaseFirestore.instance.collection("ticket-info").doc(uid).set({
      "fromPlace": from,
      "toPlace": to,
      "dateOfJourney": dateOfJourney,
      "userId": uid,
      "purchaseDate": DateTime.now(),
    });

    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'isTicketBought': true,
    });

    Get.offAll(() => TicketScreen(), arguments: uid);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error HERE : ${response.code}- ${response.message}");
  }

  void _handleEXTERNALWALLET(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET IS: ${response.walletName}");
  }

  Razorpay? _razorpay;

  void initState() {
    super.initState();
    dateInput.text = ""; // set the initial value of the text field
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleEXTERNALWALLET);
  }

  final DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime.now().add(const Duration(days: 365));

  final Duration duration = const Duration(days: 14);

  DateTime start = DateTime.now();

  void makePayment() async {
    var options = {
      'key': 'rzp_test_lZ99Ivltt5JfRU',
      'amount': 10000,
      'name': Get.arguments,
      'description': 'Bus Ticket',
      'prefill': {'contact': "8490063109", 'email': "xyz@gmail.com"},
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Purchase Ticket',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bus stop sign image
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset('assets/images/bus.png'),
              ),
              // Bus stop information
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // From
                    Row(
                      children: [
                        Text('From:',
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: 'Roboto')),
                        SizedBox(width: 8.0),
                        DropdownButton<String>(
                          value: from,
                          items: busStopOptions
                              .map((option) => DropdownMenuItem(
                                    child: Text(option),
                                    value: option,
                                  ))
                              .toList(),
                          onChanged: updateFrom,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                          ),
                          dropdownColor: Colors.white,
                          underline: SizedBox(),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: const Icon(
                          Icons.route,
                          size: 40,
                          color: Color.fromARGB(255, 94, 93, 93),
                        ),
                      ),
                    ),

                    // To
                    Row(
                      children: [
                        Text('To:',
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: 'Roboto')),
                        SizedBox(width: 8.0),
                        DropdownButton<String>(
                          value: to,
                          items: busStopOptions
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: updateTo,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                          ),
                          dropdownColor: Colors.white,
                          underline: SizedBox(),
                        ),
                      ],
                    ),
                    // Date of journey
                    Row(
                      children: [
                        Text('Date of Journey : ',
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: 'Roboto')),
                        Expanded(
                          child: TextField(
                            controller: dateInput,
                            //editing controller of this TextField
                            decoration: InputDecoration(
                                icon: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.calendar_today),
                                ), //icon of text field
                                labelText: "Enter Date" //label text of field
                                ),
                            readOnly: true,
                            //set it true, so that the user will not be able to edit text
                            onTap: () async {
                              DateTime currentDate = DateTime.now();
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: currentDate,
                                firstDate: currentDate,
                                lastDate: currentDate.add(Duration(days: 3)),
                              );

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using the intl package =>  2021-03-16
                                setState(() {
                                  dateInput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Search bus button
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
                        " Pay ",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: searchBus,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
