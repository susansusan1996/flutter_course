import 'package:flutter/material.dart';
import '../models/suspect_model.dart';

class SuspectCard extends StatelessWidget {
  final Suspect suspect;
  final int interrogationCount;
  final bool canInterrogate;
  final VoidCallback onTap;

  const SuspectCard({
    super.key,
    required this.suspect,
    required this.interrogationCount,
    required this.canInterrogate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          suspect.gender == '男' ? Icons.person : Icons.person_outline,
        ),
        title: Text('${suspect.name} (${suspect.age}歲)'),
        subtitle: Text('${suspect.occupation} | 已訊問：$interrogationCount/2'),
        trailing: Icon(canInterrogate ? Icons.arrow_forward_ios : Icons.lock),
        onTap: onTap,
      ),
    );
  }
}
