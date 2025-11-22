import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          if ((selectedStatus?.isNotEmpty ?? false) && selectedStatus != null)
            _FilterChip(label: selectedStatus!, onClear: clearStatus),
          if (selectedDate != null)
            _FilterChip(
              label: DateFormat('dd/MM/yyyy').format(selectedDate!),
              onClear: clearDate,
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Bỏ lọc',
            onPressed: clearAll,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onClear;
  const _FilterChip({required this.label, required this.onClear});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 13)),
        backgroundColor: Colors.orange.shade50,
        deleteIcon: const Icon(Icons.close, size: 15),
        onDeleted: onClear,
      ),
    );
  }
}
