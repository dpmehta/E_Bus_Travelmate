import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_sdk_demo/screens/pass_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurchasePass extends StatefulWidget {
  const PurchasePass({Key? key}) : super(key: key);

  @override
  _PurchasePassState createState() => _PurchasePassState();
}

class _PurchasePassState extends State<PurchasePass> {
  List<Color> colors = [
    Color.fromARGB(255, 103, 180, 243),
    Color.fromARGB(255, 32, 201, 239)
  ];
  TextEditingController passNameController = TextEditingController();
  TextEditingController passAgeController = TextEditingController();
  TextEditingController passContactNoController = TextEditingController();

  String? gender; // Updated to store selected gender

  @override
  void dispose() {
    passNameController.dispose();
    passAgeController.dispose();
    passContactNoController.dispose();
    super.dispose();
  }

  String _validateInputs() {
    String errorMessage = '';

    if (passNameController.text.isEmpty ||
        passAgeController.text.isEmpty ||
        passContactNoController.text.isEmpty ||
        gender == null) {
      errorMessage = "Please fill all fields";
    }

    return errorMessage;
  }

  void pay() {
    // Search for buses based on the current state
    makePayment();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String passName = passNameController.text;
    String passAge = passAgeController.text;
    String passContact = passContactNoController.text;

    User? user = FirebaseAuth.instance.currentUser;

    String? uid = user?.uid;

    FirebaseFirestore.instance.collection("pass-info").doc(uid).set({
      'name': passName,
      'age': passAge,
      'contact-no': passContact,
      'gender': gender,
      'passPurchaseDate': DateTime.now(),
      'passExpiryDate': DateTime.now().add(Duration(days: 30)),
      'amount': 300,
      'userId': uid,
    });

    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'isPassBought': true,
    });

    GetStorage storage = GetStorage();
    storage.write('passAmount', 300);

    Get.offAll(() => PassScreen(), arguments: uid);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error HERE: ${response.code}- ${response.message}");
  }

  void _handleEXTERNALWALLET(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET IS: ${response.walletName}");
  }

  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleEXTERNALWALLET);
  }

  void makePayment() async {
    var options = {
      'key': 'rzp_test_lZ99Ivltt5JfRU',
      'amount': 20000,
      'name': passNameController.text,
      'description': 'Bus Pass',
      'prefill': {
        'contact': passContactNoController.text,
        'email': "dev@gmail.com"
      },
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Purchase Pass',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 24.0)),
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
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset('assets/images/purchase_pass.png'),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: passNameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.black87),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField(
                        controller: passAgeController,
                        decoration: InputDecoration(
                          labelText: "Age",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 5),
                    // Gender RadioButton
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gender",
                            style: TextStyle(color: Colors.black87),
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: "Male",
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                              Text("Male"),
                              Radio<String>(
                                value: "Female",
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                              Text("Female"),
                              Radio<String>(
                                value: "Trans",
                                groupValue: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                              Text("Trans"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField(
                        controller: passContactNoController,
                        decoration: InputDecoration(
                          labelText: "Contact Number",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 30),
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
                      onPressed: () async {
                        String errorMessage = _validateInputs();
                        if (errorMessage.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          pay();
                        }
                      },
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
