import 'package:msp_app/features/notification/data/models/notification_response.dart';
import 'package:msp_app/features/notification/domain/repositories/notification_repository.dart';

class GetUserNotificationsUsecase {
  final NotificationRepository repository;

  GetUserNotificationsUsecase(this.repository);

  Future<List<NotificationResponse>> call(String userId) {
    return repository.getUserNotifications(userId);
  }
}
