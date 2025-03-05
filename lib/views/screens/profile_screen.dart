import 'package:flora_guardian/views/custom_widgets/custom_button.dart';
import 'package:flora_guardian/views/custom_widgets/profile_info.dart';
import 'package:flora_guardian/views/custom_widgets/profile_text_field.dart';
import 'package:flora_guardian/views/screens/edit_profile_screen.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:flora_guardian/controllers/user_controller.dart';
import 'package:flora_guardian/models/user_model.dart';
import 'package:flora_guardian/services/profile_cache_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController _userController = UserController();
  final ProfileCacheService _profileCache = ProfileCacheService();
  Future<UserModel?>? _userDataFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      if (_userController.getCurrentUser().isNotEmpty) {
        final cachedUser = _profileCache.getCachedUser();
        if (cachedUser != null) {
          setState(() => _userDataFuture = Future.value(cachedUser));
          _refreshUserDataInBackground();
        } else {
          _loadFreshUserData();
        }
      }
    } catch (e) {
      debugPrint('User not authenticated: $e');
    }
  }

  Future<void> _refreshUserDataInBackground() async {
    try {
      final freshData = await _userController.getUserData();
      if (freshData != null) {
        _profileCache.cacheUser(freshData);
        if (mounted) {
          setState(() => _userDataFuture = Future.value(freshData));
        }
      }
    } catch (e) {
      debugPrint('Error refreshing user data: $e');
    }
  }

  Future<void> _loadFreshUserData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await _userController.getUserData();
      if (userData != null) {
        _profileCache.cacheUser(userData);
      }
      if (mounted) {
        setState(() {
          _userDataFuture = Future.value(userData);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('Error loading fresh user data: $e');
    }
  }

  Future<void> _refreshProfile() async {
    _profileCache.clearCache();
    await _loadFreshUserData();
  }

  Widget _buildProfileContent(UserModel? userData) {
    return RefreshIndicator(
      onRefresh: _refreshProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ProfileInfo(user: userData),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ProfileTextField(
                    text: userData?.userName ?? "Not available",
                    enabled: false,
                  ),
                  ProfileTextField(
                    text: userData?.email ?? "Not available",
                    enabled: false,
                  ),
                  const ProfileTextField(text: "********", enabled: false),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: CustomButton(
                backgroundColor: Colors.black,
                onPressed: () => _navigateToEditProfile(userData),
                text: "Edit Profile",
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProfile(UserModel? userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: userData),
      ),
    ).then((_) {
      _profileCache.clearCache();
      _initializeUserData();
    });
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
            onPressed: _refreshProfile,
            icon: const Icon(Icons.refresh),
          ),
          const Icon(Icons.face, color: Colors.black, size: 40),
        ],
      ),
      body: SafeArea(
        child:
            _userDataFuture == null
                ? const Center(child: Text('Please login to view profile'))
                : FutureBuilder<UserModel?>(
                  future: _userDataFuture,
                  builder: (context, snapshot) {
                    if (_isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${snapshot.error}'),
                            ElevatedButton(
                              onPressed: _refreshProfile,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return _buildProfileContent(snapshot.data);
                  },
                ),
      ),
    );
  }
}
