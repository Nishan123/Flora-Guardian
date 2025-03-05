import 'package:firebase_auth/firebase_auth.dart';
import 'package:flora_guardian/controllers/flower_controller.dart';
import 'package:flora_guardian/models/flower_model.dart';
import 'package:flora_guardian/views/custom_widgets/online_flowers_list.dart';
import 'package:flora_guardian/views/custom_widgets/search_bar_field.dart';
import 'package:flora_guardian/views/screens/flower_info_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:random_string/random_string.dart';

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
  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadFlowers();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
        flowers.clear();
        _flowerController.reset();
        isLoading = true;
      });
      _loadFlowers();
    });
  }

  Future<void> _loadFlowers() async {
    try {
      final fetchedFlowers = await _flowerController.fetchFlowers(
        query: searchQuery,
      );
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
      final newFlowers = await _flowerController.fetchFlowers(
        query: searchQuery,
      );
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
              onChanged: _onSearchChanged,
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        flowers.length + (_flowerController.hasMore ? 1 : 0),
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
                        onListTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => FlowerInfoScreen(
                                    image:
                                        flower.defaultImage?.mediumUrl ??
                                        flower.defaultImage?.regularUrl ??
                                        flower.defaultImage?.smallUrl ??
                                        'https://via.placeholder.com/150?text=No+Image',
                                    flowerName: flower.commonName,
                                    sunlight:
                                        flower.sunlight.isNotEmpty
                                            ? flower.sunlight[0]
                                            : 'Unknown',
                                    wateringCycle: flower.watering,
                                    scientifcName:
                                        flower.scientificName.isNotEmpty
                                            ? flower.scientificName[0]
                                            : 'Unknown',
                                    cycle: flower.cycle,
                                  ),
                            ),
                          );
                        },
                        onAddTap: () async {
                          String id = randomAlphaNumeric(6);
                          try {
                            bool success = await FlowerController()
                                .saveFlowerToDb(id, flower, uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Flower added to profile'
                                      : 'This flower is already in your profile',
                                ),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height - 100,
                                  left: 20,
                                  right: 20,
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error adding flower: ${e.toString()}',
                                ),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height - 100,
                                  left: 20,
                                  right: 20,
                                ),
                              ),
                            );
                          }
                        },
                        flowerImage: imageUrl,
                        commonName:
                            flower.commonName.isNotEmpty
                                ? flower.commonName
                                : 'Unknown',
                        scientificName:
                            flower.scientificName.isNotEmpty
                                ? flower.scientificName[0]
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
