import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/routes/app_routes.dart';
import 'package:msp_app/core/services/signalr_service_provider.dart';
import 'package:msp_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:msp_app/features/home/domain/params/project_query_param.dart';
import 'package:msp_app/features/home/presentation/widgets/home_card.dart';
import 'package:msp_app/features/home/presentation/widgets/modern_project_card.dart';
import 'package:msp_app/features/meeting/presentation/pages/meeting_list_page.dart';
import 'package:msp_app/features/notification/presentation/pages/notification_list_page.dart';
import 'package:msp_app/features/notification/presentation/providers/notification_provider.dart';
import 'package:msp_app/shared/widgets/member_drawer.dart';
import 'package:msp_app/features/home/presentation/providers/user_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../presentation/providers/project_provider.dart';

const Color orangeDeep = Color(0xFFFFA463);
const Color orangePrimary = Color(0xFFFF9966);
const Color orangeAccent = Color(0xFFFFB347);
const Color orangeLight = Color(0xFFFFF4E6);
const Color orangeGlow = Color.fromARGB(255, 250, 187, 115);
const Color pastelPeach = Color(0xFFFFD7BA);

class MemberHomePage extends ConsumerWidget {
  const MemberHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    // ✅ SETUP SignalR listeners INSIDE build method
    // Listen to notification stream
    ref.listen(notificationStreamProvider, (previous, next) {
      next.whenData((notification) {
        debugPrint('🔔 [HomePage] New notification: ${notification.title}');

        // Refresh notification list to update badge
        ref.invalidate(notificationListProvider(user.userId));
      });
    });

    // Listen to unread count stream
    ref.listen(unreadCountStreamProvider, (previous, next) {
      next.whenData((count) {
        debugPrint('📊 [HomePage] Unread count updated: $count');

        // Refresh notification list to update badge
        ref.invalidate(notificationListProvider(user.userId));
      });
    });

    // Fetch notifications
    final notificationsAsync = ref.watch(notificationListProvider(user.userId));

    // Get unread count
    final unreadCount = ref.watch(unreadCountProvider(user.userId));

    final listAsync = ref.watch(
      projectListProvider(
        ProjectQueryParam(userId: user.userId, role: user.role),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeDeep,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        title: const Text(
          'AI Meeting Support Platform',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MemberDrawer(
        userName: user.userName,
        userEmail: user.email,
        userRole: user.role,
        onLogout: () async {
          await ref.read(authProvider.notifier).logout();
          ref.read(userProvider.notifier).state = UserInfo.empty();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: orangeDeep,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 125,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 18, right: 8),
                children: [
                  HomeCard(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    badgeCount: unreadCount,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              NotificationListPage(userId: user.userId),
                        ),
                      );

                      if (context.mounted) {
                        ref.invalidate(notificationListProvider(user.userId));
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  HomeCard(
                    icon: Icons.calendar_month,
                    label: 'Meetings',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MeetingListPage(userId: user.userId),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  HomeCard(
                    icon: Icons.folder_special_rounded,
                    label: 'Projects',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.projectList);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Projects',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: orangeDeep),
                    tooltip: 'Refresh project list',
                    onPressed: () {
                      final user = ref.read(userProvider);
                      ref.invalidate(
                        projectListProvider(
                          ProjectQueryParam(
                            userId: user.userId,
                            role: user.role,
                          ),
                        ),
                      );
                    },
                    splashRadius: 23,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(height: 1, thickness: 1, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: listAsync.when(
                data: (projects) => ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  itemCount: projects.length,
                  itemBuilder: (_, idx) {
                    final project = projects[idx];
                    return ModernProjectCard(
                      title: project.name,
                      description: project.description,
                      owner: project.owner.fullName,
                      startDate: project.startDate ?? '',
                      endDate: project.endDate,
                      color: pastelPeach,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.projectDetail,
                          arguments: {'projectId': project.id},
                        );
                      },
                    );
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: orangeDeep),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Error: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
