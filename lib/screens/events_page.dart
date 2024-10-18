import 'package:flutter/material.dart';
import 'package:hillfair/global_variables.dart';
import 'package:hillfair/widgets/events.dart';
import 'package:hillfair/widgets/workshops.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: Events(
            itemCount: images.length,
          ),
        ),
      ),
    );
  }
}
