import 'package:firebase_auth/firebase_auth.dart';
import 'package:flora_guardian/controllers/user_controller.dart';
import 'package:flora_guardian/models/user_model.dart';
import 'package:flora_guardian/views/custom_widgets/custom_button.dart';
import 'package:flora_guardian/views/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isObscure = true;
  bool isSignup = false;

  void onPressedSuffix() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      child: Image.asset(
                        "assets/images/background.jpeg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: mq.height * 0.8,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: mq.height * 0.25,
                          width: mq.width,
                          child: const Center(
                            child: Text(
                              "🌼 Flora Guardian 🌻",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                "Welcome, Signup to register.",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomTextfield(
                                textColor: Colors.white,
                                hintText: "Email",
                                controller: emailController,
                                obscureText: false,
                                textInputType: TextInputType.emailAddress,
                                suffixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              CustomTextfield(
                                textColor: Colors.white,
                                hintText: "Username",
                                controller: usernameController,
                                obscureText: false,
                                textInputType: TextInputType.text,
                              ),
                              CustomTextfield(
                                textColor: Colors.white,
                                hintText: "Password",
                                controller: passwordController,
                                obscureText: true,
                                textInputType: TextInputType.visiblePassword,
                                suffixIcon: const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: CustomButton(
                            backgroundColor: Colors.black,
                            onPressed: () async {
                              // Validate inputs
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  usernameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All fields are required'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(emailController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a valid email'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Show loading indicator
                              setState(() {
                                isSignup = true;
                              });

                              User? user = await UserController().signup(
                                emailController.text,
                                passwordController.text,
                              );

                              if (user != null) {
                                UserModel userModel = UserModel(
                                  uid: user.uid,
                                  userName: usernameController.text,
                                  email: emailController.text,
                                );
                                await UserController().saveUseToDb(userModel);
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to create account'),
                                  ),
                                );
                              }

                              setState(() {
                                isSignup = false;
                              });
                            },
                            text: "Signup",
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Login in",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              const Text(
                "Guardian of the Garden",
                style: TextStyle(fontSize: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
