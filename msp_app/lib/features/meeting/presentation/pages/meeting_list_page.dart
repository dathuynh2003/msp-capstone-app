import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:msp_app/features/meeting/presentation/pages/pre_join_meeting_page.dart';
import '../providers/meeting_provider.dart';
import '../../data/models/get_meeting_response.dart';

class MeetingListPage extends ConsumerWidget {
  final String userId;

  const MeetingListPage({super.key, required this.userId});

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('HH:mm').format(time);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  bool _canJoin(GetMeetingResponse m) {
    final now = DateTime.now();
    if ((m.status.toLowerCase() == 'scheduled' ||
        m.status.toLowerCase() == 'ongoing')) {
      final diff = m.startTime.difference(now).inMinutes;
      return diff <= 30;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingsAsync = ref.watch(meetingListProvider(userId));
    final selectedStatus = ref.watch(meetingStatusFilterProvider);
    final selectedDate = ref.watch(meetingDateFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách cuộc họp'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.orangeAccent),
            tooltip: 'Lọc cuộc họp',
            onPressed: () {
              ref.read(showMeetingFilterProvider.notifier).state = true;
              // Show BottomSheet/modal filter
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) {
                  String? tempStatus = selectedStatus;
                  DateTime? tempDate = selectedDate;
                  return StatefulBuilder(
                    builder: (context, setState) => _buildFilterSheet(
                      context,
                      ref,
                      tempStatus,
                      tempDate,
                      (val) => setState(() => tempStatus = val),
                      (val) => setState(() => tempDate = val),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: meetingsAsync.when(
              data: (meetings) {
                // Lọc dữ liệu theo trạng thái và ngày
                final filtered = meetings.where((m) {
                  final matchStatus =
                      selectedStatus == null ||
                      selectedStatus.isEmpty ||
                      m.status.toLowerCase() == selectedStatus.toLowerCase();
                  final matchDate =
                      selectedDate == null ||
                      (m.startTime.year == selectedDate.year &&
                          m.startTime.month == selectedDate.month &&
                          m.startTime.day == selectedDate.day);
                  return matchStatus && matchDate;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text("Không có cuộc họp nào khớp bộ lọc"),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(meetingListProvider(userId));
                  },
                  child: ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final m = filtered[index];
                      final startTimeStr = _formatTime(
                        m.startTime.add(const Duration(hours: 7)),
                      );
                      final endTimeStr = m.endTime != null
                          ? _formatTime(
                              m.endTime!.add(const Duration(hours: 7)),
                            )
                          : "chưa xác định";
                      final dateStr = _formatDate(m.startTime);
                      final canJoin = _canJoin(m);

                      return Stack(
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Đệm chip status phía trên cùng phải
                                  const SizedBox(height: 8),
                                  // Label + Title
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Tiêu đề:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Text(
                                                m.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 60),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Label + Mô tả
                                  Text(
                                    'Mô tả: ${m.description?.isNotEmpty ?? false ? m.description! : '(Không có mô tả)'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        "Ngày diễn ra:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        " $dateStr",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_outlined,
                                        size: 16,
                                        color: Colors.purple,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        "Thời gian:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        " $startTimeStr - $endTimeStr",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 6,
                                    children: [
                                      _iconLabel(
                                        Icons.folder,
                                        "Dự án: ${m.projectName}",
                                        Colors.orange.shade400,
                                      ),
                                      if (m.milestoneName != null &&
                                          m.milestoneName!.isNotEmpty)
                                        _iconLabel(
                                          Icons.flag,
                                          "Milestone: ${m.milestoneName}",
                                          Colors.red.shade300,
                                        ),
                                      _iconLabel(
                                        Icons.people_alt,
                                        "Tham gia: ${m.attendees.length} người",
                                        Colors.green,
                                      ),
                                    ],
                                  ),
                                  if (canJoin) ...[
                                    const SizedBox(height: 18),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.video_call_rounded,
                                        ),
                                        label: const Text('Tham gia'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PreJoinMeetingPage(
                                                    meetingId: m.id,
                                                    userId:
                                                        userId, // hoặc lấy từ local user đang đăng nhập
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          // Chip status góc trên phải
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Chip(
                              label: Text(
                                m.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              backgroundColor: _getStatusColor(m.status),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(meetingListProvider(userId));
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 200),
                    Center(child: Text('Lỗi: $err')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconLabel(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildFilterSheet(
    BuildContext context,
    WidgetRef ref,
    String? tempStatus,
    DateTime? tempDate,
    Function(String?) onStatusChange,
    Function(DateTime?) onDateChange,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_alt_rounded,
                color: Colors.deepOrange,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                "Bộ lọc cuộc họp",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String?>(
            value: tempStatus,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: "Trạng thái",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(
                  "Tất cả",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...["Scheduled", "Ongoing", "Finished", "Cancelled"].map(
                (status) => DropdownMenuItem(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onStatusChange,
          ),
          const SizedBox(height: 14),
          InputDecorator(
            decoration: InputDecoration(
              labelText: "Ngày",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: InkWell(
              onTap: () async {
                final now = DateTime.now();
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: tempDate ?? now,
                  firstDate: DateTime(2000),
                  lastDate: now.add(Duration(days: 366)),
                );
                if (pickedDate != null) {
                  onDateChange(pickedDate);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.date_range, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tempDate != null
                          ? DateFormat("dd/MM/yyyy").format(tempDate)
                          : "Chọn ngày",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  if (tempDate != null)
                    GestureDetector(
                      onTap: () => onDateChange(null),
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.done),
            label: Text("Áp dụng bộ lọc"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              // Áp dụng filter lên Provider
              ref.read(meetingDateFilterProvider.notifier).state = tempDate;
              ref.read(meetingStatusFilterProvider.notifier).state = tempStatus;
              Navigator.pop(context);
            },
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
}
