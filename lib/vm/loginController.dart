import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lucky_depot/view/page/dashboard.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var authToken = ''.obs;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and Password must be provided");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://port-0-luckydepot-m6q0n8sc55b3c20e.sel4.cloudtype.app/auth/login/email'),
        // Uri.parse('http://127.0.0.1:8000/auth/login/email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": email, "pw": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["Authorization"] != null) {
          authToken.value = data["Authorization"];
          Get.to(const Dashboard());
        } else {
          Get.snackbar("Error", "Invalid response from server");
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData["msg"] ?? "Login failed");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
