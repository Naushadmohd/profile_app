import 'package:assignment_app/views/Update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controller/profile_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileDisplayPage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                Get.to(() => UpdateProfilePage());
              },
              child: FaIcon(FontAwesomeIcons.userEdit)),
          SizedBox(width: 20),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: isDarkMode ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 3),
                  blurRadius: 3,
                  spreadRadius: 2),
            ]),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                Obx(() => CircleAvatar(
                      backgroundColor: isDarkMode ? Colors.black : Colors.white,
                      radius: 50,
                      backgroundImage:
                          controller.profilePicture.value.isNotEmpty
                              ? FileImage(File(controller.profilePicture.value))
                              : AssetImage('assets/images/profile.jpeg')
                                  as ImageProvider,
                    )),
                SizedBox(height: 20),

                // Name
                Obx(() => Text(
                      controller.name.value.isNotEmpty
                          ? controller.name.value
                          : "No Name",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 10),

                // Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.email.value.isNotEmpty
                              ? controller.email.value
                              : "No Email",
                          style: TextStyle(fontSize: 16),
                        )),
                    SizedBox(height: 5),

                    // Phone Number
                    Obx(() => Text(
                          controller.phone.value.isNotEmpty
                              ? controller.phone.value
                              : "No Phone Number",
                          style: TextStyle(fontSize: 16),
                        )),
                    SizedBox(height: 10),

                    // Bio
                    Obx(() => Text(
                          controller.bio.value.isNotEmpty
                              ? controller.bio.value
                              : "No Bio",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(height: 20),
                  ],
                ),

                // Skills Section
                Row(
                  children: [
                    Text(
                      "Skills/Interests",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Obx(() => Wrap(
                      spacing: 8.0,
                      children: controller.skills.isNotEmpty
                          ? controller.skills
                              .map((skill) => Chip(
                                    label: Text(skill),
                                  ))
                              .toList()
                          : [Text("No Skills Added")],
                    )),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Social Media",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Obx(() => Column(
                      children: controller.socialMediaLinks.isNotEmpty
                          ? controller.socialMediaLinks.entries.map((entry) {
                              return ListTile(
                                leading: getSocialMediaIcon(entry.key),
                                title: Text(entry.key),
                                subtitle: Text(entry.value),
                              );
                            }).toList()
                          : [Text("No Social Media Links")],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get FontAwesome icon based on social media platform
  Widget getSocialMediaIcon(String platform) {
    switch (platform) {
      case 'LinkedIn':
        return FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue);
      case 'Twitter':
        return FaIcon(FontAwesomeIcons.twitter, color: Colors.lightBlue);
      case 'Facebook':
        return FaIcon(FontAwesomeIcons.facebook, color: Colors.blueAccent);
      default:
        return FaIcon(FontAwesomeIcons.globe);
    }
  }
}
