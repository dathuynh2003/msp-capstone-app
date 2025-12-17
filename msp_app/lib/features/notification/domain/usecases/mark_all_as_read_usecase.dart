import 'package:msp_app/features/notification/domain/repositories/notification_repository.dart';

class MarkAllAsReadUsecase {
  final NotificationRepository repository;

  MarkAllAsReadUsecase(this.repository);

  Future<String> call(String userId) {
    return repository.markAllAsRead(userId);
  }
}
