import 'package:flutter/material.dart';
import 'package:msp_app/features/home/presentation/widgets/home_card.dart';
import 'package:msp_app/features/meeting/presentation/pages/meeting_list_page.dart';
import 'package:msp_app/shared/widgets/member_drawer.dart';
import 'package:msp_app/features/home/presentation/providers/user_provider.dart';
import 'package:msp_app/core/local/user_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/pages/login_page.dart';

class MemberHomePage extends ConsumerWidget {
  const MemberHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        title: const Text(
          'AI Meeting Support Platform',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 16,
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
          await UserPrefs.clear();
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Notification and Application status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 2,
                    indent: 80,
                    endIndent: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  // Row 1: Notification & Application Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeCard(
                        icon: Icons.notifications,
                        label: 'Notification',
                        onTap: () {},
                      ),
                      HomeCard(
                        icon: Icons.account_box,
                        label: 'Application status',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Information Access',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 2,
                    indent: 110,
                    endIndent: 110,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeCard(
                        icon: Icons.calendar_month,
                        label: 'Meetings',
                        // onTap: () {},
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  MeetingListPage(userId: user.userId),
                            ),
                          );
                        },
                      ),
                      HomeCard(
                        icon: Icons.newspaper,
                        label: 'Projects',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.orange.shade400,
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.white70,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat_bubble_outline),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      //   ],
      //   onTap: (index) {
      //     // Thay đổi page/tab ở đây nếu muốn
      //   },
      // ),
    );
  }
}
