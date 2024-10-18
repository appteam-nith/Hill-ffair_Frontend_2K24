import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/screens/chat_page.dart';
import 'package:hillfair/screens/edit_profile.dart';
import 'package:hillfair/widgets/events.dart';
import 'package:hillfair/widgets/snack_bar.dart';
import 'package:hillfair/widgets/widgets.dart';
import 'package:hillfair/widgets/workshops.dart';
import 'package:hillfair/widgets/carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          color: Color(0xffD0E9FF),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffD0E9FF),
            elevation: 0,
            actions: [
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(
                  "Hi User.. !!!",
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => ChatPage()));
                  },
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: SizedBox(
        height: size.height,
        child: Drawer(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 300,
                child: DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/bg_image_1.png',
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'User Name',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        'username@example.com',
                        style: TextStyle(
                          color: Color.fromARGB(179, 0, 0, 0),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                trailing: GestureDetector(
                    onTap: () => {}, child: Icon(Icons.keyboard_arrow_right)),
                title: Text(
                  "Edit Profile",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                trailing: GestureDetector(
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => EditProfilePage()))
                        },
                    child: Icon(Icons.keyboard_arrow_right)),
                title: Text(
                  "Privacy",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                trailing: GestureDetector(
                    onTap: () => {}, child: Icon(Icons.keyboard_arrow_right)),
                title: Text(
                  "Help",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.black,
                ),
                title: Text(
                  'Settings',
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  size: 30,
                  color: Colors.black,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                onTap: () {
                  logoutUser();
                  showSnackBar(context, "Logged Out Successfully...");
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Frame 9292.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Carousel(),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Events(
                  itemCount: 2,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Workshops(
                  itemCount: 2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      'Features',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: customForHome3(
                    context, 'assets/images/hori 1 (4).png', 'Find Your Match'),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: customForHome3(context, 'assets/hori 1 (5).png',
                    'Chat With Your Favorite'),
              ),
              SizedBox(
                height: 50,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
