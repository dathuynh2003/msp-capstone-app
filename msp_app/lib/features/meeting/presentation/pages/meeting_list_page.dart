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
const Color pastelCream = Color(0xFFFFF5ED);

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
      backgroundColor: pastelCream,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: orangeDeep,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.video_call,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Meeting List',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
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
            tooltip: "Back",
          ),
          actions: [
            // Filter button with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 26,
                  ),
                  tooltip: 'Filter meetings',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => MeetingFilterSheet(
                        initStatus: selectedStatus,
                        initDate: selectedDate,
                        onStatus: (status) =>
                            ref
                                    .read(meetingStatusFilterProvider.notifier)
                                    .state =
                                status,
                        onDate: (date) =>
                            ref.read(meetingDateFilterProvider.notifier).state =
                                date,
                        onConfirm: () => Navigator.of(context).pop(),
                      ),
                    );
                  },
                ),
                // Badge if filters are active
                if (selectedStatus != null || selectedDate != null)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
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

          // MEETING COUNT HEADER
          meetingsAsync.when(
            data: (meetings) {
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

              return Container(
                margin: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      orangeDeep.withOpacity(0.1),
                      orangeGold.withOpacity(0.3),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: orangeDeep.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: orangeDeep.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.event_note,
                        color: orangeDeep,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${filtered.length} ${filtered.length == 1 ? 'Meeting' : 'Meetings'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                          ),
                          if (selectedStatus != null || selectedDate != null)
                            Text(
                              'Filtered results',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Quick stats
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: orangeDeep,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Total: ${meetings.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // MEETINGS LIST
          Expanded(
            child: meetingsAsync.when(
              data: (meetings) {
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
                  return _buildEmptyState(
                    selectedStatus != null || selectedDate != null,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(meetingListProvider(userId));
                  },
                  color: orangeDeep,
                  child: ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    physics: const AlwaysScrollableScrollPhysics(),
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
                          : "not determined";
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
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: orangeDeep.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(
                        color: orangeDeep,
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Loading meetings...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              error: (err, _) => RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(meetingListProvider(userId));
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: [
                    const SizedBox(height: 120),
                    _buildErrorState(err.toString()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Empty state widget
  Widget _buildEmptyState(bool hasFilters) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: orangeDeep.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              hasFilters ? Icons.search_off : Icons.event_busy,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            hasFilters ? 'No Matches Found' : 'No Meetings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              hasFilters
                  ? 'Try adjusting your filters\nto see more meetings'
                  : 'No meetings scheduled yet.\nCheck back later!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          if (hasFilters) ...[
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [orangeDeep, orangeDeep.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: orangeDeep.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Clear filters callback would go here
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.clear_all, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Clear Filters',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ✅ Error state widget
  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline, size: 64, color: Colors.red),
          ),
          const SizedBox(height: 20),
          const Text(
            'Something Went Wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Unable to load meetings',
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Retry logic would go here
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Retry'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: orangeDeep,
                    side: BorderSide(color: orangeDeep, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
