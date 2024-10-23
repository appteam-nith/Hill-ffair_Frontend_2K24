import 'dart:ffi';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hillfair/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

void dialogBox(BuildContext context) {
  TextEditingController emailforgotController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            title: const Text(
              "Forgot password?",
              style: TextStyle(fontFamily: "georgia"),
            ),
            content: Text(
              "Enter your email to receive a password reset link",
              style: TextStyle(fontFamily: "georgia"),
            ),
            actions: <Widget>[
              TextField(
                cursorColor: Colors.black,
                style: const TextStyle(fontFamily: "georgia"),
                controller: emailforgotController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  hintText: "Email",
                  hintStyle: const TextStyle(
                      fontFamily: "georgia", color: Colors.black45),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black45,
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(255, 18, 56, 87)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 255, 255, 255)),
                    ),
                    child: const Text(
                      "Cancel",
                      style:
                          TextStyle(fontFamily: "georgia", color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 255, 255, 255)),
                    ),
                    child: const Text(
                      "Send",
                      style:
                          TextStyle(fontFamily: "georgia", color: Colors.black),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: emailforgotController.text)
                          .then(
                        (value) {
                          final materialBanner = MaterialBanner(
                            /// need to set following properties for best effect of awesome_snackbar_content
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            forceActionsBelow: true,
                            content: AwesomeSnackbarContent(
                              title: 'Sent',
                              message: 'Password reset link sent successfully!',

                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                              contentType: ContentType.success,
                              // to configure for material banner
                              inMaterialBanner: true,
                            ),
                            actions: const [SizedBox.shrink()],
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentMaterialBanner()
                            ..showMaterialBanner(materialBanner);
                          Navigator.of(context).pop();
                          emailforgotController.clear();
                        },
                      ).onError((error, stackTrace) {
                        final materialBanner = MaterialBanner(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          forceActionsBelow: true,
                          content: AwesomeSnackbarContent(
                            title: 'Error',
                            message: 'An error occurred!',

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.failure,
                            // to configure for material banner
                            inMaterialBanner: true,
                          ),
                          actions: const [SizedBox.shrink()],
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentMaterialBanner()
                          ..showMaterialBanner(materialBanner);
                        Navigator.of(context).pop();
                        emailforgotController.clear();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget customText(String title) {
  return SizedBox(
      height: 70,
      width: double.infinity,
      child: Center(
        child: Text(title,
            style: GoogleFonts.inriaSans(
              color: const Color(0xff543310),
              fontWeight: FontWeight.w600,
              fontSize: 50,
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            )),
      ));
}

Widget buildTextField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  FormFieldValidator<String>? validator,
  double? width,
  bool isPassword = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: SizedBox(
      height: 65,
      width: width,
      child: TextFormField(
        style: TextStyle(
          fontSize: 18, // Increase font size
          fontWeight: FontWeight.w500, // Font weight (Medium)
          color: Colors.black87, // Text color
          fontFamily: 'Roboto', // Custom font family (Add font to pubspec.yaml)
        ),
        cursorColor: Colors.black,
        cursorWidth: 2.0,
        validator: validator,
        obscureText: isPassword,
        onTap: () {},
        enableInteractiveSelection: true,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 40,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          labelText: label,
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
          ),
          labelStyle:
              TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.8)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 25.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              width: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              width: 2.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              width: 2.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customButton(
  double width,
  String label,
  VoidCallback onPressed,
) {
  return SizedBox(
      height: 60,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 20,
          backgroundColor: Color(0xff543310),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SizedBox(
          height: 47,
          width: 117,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inriaSans(
                color: const Color.fromARGB(255, 247, 245, 245),
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ));
}

Widget customText2(String title) {
  return SizedBox(
      width: double.infinity,
      child: Center(
        child: Text(title,
            style: GoogleFonts.inriaSans(
              color: const Color.fromARGB(255, 30, 29, 29),
              fontWeight: FontWeight.w600,
              fontSize: 40,
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            )),
      ));
}

Widget customButton2(String label, VoidCallback callBack) {
  return SizedBox(
      height: 55,
      width: 360,
      child: ElevatedButton(
        onPressed: callBack,
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: Color.fromARGB(255, 165, 149, 149),
            width: 1,
          ),
          elevation: 20,
          backgroundColor: Color.fromARGB(255, 105, 93, 93),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.roboto(
              color: const Color.fromARGB(255, 213, 208, 208),
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
        ),
      ));
}

Widget customButton3(String label, Future? Function() param1) {
  return SizedBox(
      height: 55,
      width: 360,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: Color.fromARGB(255, 62, 55, 48),
            width: 1,
          ),
          elevation: 20,
          backgroundColor: const Color.fromARGB(255, 44, 19, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.roboto(
              color: const Color.fromARGB(255, 213, 208, 208),
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
          ),
        ),
      ));
}

Widget customForHome(BuildContext context, String url, String text) {
  final size = MediaQuery.of(context).size;
  return Column(
    children: [
      SizedBox(height: 10),
      Container(
        height: 300,
        width: size.width,
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
              flex: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: size.width,
                      height: 200,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget customForHome3(BuildContext context, String image, String text) {
  final size = MediaQuery.of(context).size;
  return Column(
    children: [
      SizedBox(height: 10),
      Container(
        height: 400,
        width: size.width,
        margin: EdgeInsets.symmetric(horizontal: 0),
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
              flex: 90,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: size.width,
                    height: 200,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget option(VoidCallback ontap, double? width) {
  return GestureDetector(
    onTap: ontap,
    child: SizedBox(
      height: 51,
      width: width,
      child: Container(
        height: 100, // Adjust as needed
        width: 300, // Adjust as needed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1075CC).withOpacity(0.5), // Blue on the left
              Color.fromARGB(255, 255, 240, 240)
                  .withOpacity(0.5), // White in the center
              Color(0xff1075CC).withOpacity(0.5), // Blue on the right
            ],
            stops: [0.0, 0.4, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(
              50), // Adjust radius to get the rounded ends
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 169, 160, 160),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(0, 2), // Adjust for shadow effect
            ),
          ],
        ),
      ),
    ),
  );
}

class IconLinkWidget extends StatelessWidget {
  final IconData iconData; // Icon to display
  final String url; // URL to open
  final double size; // Optional size for the icon
  final Color color; // Optional color for the icon

  const IconLinkWidget({
    Key? key,
    required this.iconData,
    required this.url,
    this.size = 30.0, // Default size
    this.color = Colors.blue, // Default color
  }) : super(key: key);

  // Function to open the URL
  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchURL, // Launch the URL when tapped
      child: Icon(
        iconData,
        size: size,
        color: color,
      ),
    );
  }
}
