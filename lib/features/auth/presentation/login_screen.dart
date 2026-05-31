import 'package:carbon_music/features/music/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:carbon_music/features/auth/domain/auth_repository.dart';
import 'package:carbon_music/injection_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final authRepo = sl<AuthRepository>();
    final result = await authRepo.signInWithGoogle();

    setState(() => _isLoading = false);
    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              failure.message,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
      (userEntity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome back, ${userEntity.name}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(28.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(22.0),
                  child: Icon(
                    Icons.album_rounded,
                    size: 38,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'CARBON',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: 8,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'MUSIC',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  letterSpacing: 10,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Limitless music. Zero ads.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 64),

              Text(
                'SIGN IN TO CONTINUE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withValues(alpha: 0.4),
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 24),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: CircularProgressIndicator(
                    color: Colors.black54,
                    strokeWidth: 2.0,
                  ),
                )
              else ...[
                _AuthButton(
                  onTap: _handleGoogleSignIn,
                  icon: const _GoogleColorIcon(),
                  label: 'Sign in with Google',
                ),
                const SizedBox(height: 12),
                _AuthButton(
                  onTap: () {},
                  icon: Icon(
                    Icons.mail_outline_rounded,
                    size: 19,
                    color: Colors.black.withValues(alpha: 0.8),
                  ),
                  label: 'Continue with Email',
                ),
              ],

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black.withValues(alpha: 0.1),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black.withValues(alpha: 0.1),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _AuthButton(
                onTap: () {},
                icon: Icon(
                  Icons.person_add_outlined,
                  size: 19,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
                label: 'Create an account',
              ),

              const SizedBox(height: 40),

              Text(
                'By continuing you agree to our Terms of Service\nand Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black.withValues(alpha: 0.35),
                  height: 1.7,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String label;

  const _AuthButton({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  State<_AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<_AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.85),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _GoogleColorIcon extends StatelessWidget {
  const _GoogleColorIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Image.network(
        'https://www.google.com/favicon.ico',
        errorBuilder: (_, __, ___) => const Icon(
          Icons.g_mobiledata_rounded,
          size: 22,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}
