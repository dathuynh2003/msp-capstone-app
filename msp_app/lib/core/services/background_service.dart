import 'package:flutter/material.dart';
import 'package:msp_app/core/core.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class BackgroundServiceHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    try {
      StreamBackgroundService.init(
        StreamVideo.instance,
        // ✅ Customize notification text only
        callNotificationOptionsBuilder: (call) {
          return const NotificationOptions(
            content: NotificationContent(
              title: 'Cuộc họp đang diễn ra',
              text: 'Tap để quay lại cuộc họp',
            ),
          );
        },
        screenShareNotificationOptionsBuilder: (call) {
          return const NotificationOptions(
            content: NotificationContent(
              title: 'Đang chia sẻ màn hình',
              text: 'Đang chia sẻ màn hình trong cuộc họp',
            ),
          );
        },
        onNotificationClick: (call) async {
          _navigateToMeeting(call);
        },
        // ✅ Handle button clicks (SDK provides default buttons)
        onButtonClick: (call, type, serviceType) async {
          switch (serviceType) {
            case ServiceType.call:
              await _leaveMeeting(call);

            case ServiceType.screenSharing:
              await _stopScreenShareOnly(call);
          }
        },
      );
    } catch (e) {
      Logger.log(
        '[BackgroundService] Error initializing background service: $e',
      );
      return;
    }
  }

  static void _navigateToMeeting(Call call) {
    final navigator = navigatorKey.currentState;
    Logger.log('[BackgroundService] Navigating to meeting: ${call.id}');
    Logger.log('[BackgroundService] Navigator state: $navigator');

    if (navigator == null) {
      Logger.log('[BackgroundService] Navigator is null, cannot navigate');
      return;
    }

    final context = navigator.context;
    final currentRoute = ModalRoute.of(context)?.settings.name;
    Logger.log('[BackgroundService] Current route: $currentRoute');

    if (currentRoute == '/meeting') {
      Logger.log('[BackgroundService] Already on meeting page');
      return;
    }

    // Navigate to meeting page
    navigator
        .pushNamed(
          '/meeting',
          arguments: {
            'meetingId': call.id,
            'userId': call.state.value.localParticipant?.userId,
            'cameraOn':
                call.state.value.localParticipant?.isVideoEnabled ?? false,
            'micOn': call.state.value.localParticipant?.isAudioEnabled ?? false,
          },
        )
        .then((_) {
          Logger.log('[BackgroundService] Navigation completed');
        })
        .catchError((error) {
          Logger.log('[BackgroundService] Navigation error: $error');
        });
  }

  static Future<void> _leaveMeeting(Call call) async {
    try {
      Logger.log('[BackgroundService] Leaving meeting: ${call.id}');

      // Stop screen sharing if active
      final isScreenSharing =
          call.state.value.localParticipant?.isScreenShareEnabled ?? false;
      if (isScreenSharing) {
        Logger.log('[BackgroundService] Stopping screen share before leaving');
        await call.setScreenShareEnabled(enabled: false);
        await StreamBackgroundService().stopScreenSharingNotificationService(
          call.id,
        );
      }

      // Leave call
      await call.leave();
      Logger.log('[BackgroundService] Call left successfully');

      // Navigate back to home
      final navigator = navigatorKey.currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
        Logger.log('[BackgroundService] Navigated back to home');
      }
    } catch (e) {
      Logger.log('[BackgroundService] Error leaving meeting: $e');
    }
  }

  static Future<void> _stopScreenShareOnly(Call call) async {
    try {
      Logger.log('[BackgroundService] Stopping screen share only');
      await call.setScreenShareEnabled(enabled: false);
      await StreamBackgroundService().stopScreenSharingNotificationService(
        call.id,
      );

      Logger.log('[BackgroundService] Screen share stopped successfully');
    } catch (e) {
      Logger.log('[BackgroundService] Error stopping screen share: $e');
    }
  }

  static Future<void> startScreenShare(Call call) async {
    try {
      if (!await call.requestScreenSharePermission()) {
        Logger.log('[BackgroundService] Screen share permission denied');
        return;
      }

      await StreamBackgroundService().startScreenSharingNotificationService(
        call,
      );
      Logger.log('[BackgroundService] Screen share service started');
    } catch (e) {
      Logger.log('[BackgroundService] Error starting screen share: $e');
    }
  }

  static Future<void> stopScreenShare(Call call) async {
    try {
      await StreamBackgroundService().stopScreenSharingNotificationService(
        call.id,
      );
      Logger.log('[BackgroundService] Screen share service stopped');
    } catch (e) {
      Logger.log('[BackgroundService] Error stopping screen share: $e');
    }
  }
}
