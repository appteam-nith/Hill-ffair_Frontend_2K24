import 'package:flutter/material.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help & Support",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: const [
            Image(image: AssetImage("assets/images/support.png")),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Have questions or suggestions about our app? Dont hesitate to reach out to us",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Contact Us",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color:Colors.blueAccent),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Sankalp Gupta",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.call,
                  size: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "+91 83069 13455",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Aryan Raghav",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.call,
                  size: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "+91 76687 75545",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
