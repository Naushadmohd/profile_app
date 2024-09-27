import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var bio = ''.obs;
  var profilePicture = ''.obs;
  var skills = <String>[].obs;
  var socialMediaLinks = <String, String>{}.obs;
  var isDarkMode = false.obs;

  Box<ProfileModel>? profileBox;

  @override
  void onInit() {
    super.onInit();
    profileBox = Hive.box<ProfileModel>('profileBox');
    loadProfile();
  }

  void loadProfile() {
    var profile = profileBox?.get(0);
    if (profile != null) {
      name.value = profile.name ?? '';
      email.value = profile.email ?? '';
      phone.value = profile.phone ?? '';
      bio.value = profile.bio ?? '';
      profilePicture.value = profile.profilePicture ?? '';
      skills.value = profile.skills ?? [];
      socialMediaLinks.value = profile.socialMediaLinks ?? {};
    }
  }

  Future<void> saveProfile() async {
    try {
      var profile = ProfileModel(
        name: name.value,
        email: email.value,
        phone: phone.value,
        bio: bio.value,
        profilePicture: profilePicture.value,
        skills: skills.toList(),
        socialMediaLinks: socialMediaLinks,
      );
      await profileBox?.put(0, profile);
    } catch (e) {
      print(e);
    }
  }

  void addSkill(String skill) {
    if (skill.isNotEmpty) {
      skills.add(skill);
      saveProfile();
    }
  }

  void addSocialMediaLink(String platform, String url) {
    if (url.isNotEmpty) {
      socialMediaLinks[platform] = url;
      saveProfile();
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profilePicture.value = pickedFile.path;
        saveProfile();
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.cardColor,
          colorText: Get.theme.snackBarTheme.actionTextColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.cardColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
