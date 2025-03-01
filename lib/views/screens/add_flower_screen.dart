import 'package:flora_guardian/views/custom_widgets/online_flowers_list.dart';
import 'package:flora_guardian/views/custom_widgets/search_bar_field.dart';
import 'package:flutter/material.dart';

class AddFlowerScreen extends StatelessWidget {
  AddFlowerScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add new flowers 🌻",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.face, color: Colors.black, size: 40),
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
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  return OnlineFlowersList();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
