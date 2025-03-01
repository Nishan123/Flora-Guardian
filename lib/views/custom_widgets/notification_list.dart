import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.only(bottom: 8,left: 14, right: 14),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(18),

      ),
      child: ListTile(
        leading: Icon(
          Icons.notifications_active_rounded,
          color: Colors.black,
          size: 32,
        ),
        title: Text(
          "Notification Title",
          style: TextStyle( fontSize: 20),
        ),
        subtitle: Text("notification subtitle", style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
