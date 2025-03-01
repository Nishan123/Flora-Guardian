import 'package:flutter/material.dart';

class FlowersList extends StatelessWidget {
  const FlowersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      child: Center(child: Icon(Icons.image, color: Colors.white, size: 80)),
    );
  }
}
