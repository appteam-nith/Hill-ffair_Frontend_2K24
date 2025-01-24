import 'package:flutter/material.dart';

class LegalPrivacyPage extends StatelessWidget {
  const LegalPrivacyPage({super.key});
// privacy
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Legal & Privacy Terms",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "APP Team NITH built the Cultural fest app app as a Free app. This SERVICE is provided by APP Team NITH at no cost and is intended for use as is.This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our ServiceIf you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Technical fest app unless otherwise defined in this Privacy Policy.Information Collection and UseFor a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to 8709453377. The information that we request will be retained by us and used as described in this privacy policy.The app does use third-party services that may collect information used to identify you.Link to the privacy policy of third-party service providers used by the app",
          style: TextStyle(fontSize: 16),
        ),
      )),
    );
  }
}
