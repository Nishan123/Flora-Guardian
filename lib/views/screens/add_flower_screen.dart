import 'package:firebase_auth/firebase_auth.dart';
import 'package:flora_guardian/controllers/flower_controller.dart';
import 'package:flora_guardian/models/flower_model.dart';
import 'package:flora_guardian/views/custom_widgets/online_flowers_list.dart';
import 'package:flora_guardian/views/custom_widgets/search_bar_field.dart';
import 'package:flutter/material.dart';

class AddFlowerScreen extends StatefulWidget {
  const AddFlowerScreen({super.key});

  @override
  State<AddFlowerScreen> createState() => _AddFlowerScreenState();
}

class _AddFlowerScreenState extends State<AddFlowerScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlowerController _flowerController = FlowerController();
  List<FlowerModel> flowers = [];
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();

  bool isLoading = true;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadFlowers();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!isLoadingMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreFlowers();
    }
  }

  Future<void> _loadFlowers() async {
    try {
      final fetchedFlowers = await _flowerController.fetchFlowers();
      setState(() {
        flowers = fetchedFlowers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreFlowers() async {
    if (isLoadingMore || !_flowerController.hasMore) return;
    setState(() {
      isLoadingMore = true;
    });
    try {
      final newFlowers = await _flowerController.fetchFlowers();
      setState(() {
        flowers.addAll(newFlowers);
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

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
                controller: _scrollController,
                itemCount: flowers.length + (_flowerController.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == flowers.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final flower = flowers[index];
                  final String imageUrl =
                      flower.defaultImage?.thumbnail ??
                      flower.defaultImage?.regularUrl ??
                      flower.defaultImage?.smallUrl ??
                      'https://via.placeholder.com/150?text=No+Image';

                  return OnlineFlowersList(
                    onListTap: () {},
                    onAddTap: () {
                      FlowerController().saveFlowerToDb(index, flower, uid);
                    },
                    flowerImage: imageUrl,
                    commonName:
                        flower.commonName.isNotEmpty
                            ? flower.commonName
                            : 'Unknown',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
