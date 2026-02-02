import 'package:flutter/material.dart';
import '../models/case_model.dart';

class CaseCard extends StatelessWidget {
  final Case caseItem;
  final bool isCompleted;
  final VoidCallback? onTap; // 改為可選

  const CaseCard({
    super.key,
    required this.caseItem,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0, // 第二章變暗
        child: ListTile(
          leading: CircleAvatar(
            child: isCompleted
                ? const Icon(Icons.check)
                : Text('${caseItem.id}'),
          ),
          title: Text(caseItem.title),
          subtitle: Text(caseItem.description),
          trailing: Icon(
            isDisabled ? Icons.lock : Icons.arrow_forward_ios,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
