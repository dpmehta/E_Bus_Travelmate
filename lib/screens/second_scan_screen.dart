import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:new_sdk_demo/screens/qr_screen.dart';

class SecondScanScreen extends StatefulWidget {
  @override
  _SecondScanScreenState createState() => _SecondScanScreenState();
}

class _SecondScanScreenState extends State<SecondScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Theme.of(context).primaryColor,
              height: 60.0, // Adjust the height as needed
              minWidth: 200.0, // Adjust the width as needed
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: Text(
                "Scan Again",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                // Add your logic for "Scan Again" button press
                // For example, you can navigate back to the scanning screen
                Get.to(() => ScanScreen(), arguments: 2);
              },
            ),
            SizedBox(height: 20.0), // Adjust the spacing between buttons
            MaterialButton(
              color: Theme.of(context).primaryColor,
              height: 60.0, // Adjust the height as needed
              minWidth: 200.0, // Adjust the width as needed
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                // Add your logic for "Cancel" button press
                // For example, you can navigate to the home screen
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
