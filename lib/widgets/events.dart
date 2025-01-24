import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/screens/events_page.dart';
import 'package:hillfair/screens/models.dart';
import 'package:hillfair/widgets/custom_route.dart';
import 'package:hillfair/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class Events extends StatefulWidget {
  final int itemCount;

  const Events({super.key, required this.itemCount});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
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
          isLoading = false; // Stop loading once data is fetched
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
    final size = MediaQuery.of(context).size;
    return isLoading
        ? Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: size.width,
                height: 271,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ), // Show loading indicator
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Events",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context, createFadeRoute(const EventPage()));
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 40,
                    ),
                  ),
                ],
              ),
              urls.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      child: customForHome(
                        context,
                        urls[0],
                        titles[0],
                      ),
                    )
                  : const SizedBox(), // Handle empty state
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.itemCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 300,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                child: Image.network(
                                  urls[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 180,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              titles[index], // Corrected index usage
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
  }
}
