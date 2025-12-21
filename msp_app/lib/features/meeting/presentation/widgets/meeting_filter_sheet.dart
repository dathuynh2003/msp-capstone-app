import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color orangeDeep = Color(0xFFFF5E13);
const Color orangeMid = Color(0xFFFFA463);

class MeetingFilterSheet extends StatefulWidget {
  final String? initStatus;
  final DateTime? initDate;
  final ValueChanged<String?> onStatus;
  final ValueChanged<DateTime?> onDate;
  final VoidCallback onConfirm;

  const MeetingFilterSheet({
    super.key,
    this.initStatus,
    this.initDate,
    required this.onStatus,
    required this.onDate,
    required this.onConfirm,
  });

  @override
  State<MeetingFilterSheet> createState() => _MeetingFilterSheetState();
}

class _MeetingFilterSheetState extends State<MeetingFilterSheet> {
  String? tempStatus;
  DateTime? tempDate;

  @override
  void initState() {
    super.initState();
    tempStatus = widget.initStatus;
    tempDate = widget.initDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header with drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: orangeMid.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune, color: orangeDeep, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Filter Meetings',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ✅ Status Filter
          Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: tempStatus,
                isExpanded: true,
                hint: Text(
                  'All Statuses',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: orangeDeep),
                items: ['Scheduled', 'Ongoing', 'Finished', 'Cancelled'].map((
                  s,
                ) {
                  return DropdownMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(s),
                          size: 18,
                          color: _getStatusColor(s),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          s,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => tempStatus = val),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ✅ Date Filter
          Text(
            'Date',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: tempDate ?? DateTime.now(),
                      firstDate: DateTime(2023, 1, 1),
                      lastDate: DateTime(2030, 12, 31),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: orangeDeep,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) setState(() => tempDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tempDate != null
                          ? orangeMid.withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: tempDate != null
                            ? orangeMid.withOpacity(0.5)
                            : Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: tempDate != null
                              ? orangeDeep
                              : Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tempDate != null
                                ? DateFormat('dd/MM/yyyy').format(tempDate!)
                                : 'Select date',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: tempDate != null
                                  ? Colors.black87
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (tempDate != null) ...[
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => setState(() => tempDate = null),
                  icon: const Icon(Icons.close, color: Colors.red),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 28),

          // ✅ Action Buttons
          Row(
            children: [
              // Clear button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      tempStatus = null;
                      tempDate = null;
                    });
                    widget.onStatus(null);
                    widget.onDate(null);
                    widget.onConfirm();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey[400]!, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.clear_all, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Clear',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Apply button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onStatus(tempStatus);
                    widget.onDate(tempDate);
                    widget.onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeDeep,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
