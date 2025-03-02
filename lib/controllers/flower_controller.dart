import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flora_guardian/models/flower_model.dart';

class FlowerController {
  int _currentPage = 1;
  bool _hasMore = true;

  Future<List<FlowerModel>> fetchFlowers() async {
    if (!_hasMore) return [];

    try {
      final url = Uri.parse(
        'https://perenual.com/api/species-list?key=sk-LOGX67c4032bc67278915&page=$_currentPage',
      );

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
        throw Exception('Failed to load flowers');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching flowers: $e');
    }
  }

  void reset() {
    _currentPage = 1;
    _hasMore = true;
  }

  bool get hasMore => _hasMore;
}
