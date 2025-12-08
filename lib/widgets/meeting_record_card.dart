import 'dart:io';
import 'package:flutter/material.dart';
import '../models/meeting_record.dart';
import '../models/person.dart';
import '../l10n/l10n.dart';

class MeetingRecordCard extends StatelessWidget {
  final MeetingRecord record;
  final Person? person;
  final VoidCallback? onTap;

  const MeetingRecordCard({
    super.key,
    required this.record,
    this.person,
    this.onTap,
  });

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final displayName = person?.name ?? S.of(context)!.nameNotRegistered;
    final initials = person?.initials ?? '？';
    final avatarColor = person?.avatarColor ?? '#4D6FFF';
    final photoPath = person?.photoPath;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: photoPath != null
                    ? Colors.transparent
                    : _parseColor(avatarColor).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: photoPath != null
                    ? Border.all(
                        color: _parseColor(avatarColor),
                        width: 2,
                      )
                    : null,
              ),
              child: photoPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        File(photoPath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: _parseColor(avatarColor),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: _parseColor(avatarColor),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        record.formattedDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  if (record.location != null && record.location!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      record.location!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                  if (person?.tags != null && person!.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: person!.tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
