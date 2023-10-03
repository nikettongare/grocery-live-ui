import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app.dart';
import '../config/base_client.dart';
import '../views/dialogs/custom_snackbar.dart';
import '../views/dialogs/loading.dart';

class AuthController extends GetxController {
  bool isLoginView = true;

  void changeView() {
    unfocusAllNodes();
    isLoginView = !isLoginView;
    update();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  void unfocusAllNodes() {
    nameNode.unfocus();
    emailNode.unfocus();
    passwordNode.unfocus();
    confirmPasswordNode.unfocus();
  }

  void onSubmit() async {
    unfocusAllNodes();
    LoadingDialog.show();

    BaseClient client = BaseClient();
    final prefs = await SharedPreferences.getInstance();

    if (isLoginView) {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.back();
        CustomSnackBar.show("Warning", "All field are required!");

        return;
      }

      client
          .post(url: AppConfig.loginUser, payload: {
            "email": emailController.text,
            "password": passwordController.text
          })
          .then((value) async => {
                await prefs.setString('userData', jsonEncode(value)),
                Get.back(),
                Get.offAllNamed('/'),
              })
          .catchError((error) => {
                Get.back(),
                CustomSnackBar.show("Error", error.toString()),
              });
    } else {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          nameController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        Get.back();
        CustomSnackBar.show("warning", "All field are required !");
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        Get.back();
        CustomSnackBar.show("warning", "Password not match !");
        return;
      }

      client
          .post(url: AppConfig.createUser, payload: {
            "name": nameController.text,
            "email": emailController.text,
            "password": passwordController.text
          })
          .then((value) => {
                Get.back(),
                isLoginView = true,
                update(),
              })
          .catchError((error) => {
                Get.back(),
                CustomSnackBar.show("Error", error.toString()),
              });
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
  }
}
