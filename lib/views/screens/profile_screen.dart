import 'package:flora_guardian/views/custom_widgets/custom_button.dart';
import 'package:flora_guardian/views/custom_widgets/profile_info.dart';
import 'package:flora_guardian/views/custom_widgets/profile_text_field.dart';
import 'package:flora_guardian/views/screens/edit_profile_screen.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:flora_guardian/controllers/user_controller.dart';
import 'package:flora_guardian/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController _userController = UserController();
  Future<UserModel?>? _userDataFuture; // Make nullable

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    try {
      if (_userController.getCurrentUser().isNotEmpty) {
        _userDataFuture = _userController.getUserData();
      }
    } catch (e) {
      debugPrint('User not authenticated: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.face, color: Colors.black, size: 40),
          ),
        ],
      ),
      body: SafeArea(
        child:
            _userDataFuture == null
                ? const Center(child: Text('Please login to view profile'))
                : FutureBuilder<UserModel?>(
                  future: _userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final userData = snapshot.data;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileInfo(user: userData),
                          Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ProfileTextField(
                                  hintText: "Username",
                                  text: userData?.userName ?? "Not available",
                                  enabled: false,
                                ),
                                ProfileTextField(
                                  hintText: "Email",
                                  text: userData?.email ?? "Not available",
                                  enabled: false,
                                ),
                                ProfileTextField(
                                  hintText: "Password",
                                  text: "********",
                                  enabled: false,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: CustomButton(
                              backgroundColor: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            EditProfileScreen(user: userData),
                                  ),
                                ).then(
                                  (_) => setState(() {
                                    _initializeUserData();
                                  }),
                                );
                              },
                              text: "Edit Profile",
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
