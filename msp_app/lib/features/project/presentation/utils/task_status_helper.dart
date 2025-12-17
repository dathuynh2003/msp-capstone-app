import 'package:flutter/material.dart';

// Task Status Enum matching React
enum TaskStatus { todo, inProgress, readyToReview, reOpened, cancelled, done }

class TaskStatusHelper {
  // Convert string to enum
  static TaskStatus getTaskStatusEnum(String status) {
    switch (status.toLowerCase().replaceAll(' ', '')) {
      case 'todo':
        return TaskStatus.todo;
      case 'inprogress':
        return TaskStatus.inProgress;
      case 'readytoreview':
        return TaskStatus.readyToReview;
      case 'reopened':
        return TaskStatus.reOpened;
      case 'cancelled':
        return TaskStatus.cancelled;
      case 'done':
      case 'completed':
        return TaskStatus.done;
      default:
        return TaskStatus.todo;
    }
  }

  // Get status color matching React
  static Color getTaskStatusColor(String status) {
    final enumStatus = getTaskStatusEnum(status);

    switch (enumStatus) {
      case TaskStatus.todo:
        return const Color(0xFF6B7280); // gray
      case TaskStatus.inProgress:
        return const Color(0xFF3B82F6); // blue
      case TaskStatus.readyToReview:
        return const Color(0xFF8B5CF6); // purple
      case TaskStatus.reOpened:
        return const Color(0xFFF59E0B); // amber
      case TaskStatus.cancelled:
        return const Color(0xFFEF4444); // red
      case TaskStatus.done:
        return const Color(0xFF10B981); // green
      default:
        return const Color(0xFF6B7280); // gray
    }
  }

  // Get status label
  static String getStatusLabel(String status) {
    final enumStatus = getTaskStatusEnum(status);

    switch (enumStatus) {
      case TaskStatus.todo:
        return 'TO DO';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.readyToReview:
        return 'READY TO REVIEW';
      case TaskStatus.reOpened:
        return 'RE-OPENED';
      case TaskStatus.cancelled:
        return 'CANCELLED';
      case TaskStatus.done:
        return 'DONE';
      default:
        return status.toUpperCase();
    }
  }

  // Get status icon
  static IconData getStatusIcon(String status) {
    final enumStatus = getTaskStatusEnum(status);

    switch (enumStatus) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.autorenew;
      case TaskStatus.readyToReview:
        return Icons.rate_review_outlined;
      case TaskStatus.reOpened:
        return Icons.refresh;
      case TaskStatus.cancelled:
        return Icons.cancel_outlined;
      case TaskStatus.done:
        return Icons.check_circle;
      default:
        return Icons.radio_button_unchecked;
    }
  }
}
