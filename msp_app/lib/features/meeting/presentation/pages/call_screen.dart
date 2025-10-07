import 'package:flutter/material.dart';
import 'package:msp_app/shared/theme/app_colors.dart';
import '../../domain/entities/meeting.dart';

class CallScreen extends StatefulWidget {
  final Meeting meeting;

  const CallScreen({
    super.key,
    required this.meeting,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isLoading = true;
  bool _isMicrophoneOn = true;
  bool _isCameraOn = true;
  bool _isSpeakerOn = true;
  bool _isScreenSharing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _simulateJoinCall();
  }

  Future<void> _simulateJoinCall() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
  }

  void _leaveCall() {
    Navigator.pop(context);
  }

  void _toggleMicrophone() {
    setState(() {
      _isMicrophoneOn = !_isMicrophoneOn;
    });
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _toggleScreenShare() {
    setState(() {
      _isScreenSharing = !_isScreenSharing;
    });
  }

  @override
  void dispose() {
    // Không dispose call ở đây vì có thể user chỉ minimize app
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_error != null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildCallContent(),
    );
  }

  Widget _buildCallContent() {
    return Stack(
      children: [
        // Video grid
        _buildVideoGrid(),
        
        // Top app bar
        _buildTopBar(),
        
        // Bottom controls
        _buildBottomControls(),
        
        // Meeting info overlay
        _buildMeetingInfoOverlay(),
      ],
    );
  }

  Widget _buildVideoGrid() {
    // Mock participants data
    final participants = widget.meeting.participantNames;
    
    if (participants.isEmpty) {
      return const Center(
        child: Text(
          'Đang chờ người tham gia...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }

    if (participants.length == 1) {
      // Single participant - full screen
      return _buildParticipantView(participants.first, isFullScreen: true);
    }

    // Multiple participants - grid layout
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return _buildParticipantView(participants[index]);
      },
    );
  }

  Widget _buildParticipantView(String participantName, {bool isFullScreen = false}) {
    // Mock speaking status (random for demo)
    final isSpeaking = participantName == widget.meeting.participantNames.first;
    final isLocalUser = participantName == 'Nguyễn Văn A'; // Mock current user
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSpeaking ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Mock video view
            Container(
              color: Colors.grey[800],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isFullScreen ? 60 : 30,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        participantName.isNotEmpty 
                            ? participantName.split(' ').last[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: isFullScreen ? 48 : 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isCameraOn ? 'Video đang bật' : 'Video đã tắt',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Participant info overlay
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      participantName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (!_isMicrophoneOn)
                      const Icon(
                        Icons.mic_off,
                        color: Colors.red,
                        size: 16,
                      ),
                    if (!_isCameraOn)
                      const Icon(
                        Icons.videocam_off,
                        color: Colors.red,
                        size: 16,
                      ),
                    if (isLocalUser)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Bạn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
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

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _leaveCall,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.meeting.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.meeting.participantNames.length} người tham gia',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Toggle chat
                },
                icon: const Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: _isMicrophoneOn ? Icons.mic : Icons.mic_off,
                onPressed: _toggleMicrophone,
                isActive: _isMicrophoneOn,
              ),
              _buildControlButton(
                icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                onPressed: _toggleCamera,
                isActive: _isCameraOn,
              ),
              _buildControlButton(
                icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
                onPressed: _toggleScreenShare,
                isActive: _isScreenSharing,
              ),
              _buildControlButton(
                icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                onPressed: _toggleSpeaker,
                isActive: _isSpeakerOn,
              ),
              _buildControlButton(
                icon: Icons.call_end,
                onPressed: _leaveCall,
                isActive: false,
                backgroundColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? 
               (isActive ? Colors.white.withOpacity(0.2) : Colors.red.withOpacity(0.8)),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        iconSize: 24,
      ),
    );
  }

  Widget _buildMeetingInfoOverlay() {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thời gian: ${widget.meeting.formattedStartTime}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            if (widget.meeting.notes != null) ...[
              const SizedBox(height: 4),
              Text(
                'Ghi chú: ${widget.meeting.notes}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Đang kết nối đến cuộc họp...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.meeting.name,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Có lỗi xảy ra',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _simulateJoinCall,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _leaveCall,
              child: const Text(
                'Quay lại',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
