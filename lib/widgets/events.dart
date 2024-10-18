import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/screens/events_page.dart';
import 'package:hillfair/widgets/widgets.dart';

class Events extends StatelessWidget {
  final int itemCount;

  const Events({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'https://picsum.photos/id/1041/200/300',
      'https://picsum.photos/id/1003/200/300',
      'https://picsum.photos/id/1025/200/300',
      'https://picsum.photos/id/106/200/300',
      'https://picsum.photos/id/1015/200/300',
      'https://picsum.photos/id/1001/200/300'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Events",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => EventPage()));
              },
              icon: Icon(
                Icons.keyboard_arrow_right,
                size: 40,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: customForHome(
            context,
            images[1],
            "Event 1",
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Image.network(
                            images[index],
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
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Event ${index + 1 + 1}',
                        style: TextStyle(
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
