import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hillfair/auth.dart';
import 'package:hillfair/functions/functions.dart';
import 'package:hillfair/screens/chat_page.dart';
import 'package:hillfair/screens/edit_profile.dart';
import 'package:hillfair/screens/help.dart';
import 'package:hillfair/screens/login_screen.dart';
import 'package:hillfair/screens/privacyPolicy.dart';
import 'package:hillfair/widgets/custom_route.dart';
import 'package:hillfair/widgets/events.dart';
import 'package:hillfair/widgets/snack_bar.dart';
import 'package:hillfair/widgets/widgets.dart';
import 'package:hillfair/widgets/carousel.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? email;
  String? name;
  String? gender;
  String? image;

  @override
  void initState() {
    super.initState();
    setInitialValues(context);
  }

  void setInitialValues(BuildContext context) async {
    // Fetching the data asynchronously
    String? fetchedMongoDbUserId = await firebaseId.getMongoDbUserId();
    String? fetchedEmail = await firebaseId.getEmail();
    String? fetchedUsername = await firebaseId.getUsername();
    String? fetchedGender = await firebaseId.getGender();


    setState(() {
      email = fetchedEmail ?? 'No email available'; 
      gender = fetchedGender ?? 'unknown'; 
      name = fetchedUsername ?? 'Guest'; 

      
      if (gender == "male") {
        image = "assets/images/375139.png";
      } else if (gender == "female") {
        image = "assets/images/375571.png"; 
      } else {
        image = "...."; 
      }
    });
  }

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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Increased height of DrawerHeader using MediaQuery
              SizedBox(
                height: size.height * 0.35, // Adjust to 45% of screen height
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 221, 227, 236), // Optional background color
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Center everything horizontally
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center everything vertically
                    children: [
                      CircleAvatar(
                        radius: 70, // Avatar size remains the same
                        backgroundColor: const Color.fromARGB(255, 14, 0, 0),
                        child: ClipOval(
                          child: Image.asset(
                            image ?? "loading",
                            fit: BoxFit.cover,
                            width:
                                120, // Same as avatar radius to maintain proportions
                            height:
                                120, // Matches avatar radius for even scaling
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      Text(
                        name ?? 'Loading...',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        email ?? 'Loading...',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Additional space between the header and menu items

              // ListTiles for menu items
              ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text(
                  "Edit Profile",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                      context, createFadeRoute(EditProfilePage())); // Navigate
                },
              ),
              ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text(
                  "Privacy",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                      context, createFadeRoute(LegalPrivacyPage())); // Navigate
                },
              ),
              ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text(
                  "Help",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(context, createFadeRoute(HelpSupport()));
                },
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
                  Navigator.pop(context); // Close drawer
                  // Add settings navigation logic
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
                  clearStoredData();
                  logoutUser();
                  Navigator.pop(context); // Close the drawer
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
                    'assets/images/hori 1 (4).png',
                    'Chat With Your Favorite',
                  ),
                ),
                SizedBox(height: 75),
                Stack(children: [
                  SizedBox(
                      width: size.width,
                      child: Image.asset('assets/images/Frame 9337 (1).png')),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 30, 0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconLinkWidget(
                          iconData: FontAwesomeIcons.instagram,
                          url:
                              "https://www.instagram.com/appteam_nith/profilecard/?igsh=MW5rNmRyMjhjbzQ1YQ==",
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconLinkWidget(
                          iconData: FontAwesomeIcons.linkedin,
                          url: "https://www.linkedin.com/company/appteam-nith/",
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconLinkWidget(
                          iconData: FontAwesomeIcons.github,
                          url: "https://github.com/appteam-nith",
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ]),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
