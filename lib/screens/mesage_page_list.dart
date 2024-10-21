// import 'package:flutter/material.dart';
// import 'package:hillfair/widgets/custom_route.dart';
// import 'chat_page.dart';

// class MessageListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final screenwidth = MediaQuery.of(context).size.width;
//     final screenhight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Color(0xFFF5E6D9),
//       appBar: AppBar(
//         backgroundColor: Colors.brown,
//         title: Text('Messages'),
//       ),
//       body: ListView.builder(
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 4.0, // Set elevation for the Card
//             margin: EdgeInsets.symmetric(
//                 vertical: 8.0, horizontal: 10.0), // Optional margin
//             shape: RoundedRectangleBorder(
//               borderRadius:
//                   BorderRadius.circular(10.0), // Optional rounded corners
//             ),
//             child: ListTile(
//               leading: Container(
//                 width: screenwidth * 0.08, // Set the width
//                 height: screenhight * 0.04, // Set the height
//                 decoration: BoxDecoration(
//                   color: Colors.brown, // Set the background color
//                   shape: BoxShape.rectangle, // Make it a square
//                 ),
//               ),
//               title: Text('Virendra Sahu'),
//               subtitle: Text('Hi, How are you?'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   createFadeRoute(ChatPage()),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
