import 'package:flutter/material.dart';
import '../models/clue_model.dart';

class ClueCard extends StatelessWidget {
  final Clue clue;
  final VoidCallback onTap;

  const ClueCard({
    super.key,
    required this.clue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(clue.title),
        subtitle: Text('時間：${clue.time} | 可信度：${clue.credibility}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
