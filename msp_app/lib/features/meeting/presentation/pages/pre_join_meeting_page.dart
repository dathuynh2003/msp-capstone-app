import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:msp_app/features/meeting/presentation/pages/join_meeting_page.dart';
import 'package:msp_app/features/meeting/presentation/widgets/glowing_button.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

const Color primaryOrange = Color(0xFFFFA463);
const Color orangeDeep = Color(0xFFFF5E13);
const Color pastelCream = Color(0xFFFFF5ED);

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
  bool _cameraOn = true;
  bool _micOn = true;
  late final Call call;
  bool _callCreated = false;
  bool _isLoading = true;
  RtcLocalCameraTrack? _cameraTrack;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    try {
      call = StreamVideo.instance.makeCall(
        callType: StreamCallType.defaultType(),
        id: widget.meetingId,
      );
      setState(() => _callCreated = true);
      await _checkPermissions();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      print('Init error: $e');
    }
  }

  Future<void> _checkPermissions() async {
    final camResult = await Permission.camera.request();
    final micResult = await Permission.microphone.request();
    setState(() {
      camGranted = camResult.isGranted;
      micGranted = micResult.isGranted;
    });
  }

  Future<RtcLocalCameraTrack> _getCameraTrack() async {
    if (_cameraTrack == null && _cameraOn) {
      try {
        _cameraTrack = await RtcLocalTrack.camera();
      } catch (e) {
        print('Error creating camera track: $e');
      }
    }
    return _cameraTrack!;
  }

  @override
  void dispose() {
    _cameraTrack?.stop();
    call.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelCream,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: primaryOrange,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Join Meeting',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : Column(
              children: [
                // ✅ Video Preview (takes remaining space)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildVideoPreview(),
                  ),
                ),

                // ✅ Controls (fixed at bottom)
                _buildBottomControls(),
              ],
            ),
    );
  }

  // ✅ Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryOrange.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.video_call, size: 48, color: primaryOrange),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(color: primaryOrange, strokeWidth: 3),
          const SizedBox(height: 16),
          Text(
            'Setting up...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Video Preview (Flexible height)
  Widget _buildVideoPreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryOrange.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Stack(
          children: [
            // Video content
            if (_callCreated && camGranted && _cameraOn)
              FutureBuilder<RtcLocalCameraTrack>(
                future: _getCameraTrack(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return VideoTrackRenderer(
                      mirror: true,
                      videoTrack: snapshot.data!,
                      placeholderBuilder: (context) => _buildVideoPlaceholder(),
                    );
                  }
                  return _buildVideoPlaceholder();
                },
              )
            else
              _buildVideoPlaceholder(),

            // Status badge
            if (_callCreated && camGranted && _cameraOn)
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam, color: Colors.green, size: 14),
                      const SizedBox(width: 6),
                      const Text(
                        'Camera on',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Permission warning
            if (!camGranted || !micGranted)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          !camGranted && !micGranted
                              ? 'Grant camera & mic permissions'
                              : !camGranted
                              ? 'Grant camera permission'
                              : 'Grant mic permission',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ Video Placeholder
  Widget _buildVideoPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.videocam_off,
                color: Colors.grey[400],
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              camGranted ? 'Camera is off' : 'No camera access',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Bottom Controls
  Widget _buildBottomControls() {
    final canJoin = camGranted && micGranted;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Control buttons
          Row(
            children: [
              Expanded(
                child: _buildControlButton(
                  icon: _micOn ? Icons.mic : Icons.mic_off,
                  label: 'Mic',
                  isActive: _micOn,
                  isEnabled: micGranted,
                  onTap: () {
                    if (micGranted) setState(() => _micOn = !_micOn);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildControlButton(
                  icon: _cameraOn ? Icons.videocam : Icons.videocam_off,
                  label: 'Camera',
                  isActive: _cameraOn,
                  isEnabled: camGranted,
                  onTap: () {
                    if (camGranted) setState(() => _cameraOn = !_cameraOn);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Join button
          GlowingButton(
            text: 'Join Meeting',
            icon: Icons.video_call_rounded,
            isFullWidth: true,
            isCompact: true,
            isDisabled: !canJoin,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinMeetingPage(
                    meetingId: widget.meetingId,
                    userId: widget.userId,
                    cameraOn: _cameraOn && camGranted,
                    micOn: _micOn && micGranted,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ✅ Compact Control Button
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: !isEnabled
              ? Colors.grey[100]
              : (isActive
                    ? primaryOrange.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: !isEnabled
                ? Colors.grey[300]!
                : (isActive
                      ? primaryOrange.withOpacity(0.5)
                      : Colors.red.withOpacity(0.5)),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: !isEnabled
                  ? Colors.grey[400]
                  : (isActive ? primaryOrange : Colors.red),
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: !isEnabled ? Colors.grey[400] : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
