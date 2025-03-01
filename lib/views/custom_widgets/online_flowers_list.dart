import 'package:flutter/material.dart';

class OnlineFlowersList extends StatelessWidget {
  const OnlineFlowersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.image,color: Colors.white,size:40,),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Flower name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "Flower description",
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: TextButton(
              onPressed: () {},
              child: Row(children: [Text("Add"), Icon(Icons.add, size: 30)]),
            ),
          ),
        ],
      ),
    );
  }
}
