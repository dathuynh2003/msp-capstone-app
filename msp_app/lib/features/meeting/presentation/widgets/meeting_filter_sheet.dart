import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lọc theo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 20),
          const Text(
            'Trạng thái:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          DropdownButton<String>(
            value: tempStatus,
            isExpanded: true,
            hint: const Text('Tất cả'),
            items: [
              'Scheduled',
              'Ongoing',
              'Finished',
              'Cancelled',
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (val) => setState(() => tempStatus = val),
          ),
          const SizedBox(height: 16),
          const Text('Ngày:', style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 17),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tempDate != null
                          ? DateFormat('dd/MM/yyyy').format(tempDate!)
                          : 'Chọn ngày',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: tempDate ?? DateTime.now(),
                      firstDate: DateTime(2023, 1, 1),
                      lastDate: DateTime(2030, 12, 31),
                    );
                    if (picked != null) setState(() => tempDate = picked);
                  },
                ),
              ),
              if (tempDate != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(22, 36),
                    ),
                    child: const Text(
                      'X',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => setState(() => tempDate = null),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onStatus(tempStatus);
                    widget.onDate(tempDate);
                    widget.onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
