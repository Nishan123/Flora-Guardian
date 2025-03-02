import 'package:flora_guardian/controllers/user_controller.dart';
import 'package:flora_guardian/views/custom_widgets/flowers_list.dart';
import 'package:flora_guardian/views/custom_widgets/search_bar_field.dart';
import 'package:flora_guardian/views/screens/add_flower_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flora_guardian/controllers/flower_controller.dart';
import 'package:flora_guardian/models/flower_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final FlowerController _flowerController = FlowerController();
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddFlowerScreen()),
          );
        },
        label: Text(
          "Add a flower +",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      appBar: AppBar(
        title: const Text("Flora Guardian 🌻"),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.face, color: Colors.black, size: 40),
            itemBuilder:
                (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 10),
                        Text("Logout"),
                      ],
                    ),
                  ),
                ],
            onSelected: (value) {
              if (value == 0) {
                UserController().logOut();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: SearchBarField(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search 'Rose'",
              controller: searchController,
            ),
          ),
          // Wrapping GridView.builder in Expanded to avoid unbounded height issues
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<Stream<List<FlowerModel>>>(
                      future: _flowerController.loadFlowersFromFirebase(
                        userUid,
                      ),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${asyncSnapshot.error}'),
                          );
                        }

                        if (!asyncSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return StreamBuilder<List<FlowerModel>>(
                          stream: asyncSnapshot.data,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final flowers = snapshot.data ?? [];

                            if (flowers.isEmpty) {
                              return const Center(
                                child: Text('No flowers added yet'),
                              );
                            }

                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.8,
                                  ),
                              itemCount: flowers.length,
                              itemBuilder: (context, index) {
                                final flower = flowers[index];
                                return FlowersList(
                                  commonName: flower.commonName,
                                  flowerImage:
                                      flower.defaultImage?.mediumUrl ?? '',
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
