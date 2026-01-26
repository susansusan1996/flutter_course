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
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Suspect avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: suspect.gender == '男'
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.pink.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Center(
                  child: Icon(
                    suspect.gender == '男' ? Icons.person : Icons.person_outline,
                    size: 40,
                    color: suspect.gender == '男' ? Colors.blue : Colors.pink,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Suspect info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          suspect.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${suspect.age}歲',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suspect.occupation,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 16,
                          color: canInterrogate ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '已訊問：$interrogationCount/3',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: canInterrogate ? Colors.green : Colors.red,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                canInterrogate ? Icons.arrow_forward_ios : Icons.lock,
                size: 20,
                color: canInterrogate 
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
