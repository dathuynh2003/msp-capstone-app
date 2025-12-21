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
const Color pastelPeach = Color(0xFFFFD7BA);

class MemberHomePage extends ConsumerStatefulWidget {
  const MemberHomePage({super.key});

  @override
  ConsumerState<MemberHomePage> createState() => _MemberHomePageState();
}

class _MemberHomePageState extends ConsumerState<MemberHomePage> {
  @override
  void initState() {
    super.initState();
  }

  // ✅ Setup SignalR listeners once
  void _setupSignalRListeners() {
    final user = ref.read(userProvider);

    // Listen to notification stream
    ref.listen(notificationStreamProvider, (previous, next) {
      next.whenData((notification) {
        debugPrint('🔔 [HomePage] New notification: ${notification.title}');

        // Refresh notification list
        ref.invalidate(notificationListProvider(user.userId));
      });
    });

    // Listen to unread count stream
    ref.listen(unreadCountStreamProvider, (previous, next) {
      next.whenData((count) {
        debugPrint('📊 [HomePage] Unread count updated: $count');
      });
    });
  }

  // ✅ Handle logout with proper error handling
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );

    try {
      // ✅ AuthProvider.logout() will auto-clear userProvider
      await ref.read(authProvider.notifier).logout();

      if (!mounted) return;

      Navigator.pop(context); // Close loading

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Logout failed: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // ✅ Refresh projects
  void _refreshProjects() {
    final user = ref.read(userProvider);
    ref.invalidate(
      projectListProvider(
        ProjectQueryParam(userId: user.userId, role: user.role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final unreadCount = ref.watch(unreadCountProvider(user.userId));
    final projectsAsync = ref.watch(
      projectListProvider(
        ProjectQueryParam(userId: user.userId, role: user.role),
      ),
    );

    // ✅ Setup SignalR listeners in build method
    ref.listen(notificationStreamProvider, (previous, next) {
      next.whenData((notification) {
        debugPrint('🔔 [HomePage] New notification: ${notification.title}');
        ref.invalidate(notificationListProvider(user.userId));
      });
    });

    ref.listen(unreadCountStreamProvider, (previous, next) {
      next.whenData((count) {
        debugPrint('📊 [HomePage] Unread count updated: $count');
      });
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: orangeDeep,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'AI Meeting Platform',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
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
        avatarUrl: user.avatarUrl,
        onLogout: () {
          Navigator.pop(context); // Close drawer
          _handleLogout();
        },
      ),
      body: RefreshIndicator(
        color: orangeDeep,
        onRefresh: () async {
          _refreshProjects();
          ref.invalidate(notificationListProvider(user.userId));
        },
        child: CustomScrollView(
          slivers: [
            // ✅ Quick Access Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: orangeDeep,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Quick Access',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Access Cards
                  SizedBox(
                    height: 125,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        HomeCard(
                          icon: Icons.notifications_rounded,
                          label: 'Notifications',
                          badgeCount: unreadCount,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NotificationListPage(userId: user.userId),
                              ),
                            );
                            if (mounted) {
                              ref.invalidate(
                                notificationListProvider(user.userId),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 12),
                        HomeCard(
                          icon: Icons.calendar_month_rounded,
                          label: 'Meetings',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MeetingListPage(userId: user.userId),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        HomeCard(
                          icon: Icons.folder_rounded,
                          label: 'Projects',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.projectList);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),

            // ✅ Projects Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: orangeDeep,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'My Projects',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        letterSpacing: 0.3,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.refresh_rounded, color: orangeDeep),
                      tooltip: 'Refresh',
                      onPressed: _refreshProjects,
                      splashRadius: 24,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ✅ Projects List
            projectsAsync.when(
              data: (projects) {
                if (projects.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No projects yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Projects you\'re part of will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final project = projects[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ModernProjectCard(
                          title: project.name,
                          description: project.description,
                          owner: project.owner.fullName,
                          startDate: project.startDate ?? '',
                          endDate: project.endDate,
                          color: pastelPeach,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.projectDetail,
                              arguments: {'projectId': project.id},
                            );
                          },
                        ),
                      );
                    }, childCount: projects.length),
                  ),
                );
              },
              loading: () => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: orangeDeep,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading projects...',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load projects',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                          onPressed: _refreshProjects,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orangeDeep,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
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
