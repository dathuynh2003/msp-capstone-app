import 'package:msp_app/features/notification/data/models/notification_response.dart';
import 'package:msp_app/features/notification/domain/repositories/notification_repository.dart';

class MarkAsReadUsecase {
  final NotificationRepository repository;

  MarkAsReadUsecase(this.repository);

  Future<NotificationResponse> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
