import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/routes/app_routes.dart'; // THÊM
import 'package:msp_app/features/home/presentation/providers/user_provider.dart';
import 'package:msp_app/features/home/presentation/widgets/folder_project_card.dart';
import 'package:msp_app/features/home/presentation/widgets/modern_project_card.dart';
import 'package:msp_app/features/project/presentation/providers/project_providers.dart';

const Color orangeDeep = Color(0xFFFFA463);
const Color pastelPeach = Color(0xFFFFD7BA); // Cam đào pastel

class ProjectListPage extends ConsumerWidget {
  // XÓA: highlightProjectId (không cần nữa)
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final params = ProjectsListParams(userId: user.userId, role: user.role);
    final projectsAsync = ref.watch(projectsListProvider(params));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: orangeDeep,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          title: const Text(
            'My Projects',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left_outlined,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 22,
            tooltip: "Back",
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Refresh',
              onPressed: () {
                ref.invalidate(projectsListProvider(params));
              },
              splashRadius: 22,
            ),
          ],
        ),
      ),
      body: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.folder_open,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Projects Found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have no projects assigned yet.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(projectsListProvider(params));
            },
            color: orangeDeep,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
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
                      Navigator.of(context).pushNamed(
                        AppRoutes.projectDetail,
                        arguments: {'projectId': project.id},
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: orangeDeep)),
        error: (error, stack) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(projectsListProvider(params));
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 200),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading projects',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
