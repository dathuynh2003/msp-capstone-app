import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color orangeDeep = Color(0xFFFF5E13);
const Color orangeMid = Color(0xFFFFA463);

class MeetingFilterBar extends StatelessWidget {
  final String? selectedStatus;
  final DateTime? selectedDate;
  final VoidCallback clearAll;
  final VoidCallback clearStatus;
  final VoidCallback clearDate;

  const MeetingFilterBar({
    super.key,
    this.selectedStatus,
    this.selectedDate,
    required this.clearAll,
    required this.clearStatus,
    required this.clearDate,
  });

  @override
  Widget build(BuildContext context) {
    if ((selectedStatus?.isEmpty ?? true) && selectedDate == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: orangeMid.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: orangeMid.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt, color: orangeDeep, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if ((selectedStatus?.isNotEmpty ?? false) &&
                    selectedStatus != null)
                  _FilterChip(
                    label: selectedStatus!,
                    color: _getStatusColor(selectedStatus!),
                    icon: _getStatusIcon(selectedStatus!),
                    onClear: clearStatus,
                  ),
                if (selectedDate != null)
                  _FilterChip(
                    label: DateFormat('dd/MM/yyyy').format(selectedDate!),
                    color: Colors.blue,
                    icon: Icons.calendar_today,
                    onClear: clearDate,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: clearAll,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.clear_all, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    const Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.orange;
      case "ongoing":
        return Colors.blue;
      case "finished":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Icons.schedule;
      case "ongoing":
        return Icons.play_circle_filled;
      case "finished":
        return Icons.check_circle;
      case "cancelled":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onClear;

  const _FilterChip({
    required this.label,
    required this.color,
    required this.icon,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onClear,
            borderRadius: BorderRadius.circular(10),
            child: Icon(Icons.close, size: 16, color: color),
          ),
        ],
      ),
    );
  }
}
