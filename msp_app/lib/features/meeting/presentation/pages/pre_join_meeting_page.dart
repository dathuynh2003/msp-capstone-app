import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:msp_app/features/meeting/presentation/pages/join_meeting_page.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class PreJoinMeetingPage extends StatefulWidget {
  final String meetingId;
  final String userId;
  const PreJoinMeetingPage({
    super.key,
    required this.meetingId,
    required this.userId,
  });

  @override
  State<PreJoinMeetingPage> createState() => _PreJoinMeetingPageState();
}

class _PreJoinMeetingPageState extends State<PreJoinMeetingPage> {
  bool camGranted = false;
  bool micGranted = false;
  late final Call call;
  bool _callCreated = false;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    call = StreamVideo.instance.makeCall(
      callType: StreamCallType.defaultType(),
      id: widget.meetingId,
    );
    setState(() => _callCreated = true);
    await _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camResult = await Permission.camera.request();
    final micResult = await Permission.microphone.request();
    setState(() {
      camGranted = camResult.isGranted;
      micGranted = micResult.isGranted;
    });
  }

  @override
  void dispose() {
    call.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.groups_rounded, size: 60, color: Colors.blue.shade400),
              const SizedBox(height: 18),
              const Text(
                "Prepare to Join Meeting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(height: 18),
              Container(
                height: 420, // Cho rộng hơn
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(width: 2.2),
                ),
                child: (_callCreated && camGranted && micGranted)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            height: 340,
                            width: 320,
                            child: StreamLobbyVideo(call: call),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off,
                            color: Colors.grey,
                            size: 100,
                          ),
                          Text(
                            camGranted
                                ? "Checking devices"
                                : "Camera/mic permission not granted",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 260,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.video_call_rounded),
                  label: const Text("Join Meeting"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    print('---PREJOIN DEBUG---');
                    print('meetingId: ${widget.meetingId}');
                    print('userId: ${widget.userId}');
                    print('camGranted: $camGranted');
                    print('micGranted: $micGranted');
                    print('-------------------');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinMeetingPage(
                          meetingId: widget.meetingId,
                          userId: widget.userId,
                          // Quyền mic/camera sẽ do SDK điều phối bên trong JoinMeetingPage
                          cameraOn: camGranted,
                          micOn: micGranted,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
