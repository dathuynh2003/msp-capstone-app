import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:msp_app/features/home/domain/params/project_query_param.dart';
import 'package:msp_app/features/home/presentation/widgets/home_card.dart';
import 'package:msp_app/features/meeting/presentation/pages/meeting_list_page.dart';
import 'package:msp_app/features/project/presentation/pages/project_list_page.dart';
import 'package:msp_app/shared/widgets/member_drawer.dart';
import 'package:msp_app/features/home/presentation/providers/user_provider.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../presentation/providers/project_provider.dart';
import '../../presentation/widgets/folder_project_card.dart';
import 'package:msp_app/features/project/presentation/pages/project_detail_page.dart';

// Palette demo
const Color orangeDeep = Color(0xFFFFA463);
const Color orangeLight = Color(0xFFFFDBBD);

class MemberHomePage extends ConsumerWidget {
  const MemberHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

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
          // Gọi logout từ AuthProvider (đã có disconnect SignalR)
          await ref.read(authProvider.notifier).logout();
          // Clear userProvider state
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
                    onTap: () {},
                  ),
                  SizedBox(width: 10),
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
                  SizedBox(width: 10),
                  HomeCard(
                    icon: Icons.folder_special_rounded,
                    label: 'Projects',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProjectListPage(),
                        ),
                      );
                    },
                  ),
                  // Nếu muốn thêm action, thêm tại đây
                ],
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // label left, icon right!
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
                    return FolderProjectCard(
                      title: project.name,
                      description: project.description,
                      owner: project.owner.fullName,
                      startDate: project.startDate ?? '',
                      endDate: project.endDate,
                      color: orangeDeep,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailPage(
                              projectId: project.id,
                            ), // project.id hoặc project.projectId
                          ),
                        );
                      },
                    );
                  },
                ),
                loading: () =>
                    Center(child: CircularProgressIndicator(color: orangeDeep)),
                error: (err, _) => Center(
                  child: Text(
                    'Error: $err',
                    style: TextStyle(color: Colors.red),
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
