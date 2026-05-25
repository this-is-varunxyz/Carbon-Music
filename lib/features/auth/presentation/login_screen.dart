import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
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
            content: Text(failure.message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red.shade900,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      (userEntity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, ${userEntity.name}!', style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.grey.shade900,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LiquidGlassScope.stack(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEEEEEE), Color(0xFFFFFFFF), Color(0xFFF4F4F4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        content: Positioned.fill(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  const GlassContainer(
                    width: 88,
                    height: 88,
                    child: Center(
                      child: Icon(
                        Icons.album_rounded,
                        size: 44,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'CARBON MUSIC',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  const Text(
                    'Limitless music. Zero ads.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 56),
                  
                  GlassContainer(
                    width: double.infinity,
                    
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'SIGN IN TO CONTINUE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black38,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          if (_isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CircularProgressIndicator(
                                  color: Colors.black54,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          else ...[
                            
                            WateryAuthButton(
                              onTap: _handleGoogleSignIn,
                              icon: const _GoogleColorIcon(),
                              label: 'Sign in with Google',
                            ),
                            const SizedBox(height: 12),
                            
                            WateryAuthButton(
                              onTap: () {},
                              icon: const Icon(
                                Icons.mail_outline_rounded,
                                size: 20,
                                color: Colors.black87,
                              ),
                              label: 'Continue with Email',
                            ),
                          ],
                          const SizedBox(height: 20),
                          
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.black12, thickness: 0.5),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'or',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.black12, thickness: 0.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          WateryAuthButton(
                            onTap: () {},
                            icon: const Icon(
                              Icons.person_add_outlined,
                              size: 20,
                              color: Colors.black87,
                            ),
                            label: 'Create an account',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'By continuing you agree to our Terms of Service\nand Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black38,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WateryAuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String label;

  const WateryAuthButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      onTap: onTap,
      width: double.infinity,
      height: 56,
      shape: const LiquidRoundedRectangle(borderRadius: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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