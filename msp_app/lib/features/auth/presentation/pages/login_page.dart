import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:msp_app/features/home/presentation/pages/member_home_page.dart';

const Color orangeDeep = Color(0xFFFF5E13);
const Color orangeLight = Color(0xFFFFDBBD);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe = false;
  String? _error;

  void _login() async {
    setState(() => _error = null);
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailCtrl.text.trim(), _passwordCtrl.text);
      if (mounted) Navigator.pop(context);

      final state = ref.read(authProvider);
      if (state.token != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MemberHomePage()),
          );
        }
      } else {
        setState(() => _error = state.error ?? 'Login failed');
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      setState(() => _error = 'Login error: $e');
    }
  }

  void _loginWithGoogle() async {
    setState(() => _error = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng Google chưa implement!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildLoginHeader() => Column(
    children: [
      const SizedBox(height: 38),
      CircleAvatar(
        radius: 40,
        backgroundColor: orangeLight,
        child: Icon(
          Icons.supervised_user_circle_outlined,
          color: orangeDeep,
          size: 48,
        ),
      ),
      const SizedBox(height: 21),
      Text(
        'Welcome to\nAI Meeting Platform',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 23,
          color: orangeDeep,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 11),
      Text(
        'Sign in to continue',
        style: TextStyle(color: Colors.black54, fontSize: 15),
      ),
      const SizedBox(height: 18),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [orangeLight, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildLoginHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Card(
                    elevation: 7,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _passwordCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: orangeDeep,
                                onChanged: (val) =>
                                    setState(() => _rememberMe = val ?? false),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: orangeDeep,
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _login,
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 13),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              icon: Image.asset(
                                'assets/google.png',
                                width: 24,
                                height: 24,
                              ), // Google logo PNG nhỏ
                              label: const Text(
                                'Đăng nhập với Google',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: orangeDeep, width: 1.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: _loginWithGoogle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
