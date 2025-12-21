import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msp_app/core/local/user_prefs.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRememberMe() async {
    try {
      final credentials = await UserPrefs.getRememberMe();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && email.isNotEmpty) {
        if (mounted) {
          setState(() {
            _emailCtrl.text = email; // ✅ Auto-fill email
            if (password != null && password.isNotEmpty) {
              _passwordCtrl.text = password; // ✅ Auto-fill password
            }
            _rememberMe = true; // ✅ Check the checkbox
          });
          print('✅ Remember me credentials loaded');
        }
      }
    } catch (e) {
      print('❌ Error loading remember me: $e');
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      // ✅ Pass rememberMe flag
      await ref
          .read(authProvider.notifier)
          .login(
            _emailCtrl.text.trim(),
            _passwordCtrl.text,
            rememberMe: _rememberMe,
          );

      final authState = ref.read(authProvider);

      if (!mounted) return;

      if (authState.token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MemberHomePage()),
        );
      } else {
        _showErrorSnackBar(authState.error ?? 'Login failed');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Login error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    // Prevent multiple clicks
    if (_isLoading) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      print('🔍 Initiating Google Sign-In...');

      // Call auth provider's Google sign-in method
      await ref.read(authProvider.notifier).signInWithGoogle();

      final authState = ref.read(authProvider);

      if (!mounted) return;

      if (authState.token != null && authState.isAuthenticated) {
        print('✅ Google login successful, navigating to home...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MemberHomePage()),
        );
      } else if (authState.error != null) {
        _showErrorSnackBar(authState.error!);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Google sign-in failed: ${e.toString()}');
      }
      print('❌ Google login error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Widget _buildLoginHeader() => Column(
    children: [
      const SizedBox(height: 48),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: orangeLight,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: orangeDeep.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(Icons.people_alt_outlined, color: orangeDeep, size: 52),
      ),
      const SizedBox(height: 24),
      Text(
        'Welcome Back!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 28,
          color: orangeDeep,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'AI Meeting Platform',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Sign in to continue',
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      const SizedBox(height: 24),
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildLoginHeader(),
                    Card(
                      elevation: 8,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email Field
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: _validateEmail,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'your@email.com',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: orangeDeep,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: orangeDeep,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Password Field
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              validator: _validatePassword,
                              onFieldSubmitted: (_) => _login(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: orangeDeep,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: orangeDeep,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Remember me
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: orangeDeep,
                                  onChanged: (val) => setState(
                                    () => _rememberMe = val ?? false,
                                  ),
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Login Button
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeDeep,
                                  foregroundColor: Colors.white,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  disabledBackgroundColor: Colors.grey[400],
                                ),
                                onPressed: _isLoading ? null : _login,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.grey[300]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey[300]),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Google Sign In Button
                            SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                icon: Image.asset(
                                  'assets/google.png',
                                  width: 24,
                                  height: 24,
                                ),
                                label: const Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _loginWithGoogle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
