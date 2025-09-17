import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(title: Text('Reminders')),
        SliverFillRemaining(child: Center(child: Text('Coming Soon!'))),
      ],
    );
  }
}
