import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../component/custom_textformfield.dart';
import '../controller/profile_controller.dart';
import 'profile_display.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final ProfileController controller = Get.put(ProfileController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController socialMediaController = TextEditingController();

  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController.text = controller.name.value;
    emailController.text = controller.email.value;
    phoneController.text = controller.phone.value;
    bioController.text = controller.bio.value;

    nameController.addListener(() {
      controller.name.value = nameController.text;
    });
    emailController.addListener(() {
      controller.email.value = emailController.text;
    });
    phoneController.addListener(() {
      controller.phone.value = phoneController.text;
    });
    bioController.addListener(() {
      controller.bio.value = bioController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Edit Profile',
        ),
        actions: [
          Obx(() => Row(
                children: [
                  FaIcon(
                    controller.isDarkMode.value
                        ? FontAwesomeIcons.moon
                        : FontAwesomeIcons.solidSun,
                    color: isDarkMode ? Colors.white : Colors.yellow,
                  ),
                  Switch(
                    value: controller.isDarkMode.value,
                    onChanged: (value) => controller.toggleTheme(),
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ],
              )),
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
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Obx(() => Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                isDarkMode ? Colors.black : Colors.white,
                            radius: 50,
                            backgroundImage:
                                controller.profilePicture.value.isNotEmpty
                                    ? FileImage(
                                        File(controller.profilePicture.value))
                                    : AssetImage('assets/images/profile.jpeg')
                                        as ImageProvider,
                          ),
                          InkWell(
                              onTap: controller.pickImage,
                              child: FaIcon(FontAwesomeIcons.camera)),
                        ],
                      )),
                  SizedBox(height: 20),
                  CustomTextField(
                    labelText: "Name",
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    hintText: '',
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Name can't be empty";
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    hintText: '',
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Email can't be empty";
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: phoneController,
                    labelText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    hintText: '',
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Phone number can't be empty";
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: bioController,
                    labelText: 'Bio',
                    keyboardType: TextInputType.text,
                    hintText: '',
                    maxLines: 3,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Bio can't be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Skills/Interests",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Wrap(
                    spacing: 5,
                    children: controller.skills
                        .map((skill) => Chip(label: Text(skill)))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: CustomTextField(
                          keyboardType: TextInputType.text,
                          labelText: 'Add Skill',
                          hintText: '',
                          controller: skillController,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Skill can't be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      // Flexible(
                      //     child: TextButton(
                      //         onPressed: () {
                      //           controller.addSkill(skillController.text);
                      //         },
                      //         child: Text("Add")))
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Social Media Links",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  _buildSocialMediaLinkField('LinkedIn'),
                  SizedBox(height: 20),
                  _saveBtn(socialMediaController.text),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _saveBtn(platform) {
    return ElevatedButton(
      onPressed: () {
        if (key.currentState!.validate()) {
          key.currentState!.save();
          controller.saveProfile();
          controller.addSocialMediaLink(platform, socialMediaController.text);
          controller.addSkill(skillController.text);
          Get.to(() => ProfileDisplayPage());
          Get.snackbar(
            'Success',
            'Profile saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.canvasColor,
            colorText: Get.theme.snackBarTheme.actionTextColor,
          );
        } else {}
      },
      child: Text("Save Profile"),
    );
  }

  // Helper function to build social media link input fields
  Widget _buildSocialMediaLinkField(String platform) {
    final ProfileController controller = Get.find<ProfileController>();
    return Row(
      children: [
        // _getSocialIcon(platform),
        SizedBox(width: 10),
        // Expanded(
        //   child: Obx(
        //     () => CustomTextField(
        //       controller: socialMediaController,
        //       labelText: platform,
        //     ),
        //   ),
        // )
        Flexible(
          flex: 4,
          child: CustomTextField(
            keyboardType: TextInputType.text,
            labelText: 'Add Links',
            hintText: '',
            controller: socialMediaController,
            validator: (v) {
              if (v!.isEmpty) {
                return "Social media Links can't be empty";
              }
              return null;
            },
          ),
        ),
        // Flexible(
        //     child: TextButton(
        //         onPressed: () {
        //           controller.addSocialMediaLink(
        //               platform, socialMediaController.text);
        //         },
        //         child: Text("Add"))),
      ],
    );
  }

  // Helper function to get the correct icon for each platform
  Widget _getSocialIcon(String platform) {
    switch (platform) {
      case 'LinkedIn':
        return FaIcon(FontAwesomeIcons.linkedin);
      case 'Twitter':
        return FaIcon(FontAwesomeIcons.twitter);
      case 'Facebook':
        return FaIcon(FontAwesomeIcons.facebook);
      default:
        return FaIcon(FontAwesomeIcons.globe);
    }
  }
}
