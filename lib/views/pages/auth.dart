import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/auth_heading.dart';
import '../components/auth_botton.dart';
import '../../controllers/auth_controller.dart';
import '../components/text_field_decoration.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: GetBuilder<AuthController>(
                init: AuthController(),
                builder: (loginController) {
                  return GestureDetector(
                    onTap: () {
                      loginController.unfocusAllNodes();
                    },
                    child: SingleChildScrollView(
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 80,
                              ),
                              headingText(
                                  text: (loginController.isLoginView)
                                      ? "Please sign in."
                                      : "Please register."),
                              const SizedBox(
                                height: 40,
                              ),
                              Visibility(
                                visible: !loginController.isLoginView,
                                child: TextField(
                                  controller: loginController.nameController,
                                  focusNode: loginController.nameNode,
                                  onEditingComplete: () =>
                                      loginController.emailNode.requestFocus(),
                                  decoration: textFieldDecoration(hint: "Name"),
                                ),
                              ),
                              Visibility(
                                visible: !loginController.isLoginView,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              TextField(
                                controller: loginController.emailController,
                                focusNode: loginController.emailNode,
                                onEditingComplete: () =>
                                    (loginController.isLoginView)
                                        ? loginController.passwordNode
                                            .requestFocus()
                                        : loginController.passwordNode
                                            .requestFocus(),
                                decoration: textFieldDecoration(hint: "Email"),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                obscureText: true,
                                focusNode: loginController.passwordNode,
                                onEditingComplete: () =>
                                    (loginController.isLoginView)
                                        ? loginController.onSubmit()
                                        : loginController.confirmPasswordNode
                                            .requestFocus(),
                                controller: loginController.passwordController,
                                decoration:
                                    textFieldDecoration(hint: "Password"),
                              ),
                              Visibility(
                                visible: !loginController.isLoginView,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              Visibility(
                                visible: !loginController.isLoginView,
                                child: TextField(
                                  obscureText: true,
                                  focusNode:
                                      loginController.confirmPasswordNode,
                                  controller:
                                      loginController.confirmPasswordController,
                                  onEditingComplete: () {
                                    if (!loginController.isLoginView) {
                                      loginController.onSubmit();
                                    }
                                  },
                                  decoration: textFieldDecoration(
                                      hint: "Confirm Password"),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              customButton(
                                name: (loginController.isLoginView)
                                    ? "Sign In"
                                    : "Register",
                                onPressed: () => loginController.onSubmit(),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: bottomButtonText(
                                  type: (loginController.isLoginView)
                                      ? "Not have account ? Register"
                                      : "Have an account? Sign In",
                                  onPressed: () => loginController.changeView(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })));
  }
}
