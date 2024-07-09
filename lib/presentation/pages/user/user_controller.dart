import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to {
    if (!Get.isRegistered<UserController>()) {
      Get.lazyPut<UserController>(() => UserController());
    }
    return Get.find<UserController>();
  }

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() {
    // Fetch user data from the API or local storage
    // Simulating with dummy data
    userName.value = 'John Doe';
    userEmail.value = 'john.doe@example.com';
    userPhone.value = '+1234567890';
  }

  void updateUserProfile(String name, String email, String phone) {
    // Call API to update user profile
    userName.value = name;
    userEmail.value = email;
    userPhone.value = phone;
  }
}
