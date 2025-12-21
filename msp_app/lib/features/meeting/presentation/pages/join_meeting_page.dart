import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/services/background_service.dart';
import 'package:msp_app/features/meeting/presentation/providers/join_meeting_provider.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

const Color primaryOrange = Color(0xFFFFA463);
const Color darkBackground = Color(0xFF1A1A1A);
const Color controlBackground = Color(0xFF2D2D2D);

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
  bool _showControls = true;
  Timer? _hideControlsTimer;

  StreamSubscription<CallState>? _callStateSubscription;

  @override
  void initState() {
    super.initState();
    _joinMeeting();
  }

  Future<void> _joinMeeting() async {
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

      _callStateSubscription = call.state.valueStream.listen((callState) {
        print('[PARTICIPANTS] ${callState.callParticipants.length}');
      });

      setState(() {
        _call = call;
        _loading = false;
      });

      // Auto-hide controls after 5 seconds
      _startHideControlsTimer();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _callStateSubscription?.cancel();
    _call?.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Loading State
    if (_loading) {
      return Scaffold(
        backgroundColor: darkBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darkBackground, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo or icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: primaryOrange.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryOrange.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.video_call,
                    size: 64,
                    color: primaryOrange,
                  ),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  color: primaryOrange,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Connecting to meeting...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please wait',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✅ Error State
    if (_error != null) {
      return Scaffold(
        backgroundColor: darkBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darkBackground, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Connection Failed',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to join the meeting',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: controlBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _error ?? 'Unknown error',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ✅ Meeting Room UI
    return WillPopScope(
      onWillPop: () async {
        await _cleanupAndLeave();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              // Video content
              StreamCallContent(
                call: _call!,
                layoutMode: ParticipantLayoutMode.grid,
                callControlsWidgetBuilder: (context, call) {
                  return const SizedBox.shrink();
                },
                callAppBarWidgetBuilder: (context, call) {
                  return PreferredSize(
                    preferredSize: Size.zero, // ✅ Zero height
                    child: const SizedBox.shrink(),
                  );
                },
              ),

              // ✅ Custom AppBar (darker, with inline participant info)
              if (_showControls)
                Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),

              // ✅ Bottom Controls
              if (_showControls)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomControls(),
                ),

              // ✅ Tap to show controls hint
              if (!_showControls)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: _showControls ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7), // ✅ Darker
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tap to show controls',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  // ✅ Top Bar Widget
  // ✅ Enhanced Top Bar (darker, more visible)
  Widget _buildTopBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.95), // ✅ More opaque
            Colors.black.withOpacity(0.85),
            Colors.black.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 20, // ✅ More padding for gradient
      ),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // ✅ More visible
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () async {
                await _cleanupAndLeave();
                Navigator.of(context).pop();
              },
            ),
          ),

          const SizedBox(width: 16),

          // Meeting info with participants count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Meeting ID
                Text(
                  widget.meetingId.length > 20
                      ? '${widget.meetingId.substring(0, 20)}...'
                      : widget.meetingId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                // ✅ Participants info inline (no separate overlay)
                StreamBuilder<CallState>(
                  stream: _call!.state.valueStream,
                  builder: (context, snapshot) {
                    final callState = snapshot.data;
                    final participantCount =
                        callState?.callParticipants.length ?? 0;
                    final participants = callState?.callParticipants ?? [];

                    // Get participant names (max 2)
                    final names = participants
                        .take(2)
                        .map((p) => p.name ?? 'Guest')
                        .join(', ');

                    final moreCount = participantCount > 2
                        ? ' +${participantCount - 2}'
                        : '';

                    return Row(
                      children: [
                        const Icon(
                          Icons.people,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            participantCount > 0
                                ? '$names$moreCount'
                                : 'No participants',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ✅ Connection indicator (more prominent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Participant Info Widget
  Widget _buildParticipantInfo() {
    return StreamBuilder<CallState>(
      stream: _call!.state.valueStream,
      builder: (context, snapshot) {
        final callState = snapshot.data;
        if (callState == null) return const SizedBox.shrink();

        final participants = callState.callParticipants;
        if (participants.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.people, color: primaryOrange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  participants.map((p) => p.name ?? 'Guest').join(', '),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ Bottom Controls Widget
  Widget _buildBottomControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      child: StreamBuilder<CallState>(
        stream: _call!.state.valueStream,
        builder: (context, snapshot) {
          final callState = snapshot.data;
          final localParticipant = callState?.localParticipant;
          final isMicEnabled = localParticipant?.isAudioEnabled ?? false;
          final isCameraEnabled = localParticipant?.isVideoEnabled ?? false;
          final isScreenSharing =
              localParticipant?.isScreenShareEnabled ?? false;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Microphone
              _buildControlButton(
                icon: isMicEnabled ? Icons.mic : Icons.mic_off,
                label: 'Mic',
                isActive: isMicEnabled,
                onPressed: () async {
                  await _call?.setMicrophoneEnabled(enabled: !isMicEnabled);
                },
              ),

              // Camera
              _buildControlButton(
                icon: isCameraEnabled ? Icons.videocam : Icons.videocam_off,
                label: 'Camera',
                isActive: isCameraEnabled,
                onPressed: () async {
                  await _call?.setCameraEnabled(enabled: !isCameraEnabled);
                },
              ),

              // Screen Share
              _buildControlButton(
                icon: isScreenSharing
                    ? Icons.stop_screen_share
                    : Icons.screen_share,
                label: 'Share',
                isActive: isScreenSharing,
                onPressed: () => _handleScreenShare(isScreenSharing),
              ),

              // End Call
              _buildControlButton(
                icon: Icons.call_end,
                label: 'End',
                isEndCall: true,
                onPressed: () async {
                  await _cleanupAndLeave();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ Control Button Widget
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isEndCall = false,
    bool isActive = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isEndCall
                ? Colors.red
                : (isActive ? primaryOrange : controlBackground),
            shape: BoxShape.circle,
            boxShadow: [
              if (isActive || isEndCall)
                BoxShadow(
                  color: (isEndCall ? Colors.red : primaryOrange).withOpacity(
                    0.4,
                  ),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ✅ Cleanup helper
  Future<void> _cleanupAndLeave() async {
    try {
      final localParticipant = _call?.state.value.localParticipant;
      if (localParticipant?.isScreenShareEnabled ?? false) {
        await _call?.setScreenShareEnabled(enabled: false);
        if (Theme.of(context).platform == TargetPlatform.android) {
          await BackgroundServiceHelper.stopScreenShare(_call!);
        }
      }
      await _call?.leave();
    } catch (e) {
      print('Cleanup error: $e');
    }
  }

  // ✅ Screen share handler
  Future<void> _handleScreenShare(bool isCurrentlySharing) async {
    if (_call == null) return;

    try {
      if (isCurrentlySharing) {
        await _call!.setScreenShareEnabled(enabled: false);

        if (Theme.of(context).platform == TargetPlatform.android) {
          await BackgroundServiceHelper.stopScreenShare(_call!);
        }
      } else {
        final callState = _call!.state.value;
        final isAnyoneScreenSharing = callState.callParticipants.any(
          (participant) => participant.isScreenShareEnabled,
        );

        if (isAnyoneScreenSharing) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('Someone is already sharing the screen'),
                    ),
                  ],
                ),
                backgroundColor: primaryOrange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
          return;
        }

        if (Theme.of(context).platform == TargetPlatform.android) {
          await BackgroundServiceHelper.startScreenShare(_call!);
        }

        final result = await _call!.setScreenShareEnabled(
          enabled: true,
          constraints: const ScreenShareConstraints(captureScreenAudio: false),
        );

        if (Theme.of(context).platform == TargetPlatform.android &&
            result.isFailure) {
          await BackgroundServiceHelper.stopScreenShare(_call!);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Cannot start screen sharing'),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Screen share error: $e');

      if (Theme.of(context).platform == TargetPlatform.android) {
        await BackgroundServiceHelper.stopScreenShare(_call!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}
