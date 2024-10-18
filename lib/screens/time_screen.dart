import 'package:flutter/material.dart';
import 'package:hillfair/screens/mesage_page_list.dart';

import 'dart:async';
import 'package:intl/intl.dart'; // For formatting time

// import 'chat_page.dart'; // Your message page import

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Timer _timer;
  Duration _remainingTime = Duration();
  List<DateTime> _targetTimes = []; // List to hold target times
  DateTime? _nextTargetTime;

  @override
  void initState() {
    super.initState();
    _initializeTargetTimes();
    _startCountdown();
  }

  // Initialize the list of target times (for example, 5 PM and 8 PM)
  void _initializeTargetTimes() {
    DateTime now = DateTime.now();
    
    // Example target times (5 PM and 8 PM)
    _targetTimes.add(DateTime(now.year, now.month, now.day, 11, 0, 0)); // 5 PM
    _targetTimes.add(DateTime(now.year, now.month, now.day, 20, 0, 0)); // 8 PM

    // Find the next target time after current time
    _nextTargetTime = _targetTimes.firstWhere((time) => time.isAfter(now), orElse: () => _targetTimes.last);
    _updateRemainingTime();
  }

  // Function to start the countdown
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _updateRemainingTime();
      });
    });
  }

  // Function to update remaining time until the next target time
  void _updateRemainingTime() {
    DateTime now = DateTime.now();

    // If we have no more target times for the day, reset
    if (_nextTargetTime != null && _nextTargetTime!.isBefore(now)) {
      _nextTargetTime = null;
    }

    // If there's a valid next target time, calculate the remaining time
    if (_nextTargetTime != null) {
      _remainingTime = _nextTargetTime!.difference(now);
    } else {
      _remainingTime = Duration.zero;
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFCD866D),
      appBar: AppBar(
        backgroundColor: Color(0xFFCD866D),
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: screenwidth * 0.02),
            child: IconButton(
              icon: Icon(Icons.message_outlined, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessageListPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Be Patient',
                style: TextStyle(
                  fontSize: screenwidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenheight * 0.1),
              Container(
                padding: EdgeInsets.all(screenwidth * 0.1),
                decoration: BoxDecoration(
                  color: Color(0xFFA95D4C),
                  borderRadius: BorderRadius.circular(screenwidth * 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: screenwidth * 0.04,
                      offset: Offset(0, screenheight * 0.01),
                    ),
                  ],
                ),
                child: Text(
                  _formatDuration(_remainingTime),
                  style: TextStyle(
                    fontSize: screenwidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenheight * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.05),
                child: Text(
                  '“Your worth is not defined by someone else’s presence. Love yourself first, and the right connections will follow in time.”',
                  style: TextStyle(
                    fontSize: screenwidth * 0.045,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
