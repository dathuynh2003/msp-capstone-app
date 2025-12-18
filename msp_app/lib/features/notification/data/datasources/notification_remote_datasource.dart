import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:msp_app/core/models/api_response.dart';
import 'package:msp_app/core/network/api_config.dart';
import 'package:msp_app/core/network/http_client.dart';
import 'package:msp_app/features/notification/data/models/notification_response.dart';

class NotificationRemoteDatasource {
  Future<List<NotificationResponse>> getUserNotifications(String userId) async {
    final uri = Uri.parse("${ApiConfig.apiBaseUrl}/notification/user/$userId");

    final response = await HttpClient.get(uri);

    final data = jsonDecode(response.body);

    // ✅ DEBUG: Print raw response
    // debugPrint('🔍 [NotificationAPI] Raw Response: $data');
    // debugPrint('🔍 [NotificationAPI] Status Code: ${response.statusCode}');

    final apiRes = ApiResponse<List<NotificationResponse>>.fromJson(data, (
      json,
    ) {
      // debugPrint('🔍 [NotificationAPI] JSON Type: ${json.runtimeType}');
      // debugPrint('🔍 [NotificationAPI] JSON Content: $json');

      if (json is List) {
        return json.map((item) {
          // debugPrint('🔍 [NotificationAPI] Item: $item'); // ✅ DEBUG each item
          return NotificationResponse.fromJson(item as Map<String, dynamic>);
        }).toList();
      }
      throw Exception(
        "Expected a list of notifications, got: ${json.runtimeType}",
      );
    });

    if (response.statusCode == 200 && apiRes.success) {
      if (apiRes.data == null) throw Exception("No notifications returned!");
      // debugPrint(
      //   '✅ [NotificationAPI] Success: ${apiRes.data!.length} notifications',
      // );
      return apiRes.data!;
    } else {
      throw Exception(apiRes.message);
    }
  }

  Future<NotificationResponse> markAsRead(String notificationId) async {
    // ✅ FIX: Endpoint is /mark-read not /read
    final uri = Uri.parse(
      "${ApiConfig.apiBaseUrl}/notification/$notificationId/mark-read",
    );

    // debugPrint('📝 [NotificationAPI] Marking as read: $notificationId');

    final response = await HttpClient.put(uri);

    final data = jsonDecode(response.body);
    // debugPrint('🔍 [NotificationAPI] Mark as Read Response: $data');

    // ✅ Parse ApiResponse<NotificationResponse>
    final apiRes = ApiResponse<NotificationResponse>.fromJson(
      data,
      (json) => NotificationResponse.fromJson(json as Map<String, dynamic>),
    );

    if (response.statusCode == 200 && apiRes.success) {
      if (apiRes.data == null) {
        throw Exception("No notification data returned after marking as read");
      }
      // debugPrint('✅ [NotificationAPI] Marked as read successfully');
      return apiRes.data!;
    } else {
      throw Exception(apiRes.message);
    }
  }

  Future<String> markAllAsRead(String userId) async {
    final uri = Uri.parse(
      "${ApiConfig.apiBaseUrl}/notification/user/$userId/mark-all-read",
    );

    debugPrint('📝 [NotificationAPI] Marking all as read for user: $userId');

    final response = await HttpClient.put(uri);

    final data = jsonDecode(response.body);
    debugPrint('🔍 [NotificationAPI] Mark All Response: $data');

    // ✅ Parse ApiResponse<String>
    final apiRes = ApiResponse<String>.fromJson(
      data,
      (json) => json.toString(),
    );

    if (response.statusCode == 200 && apiRes.success) {
      final message = apiRes.data ?? apiRes.message;
      debugPrint('✅ [NotificationAPI] $message');
      return message;
    } else {
      throw Exception(apiRes.message);
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    final uri = Uri.parse(
      "${ApiConfig.apiBaseUrl}/notification/$notificationId",
    );

    debugPrint('🗑️ [NotificationAPI] Deleting notification: $notificationId');

    final response = await HttpClient.delete(uri);

    final data = jsonDecode(response.body);
    debugPrint('🔍 [NotificationAPI] Delete Response: $data');

    // ✅ Parse ApiResponse<bool>
    final apiRes = ApiResponse<bool>.fromJson(data, (json) => json as bool);

    if (response.statusCode == 200 && apiRes.success) {
      debugPrint('✅ [NotificationAPI] Notification deleted successfully');
      return apiRes.data ?? true;
    } else {
      throw Exception(apiRes.message);
    }
  }
}
