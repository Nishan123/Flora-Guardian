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
        child: Column(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.asset(
                      "assets/images/background.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: mq.height * 0.25,
                        width: mq.width,
                        child: Center(
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
                              hintText: "Username",
                              controller: usernameController,
                              obscureText: false,
                              textInputType: TextInputType.text,
                            ),
                            CustomTextfield(
                              hintText: "Password",
                              controller: passwordController,
                              obscureText: true,
                              textInputType: TextInputType.visiblePassword,
                              suffixIcon: const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          onPressed: () {},
                          text: "Signup",
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Login in",
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text("Guardian of the Garden", style: TextStyle(fontSize: 26)),
          ],
        ),
      ),
    );
  }
}
