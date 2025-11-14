import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/meeting/presentation/providers/join_meeting_provider.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class JoinMeetingPage extends ConsumerStatefulWidget {
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
  ConsumerState<JoinMeetingPage> createState() => _JoinMeetingPageState();
}

class _JoinMeetingPageState extends ConsumerState<JoinMeetingPage> {
  Call? _call;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _joinMeeting();
  }

  Future<void> _joinMeeting() async {
    print('---JOINMEETINGPAGE DEBUG---');
    print('meetingId: ${widget.meetingId}');
    print('userId: ${widget.userId}');
    print('cameraOn: ${widget.cameraOn}');
    print('micOn: ${widget.micOn}');
    print('--------------------------');
    try {
      final call = await ref.read(
        joinCallProvider(
          JoinCallParams(
            callId: widget.meetingId,
            cameraOn: widget.cameraOn,
            micOn: widget.micOn,
          ),
        ).future,
      );

      // Lấy call state hiện tại
      final callState = call.state.value;
      print('[JOIN MEETING PAGE] Call status: ${callState.status}');
      print(
        '[JOIN MEETING PAGE] Participants count: ${callState.callParticipants.length}',
      );
      for (var p in callState.callParticipants) {
        print('[JOIN MEETING PAGE] - ${p.userId} (${p.name})');
      }

      // Lắng nghe thay đổi participants bằng valueStream
      call.state.valueStream.listen((callState) {
        print(
          '[PARTICIPANTS UPDATED] Count: ${callState.callParticipants.length}',
        );
        for (var p in callState.callParticipants) {
          print('[PARTICIPANT CHANGED] ${p.userId} - ${p.name}');
        }
      });

      setState(() {
        _call = call;
        _loading = false;
      });
    } catch (e, stack) {
      print('[JOIN ERROR] $e\n$stack');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Lỗi khi vào phòng: $_error',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                child: const Text("Quay về"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    }
    // Hiển thị UI meeting khi call đã vào phòng
    return Scaffold(
      body: StreamCallContent(call: _call!, callState: _call!.state.value),
    );
  }
}
