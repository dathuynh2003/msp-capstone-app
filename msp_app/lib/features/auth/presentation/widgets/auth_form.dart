import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final bool rememberMe;
  final Function(String, String, String?) onSubmit;
  final VoidCallback onSwitchMode;
  final ValueChanged<bool> onRememberMeChanged;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.rememberMe,
    required this.onSubmit,
    required this.onSwitchMode,
    required this.onRememberMeChanged,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.isLogin ? 'Đăng nhập vào tài khoản' : 'Tạo tài khoản mới',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 24),

          CustomTextField(
            controller: _emailController,
            label: "Email",
            hint: "Nhập email của bạn",
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: _passwordController,
            label: "Mật khẩu",
            hint: "Nhập mật khẩu của bạn",
            icon: Icons.lock_outline,
            obscure: _obscurePassword,
            toggleObscure: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),

          if (!widget.isLogin) ...[
            CustomTextField(
              controller: _confirmPasswordController,
              label: "Xác nhận mật khẩu",
              hint: "Xác nhận mật khẩu của bạn",
              icon: Icons.lock_outline,
              obscure: _obscureConfirmPassword,
              toggleObscure: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _companyNameController,
              label: "Tên công ty",
              hint: "Nhập tên công ty của bạn",
              icon: Icons.business_outlined,
            ),
            const SizedBox(height: 16),
          ],

          if (widget.isLogin) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: widget.rememberMe,
                      onChanged: (val) =>
                          widget.onRememberMeChanged(val ?? false),
                      activeColor: const Color(0xFFFF5E13),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    const Text("Ghi nhớ đăng nhập"),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(color: Color(0xFFFF5E13)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onSubmit(
                _emailController.text,
                _passwordController.text,
                widget.isLogin ? null : _companyNameController.text,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E13),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(widget.isLogin ? "Đăng Nhập" : "Đăng Ký"),
            ),
          ),
          const SizedBox(height: 24),

          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Hoặc tiếp tục với"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.g_mobiledata, size: 24),
              label: const Text("Đăng nhập với Google"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Center(
            child: GestureDetector(
              onTap: widget.onSwitchMode,
              child: RichText(
                text: TextSpan(
                  text: widget.isLogin
                      ? "Chưa có tài khoản? "
                      : "Đã có tài khoản? ",
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: widget.isLogin ? "Đăng ký" : "Đăng nhập",
                      style: const TextStyle(
                        color: Color(0xFFFF5E13),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
