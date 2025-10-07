import 'package:msp_app/core/services/auth_service.dart';

/// Permission Manager - Quản lý phân quyền trong ứng dụng
class PermissionManager {
  /// Lấy role hiện tại của user
  static Future<String> getCurrentUserRole() async {
    final user = await AuthService.getCurrentUser();
    return user?.roleDisplayName ?? 'Member';
  }
  
  /// Kiểm tra xem user có phải Project Manager không
  static Future<bool> isProjectManager() async {
    final role = await getCurrentUserRole();
    return role == 'Quản Lý Dự án';
  }
  
  /// Kiểm tra xem user có phải Member không
  static Future<bool> isMember() async {
    final role = await getCurrentUserRole();
    return role == 'Thành Viên';
  }
  
  /// Kiểm tra quyền tạo dự án
  static Future<bool> canCreateProject() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền cập nhật dự án
  static Future<bool> canUpdateProject() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền xóa dự án
  static Future<bool> canDeleteProject() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền xem dự án (tất cả role đều có thể xem)
  static Future<bool> canViewProject() async {
    return true;
  }
  
  /// Kiểm tra quyền tạo cuộc họp
  static Future<bool> canCreateMeeting() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền cập nhật cuộc họp
  static Future<bool> canUpdateMeeting() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền xóa cuộc họp
  static Future<bool> canDeleteMeeting() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền tạo milestone
  static Future<bool> canCreateMilestone() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền cập nhật milestone
  static Future<bool> canUpdateMilestone() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền xóa milestone
  static Future<bool> canDeleteMilestone() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền tạo task
  static Future<bool> canCreateTask() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền cập nhật task
  static Future<bool> canUpdateTask() async {
    return await isProjectManager();
  }
  
  /// Kiểm tra quyền xóa task
  static Future<bool> canDeleteTask() async {
    return await isProjectManager();
  }
  
  /// Lấy tên hiển thị của role
  static String getRoleDisplayName(String role) {
    switch (role) {
      case 'Quản Lý Dự án':
        return 'Quản Lý Dự án';
      case 'Thành Viên':
        return 'Thành Viên';
      case 'Quản Trị Hệ Thống':
        return 'Quản Trị Hệ Thống';
      case 'Chủ Doanh Nghiệp':
        return 'Chủ Doanh Nghiệp';
      default:
        return 'Thành Viên';
    }
  }
}
