import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/screens/chat_page.dart';
import 'package:hillfair/screens/edit_profile.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/widgets/custom_route.dart';
import 'package:hillfair/widgets/events.dart';
import 'package:hillfair/widgets/snack_bar.dart';
import 'package:hillfair/widgets/widgets.dart';
import 'package:hillfair/widgets/carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffF7E8D0), Color(0xffF3CBB6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
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
              SizedBox(height: 50),
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
                              context, createFadeRoute(EditProfilePage()))
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
                  Navigator.pushReplacement(
                      context, createFadeRoute(LoginScreen()));
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
              gradient: LinearGradient(
                colors: [Color(0xffF7E8D0), Color(0xffF3CBB6)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Carousel(),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Events(itemCount: 2),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    context,
                    'assets/images/hori 1 (4).png',
                    'Find Your Match',
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: customForHome3(
                    context,
                    'assets/hori 1 (5).png',
                    'Chat With Your Favorite',
                  ),
                ),
                SizedBox(height: 75),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
