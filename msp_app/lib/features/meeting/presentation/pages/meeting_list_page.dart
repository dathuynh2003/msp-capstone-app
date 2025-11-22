import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/meeting_card.dart';
import '../providers/meeting_provider.dart';
import '../../data/models/get_meeting_response.dart';
import '../widgets/meeting_filter_sheet.dart';
import '../widgets/meeting_filter_bar.dart';

// ---- Palette ----
const Color orangeDeep = Color(0xFFFFA463);
const Color orangeGold = Color(0xFFFDF0D2);
const Color whiteGray = Color(0xFFF9F4EE);

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: orangeDeep,
        elevation: 0,
        title: Text(
          'Danh sách cuộc họp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 22,
          tooltip: "Trở về",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: 'Lọc cuộc họp',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => MeetingFilterSheet(
                  initStatus: selectedStatus,
                  initDate: selectedDate,
                  onStatus: (status) =>
                      ref.read(meetingStatusFilterProvider.notifier).state =
                          status,
                  onDate: (date) =>
                      ref.read(meetingDateFilterProvider.notifier).state = date,
                  onConfirm: () => Navigator.of(context).pop(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [whiteGray, orangeGold, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // FILTER BAR
              MeetingFilterBar(
                selectedStatus: selectedStatus,
                selectedDate: selectedDate,
                clearAll: () {
                  ref.read(meetingStatusFilterProvider.notifier).state = null;
                  ref.read(meetingDateFilterProvider.notifier).state = null;
                },
                clearStatus: () =>
                    ref.read(meetingStatusFilterProvider.notifier).state = null,
                clearDate: () =>
                    ref.read(meetingDateFilterProvider.notifier).state = null,
              ),
              Expanded(
                child: meetingsAsync.when(
                  data: (meetings) {
                    final filtered = meetings.where((m) {
                      final matchStatus =
                          selectedStatus == null ||
                          selectedStatus.isEmpty ||
                          m.status.toLowerCase() ==
                              selectedStatus.toLowerCase();
                      final matchDate =
                          selectedDate == null ||
                          (m.startTime.year == selectedDate.year &&
                              m.startTime.month == selectedDate.month &&
                              m.startTime.day == selectedDate.day);
                      return matchStatus && matchDate;
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          "Không có cuộc họp nào khớp bộ lọc",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.refresh(meetingListProvider(userId));
                      },
                      color: orangeDeep,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(height: 19),
                        padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
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

                          return MeetingCard(
                            meeting: m,
                            userId: userId,
                            startTimeStr: startTimeStr,
                            endTimeStr: endTimeStr,
                            dateStr: dateStr,
                            canJoin: canJoin,
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: orangeDeep),
                  ),
                  error: (err, _) => RefreshIndicator(
                    onRefresh: () async {
                      ref.refresh(meetingListProvider(userId));
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 220),
                        Center(
                          child: Text(
                            'Lỗi: $err',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
