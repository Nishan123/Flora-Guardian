import 'package:flora_guardian/views/custom_widgets/flowers_list.dart';
import 'package:flora_guardian/views/custom_widgets/search_bar_field.dart';
import 'package:flora_guardian/views/screens/add_flower_screen.dart';
import 'package:flora_guardian/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController searchController = TextEditingController();

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.8,
                ),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return FlowersList();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
