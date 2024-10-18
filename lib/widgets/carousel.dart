import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<String> images = [
    'https://picsum.photos/id/1041/200/300',
    'https://picsum.photos/id/1003/200/300',
    'https://picsum.photos/id/1025/200/300',
    'https://picsum.photos/id/106/200/300',
    'https://picsum.photos/id/1015/200/300',
    'https://picsum.photos/id/1001/200/300'
  ];
  int _currentIndex = 0;
  final CarouselSliderController carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        CarouselSlider(
          carouselController: carouselController,
          options: CarouselOptions(
            height: 270.0,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            enableInfiniteScroll: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: images.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      width: size.width,
                      height: 270.0,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => carouselController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? const Color.fromARGB(255, 23, 23, 23)
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
