import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:msp_app/features/meeting/presentation/pages/join_meeting_page.dart';

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
  bool micOn = false;
  bool cameraOn = false;
  bool camGranted = false;
  bool micGranted = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camResult = await Permission.camera.status;
    final micResult = await Permission.microphone.status;
    setState(() {
      camGranted = camResult.isGranted;
      micGranted = micResult.isGranted;
    });
  }

  Future<void> _handleMicToggle(bool val) async {
    if (!micGranted) {
      setState(() => loading = true);
      final status = await Permission.microphone.request();
      setState(() {
        micGranted = status.isGranted;
        if (!micGranted) micOn = false;
        loading = false;
      });
      if (micGranted) setState(() => micOn = val);
    } else {
      setState(() => micOn = val);
    }
  }

  Future<void> _handleCamToggle(bool val) async {
    if (!camGranted) {
      setState(() => loading = true);
      final status = await Permission.camera.request();
      setState(() {
        camGranted = status.isGranted;
        if (!camGranted) cameraOn = false;
        loading = false;
      });
      if (camGranted) setState(() => cameraOn = val);
    } else {
      setState(() => cameraOn = val);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey[800],
    );
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
                "Chuẩn bị vào phòng họp",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(height: 18),
              // Video preview (chỉ show icon ở PreJoin)
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cameraOn && camGranted ? Colors.blue : Colors.grey,
                    width: 2.2,
                  ),
                ),
                child: cameraOn && camGranted
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam, color: Colors.blue, size: 60),
                          Text(
                            "Camera đã sẵn sàng",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off,
                            color: Colors.grey,
                            size: 60,
                          ),
                          Text(
                            camGranted
                                ? "Camera đã tắt"
                                : "Chưa cấp quyền camera",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 270,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: micOn,
                          onChanged: loading
                              ? null
                              : (val) => _handleMicToggle(val),
                        ),
                        Icon(
                          micOn && micGranted ? Icons.mic : Icons.mic_off,
                          color: micOn && micGranted
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text("Mic", style: labelStyle),
                        if (!micGranted && !loading)
                          const Text(
                            " (Chưa cấp quyền)",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Switch(
                          value: cameraOn,
                          onChanged: loading
                              ? null
                              : (val) => _handleCamToggle(val),
                        ),
                        Icon(
                          cameraOn && camGranted
                              ? Icons.videocam
                              : Icons.videocam_off,
                          color: cameraOn && camGranted
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text("Camera", style: labelStyle),
                        if (!camGranted && !loading)
                          const Text(
                            " (Chưa cấp quyền)",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    if (loading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 260,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.video_call_rounded),
                  label: const Text("Vào phòng họp"),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinMeetingPage(
                          meetingId: widget.meetingId,
                          userId: widget.userId,
                          cameraOn: cameraOn && camGranted,
                          micOn: micOn && micGranted,
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
