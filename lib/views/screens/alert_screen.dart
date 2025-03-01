import 'package:flora_guardian/views/custom_widgets/notification_list.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 20,

          itemBuilder: (context, index) {
            return NotificationList();
          },
        ),
      ),
    );
  }
}
