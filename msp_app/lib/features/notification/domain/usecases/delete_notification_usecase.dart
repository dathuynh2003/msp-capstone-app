import 'package:msp_app/features/notification/domain/repositories/notification_repository.dart';

class DeleteNotificationUsecase {
  final NotificationRepository repository;

  DeleteNotificationUsecase(this.repository);

  Future<bool> call(String notificationId) {
    return repository.deleteNotification(notificationId);
  }
}
