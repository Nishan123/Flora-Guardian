import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flora_guardian/models/flower_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlowerController {
  final _db = FirebaseFirestore.instance;

  int _currentPage = 1;
  bool _hasMore = true;

  // load flowers from API
  Future<List<FlowerModel>> fetchFlowers({String? query}) async {
    if (!_hasMore) return [];

    try {
      String baseUrl = 'https://perenual.com/api/species-list?key=sk-LOGX67c4032bc67278915&page=$_currentPage';
      if (query != null && query.isNotEmpty) {
        baseUrl = '$baseUrl&q=${Uri.encodeComponent(query)}';
      }
      
      final url = Uri.parse(baseUrl);
      debugPrint('Fetching URL: $url'); // Add this for debugging

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> flowersData = data['data'];

        // Check if we've reached the last page
        if (flowersData.isEmpty) {
          _hasMore = false;
          return [];
        }

        _currentPage++;
        return flowersData
            .map((flower) => FlowerModel.fromJson(flower))
            .toList();
      } else {
        debugPrint('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load flowers');
      }
    } catch (e) {
      debugPrint('Error fetching flowers: $e');
      throw Exception('Error fetching flowers: $e');
    }
  }

  void reset() {
    _currentPage = 1;
    _hasMore = true;
  }

  bool get hasMore => _hasMore;

  // save flowers to database
  Future<void> saveFlowerToDb(
    int id,
    FlowerModel flower,
    String userUid,
  ) async {
    try {
      Map<String, dynamic> flowerData = flower.toJson();
      flowerData['userId'] = userUid; // Add userId to the map
      await _db.collection("flowers").doc(id.toString()).set(flowerData);
    } catch (e) {
      debugPrint("Failed to save flower: ${e.toString()}");
    }
  }

  Future<Stream<List<FlowerModel>>> loadFlowersFromFirebase(
    String userUid,
  ) async {
    try {
      return _db
          .collection("flowers")
          .where("userId", isEqualTo: userUid)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => FlowerModel.fromJson(doc.data()))
                    .toList(),
          );
    } catch (e) {
      debugPrint("Error loading flowers: ${e.toString()}");
      throw Exception('Error loading flowers: $e');
    }
  }
}
