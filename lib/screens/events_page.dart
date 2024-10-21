import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hillfair/screens/models.dart';
import 'package:hillfair/widgets/events.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  // Lists to store event data
  List<String> urls = [];
  List<String> titles = [];
  List<String> descriptions = [];
  bool isLoading = true; // To manage the loading state

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch events when the widget is initialized
  }

  // Function to fetch events and store data in lists
  Future<void> fetchEvents() async {
    var dio = Dio();

    try {
      var response = await dio.get(
          'https://hillffair-backend-2k24.onrender.com/event/events'); // Replace with your API URL

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        // Loop through the response data and populate the lists
        setState(() {
          for (var json in data) {
            Event event = Event.fromJson(json);
            urls.add(event.url);
            titles.add(event.title);
            descriptions.add(event.description);
          }
          isLoading = false; // Set loading to false once data is fetched
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                child: Events(
                  itemCount: urls.length-1,
                ),
              ),
            ),
    );
  }
}
