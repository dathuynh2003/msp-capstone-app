import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/services/background_service.dart';
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
  bool _showControls = true;

  // ✅ Add subscription to manage lifecycle
  StreamSubscription<CallState>? _callStateSubscription;

  @override
  void initState() {
    super.initState();
    // ✅ Removed BackgroundServiceHelper.initialize() - now in main.dart
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

      // ✅ Store subscription for proper cleanup
      _callStateSubscription = call.state.valueStream.listen((callState) {
        print('[PARTICIPANTS] ${callState.callParticipants.length}');
      });

      setState(() {
        _call = call;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    // ✅ Cancel subscription first to prevent memory leak
    _callStateSubscription?.cancel();

    // ✅ Clean up call
    _call?.leave();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Connecting...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Error joining the room',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error ?? 'Unknown error',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Go back"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // ✅ Clean up screen sharing if active
        final localParticipant = _call?.state.value.localParticipant;
        if (localParticipant?.isScreenShareEnabled ?? false) {
          await _call?.setScreenShareEnabled(enabled: false);
          if (Theme.of(context).platform == TargetPlatform.android) {
            await BackgroundServiceHelper.stopScreenShare(_call!);
          }
        }
        _call?.leave();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
          },
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
                  return AppBar(
                    backgroundColor: Colors.black.withOpacity(0.7),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () async {
                        // ✅ Clean up before leaving
                        final localParticipant =
                            call.state.value.localParticipant;
                        if (localParticipant?.isScreenShareEnabled ?? false) {
                          await call.setScreenShareEnabled(enabled: false);
                          if (Theme.of(context).platform ==
                              TargetPlatform.android) {
                            await BackgroundServiceHelper.stopScreenShare(call);
                          }
                        }
                        call.leave();
                        Navigator.of(context).pop();
                      },
                    ),
                    title: Text(
                      widget.meetingId.length > 20
                          ? '${widget.meetingId.substring(0, 20)}...'
                          : widget.meetingId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                  );
                },
              ),

              // Bottom controls
              if (_showControls)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 16 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: StreamBuilder<CallState>(
                      stream: _call!.state.valueStream,
                      builder: (context, snapshot) {
                        final callState = snapshot.data;
                        final localParticipant = callState?.localParticipant;
                        final isMicEnabled =
                            localParticipant?.isAudioEnabled ?? false;
                        final isCameraEnabled =
                            localParticipant?.isVideoEnabled ?? false;
                        final isScreenSharing =
                            localParticipant?.isScreenShareEnabled ?? false;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildControlButton(
                              icon: isMicEnabled ? Icons.mic : Icons.mic_off,
                              label: 'Mic',
                              isActive: isMicEnabled,
                              onPressed: () async {
                                await _call?.setMicrophoneEnabled(
                                  enabled: !isMicEnabled,
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildControlButton(
                              icon: isCameraEnabled
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              label: 'Camera',
                              isActive: isCameraEnabled,
                              onPressed: () async {
                                await _call?.setCameraEnabled(
                                  enabled: !isCameraEnabled,
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildControlButton(
                              icon: isScreenSharing
                                  ? Icons.stop_screen_share
                                  : Icons.screen_share,
                              label: 'Share',
                              isActive: isScreenSharing,
                              onPressed: () =>
                                  _handleScreenShare(isScreenSharing),
                            ),
                            const SizedBox(width: 16),
                            _buildControlButton(
                              icon: Icons.call_end,
                              label: 'End Meeting',
                              isEndCall: true,
                              onPressed: () async {
                                // ✅ Clean up before ending
                                final localParticipant =
                                    _call?.state.value.localParticipant;
                                if (localParticipant?.isScreenShareEnabled ??
                                    false) {
                                  // await _call?.setScreenShareEnabled(
                                  //   enabled: false,
                                  // );
                                  if (Theme.of(context).platform ==
                                      TargetPlatform.android) {
                                    await BackgroundServiceHelper.stopScreenShare(
                                      _call!,
                                    );
                                  }
                                }
                                _call?.leave();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Screen share handler with proper error handling
  Future<void> _handleScreenShare(bool isCurrentlySharing) async {
    if (_call == null) return;

    try {
      if (isCurrentlySharing) {
        // Stop screen sharing
        await _call!.setScreenShareEnabled(enabled: false);

        if (Theme.of(context).platform == TargetPlatform.android) {
          await BackgroundServiceHelper.stopScreenShare(_call!);
        }
      } else {
        // Start screen sharing
        // Kiểm tra xem có ai đang share không
        final callState = _call!.state.value;
        final isAnyoneScreenSharing = callState.callParticipants.any(
          (participant) => participant.isScreenShareEnabled,
        );
        if (isAnyoneScreenSharing) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Someone is already sharing the screen'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
        if (Theme.of(context).platform == TargetPlatform.android) {
          // Start background service first
          await BackgroundServiceHelper.startScreenShare(_call!);
        }

        // Enable screen sharing
        final result = await _call!.setScreenShareEnabled(
          enabled: true,
          constraints: const ScreenShareConstraints(captureScreenAudio: false),
        );

        // Stop service if operation failed
        if (Theme.of(context).platform == TargetPlatform.android &&
            (result.isFailure)) {
          await BackgroundServiceHelper.stopScreenShare(_call!);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cannot start screen sharing')),
            );
          }
        }
      }
    } catch (e) {
      print('Screen share error: $e');

      // Clean up on error
      if (Theme.of(context).platform == TargetPlatform.android) {
        await BackgroundServiceHelper.stopScreenShare(_call!);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cannot share screen')));
      }
      return;
    }
  }

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
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isEndCall
                ? Colors.red
                : (isActive ? Colors.blue[700] : Colors.grey[700]),
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
