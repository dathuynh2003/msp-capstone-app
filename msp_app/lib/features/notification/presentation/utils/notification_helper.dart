import 'package:flutter/material.dart';

enum NotificationType {
  email,
  sms,
  push,
  inApp,
  taskAssignment,
  taskUpdate,
  projectUpdate,
  meetingReminder,
}

class NotificationHelper {
  // Map BE enum to Mobile type
  static NotificationType getNotificationType(String? type) {
    if (type == null) return NotificationType.inApp;

    switch (type.toLowerCase()) {
      case 'email':
        return NotificationType.email;
      case 'sms':
        return NotificationType.sms;
      case 'push':
        return NotificationType.push;
      case 'inapp':
        return NotificationType.inApp;
      case 'taskassignment':
        return NotificationType.taskAssignment;
      case 'taskupdate':
        return NotificationType.taskUpdate;
      case 'projectupdate':
        return NotificationType.projectUpdate;
      case 'meetingreminder':
        return NotificationType.meetingReminder;
      default:
        return NotificationType.inApp;
    }
  }

  // Get mobile display type
  static String getMobileType(String? type) {
    final notifType = getNotificationType(type);

    switch (notifType) {
      case NotificationType.taskAssignment:
      case NotificationType.taskUpdate:
        return 'Task';
      case NotificationType.projectUpdate:
        return 'Project';
      case NotificationType.meetingReminder:
        return 'Meeting';
      default:
        return 'InApp';
    }
  }

  // Check if notification should navigate
  static bool shouldNavigate(String? type) {
    final notifType = getNotificationType(type);
    return notifType == NotificationType.taskAssignment ||
        notifType == NotificationType.taskUpdate ||
        notifType == NotificationType.projectUpdate ||
        notifType == NotificationType.meetingReminder;
  }

  // Get notification icon
  static IconData getNotificationIcon(String? type) {
    final mobileType = getMobileType(type);

    switch (mobileType) {
      case 'Task':
        return Icons.task_alt;
      case 'Project':
        return Icons.folder;
      case 'Meeting':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  // Get notification primary color (for icon & badge)
  static Color getNotificationColor(String? type) {
    final mobileType = getMobileType(type);

    switch (mobileType) {
      case 'Task':
        return const Color(0xFF10B981); // green
      case 'Project':
        return const Color(0xFFFF9966); // orange
      case 'Meeting':
        return const Color(0xFF3B82F6); // blue
      default:
        return const Color(0xFF8B5CF6); // purple
    }
  }

  // ✅ NEW: Get pastel background color for card
  static Color getPastelBackgroundColor(String? type, bool isRead) {
    final mobileType = getMobileType(type);

    // If read, use white
    if (isRead) {
      return Colors.white;
    }

    // Unread - use pastel colors
    switch (mobileType) {
      case 'Task':
        return const Color(0xFFD1FAE5); // pastel green
      case 'Project':
        return const Color(0xFFFFE9D9); // pastel orange/peach
      case 'Meeting':
        return const Color(0xFFDBEAFE); // pastel blue
      default:
        return const Color(0xFFF3E8FF); // pastel purple
    }
  }

  // ✅ NEW: Get pastel border color for card
  static Color getPastelBorderColor(String? type, bool isRead) {
    final mobileType = getMobileType(type);

    // If read, use light gray
    if (isRead) {
      return const Color(0xFFE5E7EB); // gray-200
    }

    // Unread - use darker pastel borders
    switch (mobileType) {
      case 'Task':
        return const Color(0xFFA7F3D0); // green-200
      case 'Project':
        return const Color(0xFFFFD7BA); // peach-200
      case 'Meeting':
        return const Color(0xFFBFDBFE); // blue-200
      default:
        return const Color(0xFFE9D5FF); // purple-200
    }
  }

  // ✅ NEW: Get pastel icon background color
  static Color getPastelIconBackground(String? type) {
    final mobileType = getMobileType(type);

    switch (mobileType) {
      case 'Task':
        return const Color(0xFFECFDF5); // green-50
      case 'Project':
        return const Color(0xFFFFF5ED); // orange-50
      case 'Meeting':
        return const Color(0xFFEFF6FF); // blue-50
      default:
        return const Color(0xFFFAF5FF); // purple-50
    }
  }

  // Format time ago
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    }
  }
}
