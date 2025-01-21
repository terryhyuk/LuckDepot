// lib/view/widgets/stat_card_widget.dart
import 'package:flutter/material.dart';
import 'package:lucky_depot/model/stat_card.dart';

class StatCardWidget extends StatelessWidget {
  final StatCard data;

  const StatCardWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (data.subtitle.isNotEmpty)
              Text(
                data.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey
                ),
              )
          ],
        ),
      ),
    );
  }
}
