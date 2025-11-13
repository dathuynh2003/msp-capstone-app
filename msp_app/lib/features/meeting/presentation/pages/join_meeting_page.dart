import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/meeting/presentation/providers/join_meeting_provider.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class JoinMeetingPage extends ConsumerWidget {
  final String meetingId;
  final String userId;
  final bool cameraOn;
  final bool micOn;

  const JoinMeetingPage({
    Key? key,
    required this.meetingId,
    required this.userId,
    required this.cameraOn,
    required this.micOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinCallAsync = ref.watch(joinCallProvider(meetingId));

    return Scaffold(
      appBar: AppBar(title: const Text("Phòng họp")),
      body: joinCallAsync.when(
        data: (call) => StreamCallControls.withDefaultOptions(
          // dùng của stream_video_flutter
          call: call,
          // Bạn có thể custom lại UI, truyền thêm param nếu SDK cho phép
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi khi vào phòng: $err')),
      ),
    );
  }
}
