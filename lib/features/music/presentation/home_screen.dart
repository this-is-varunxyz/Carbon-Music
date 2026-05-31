import 'package:flutter/material.dart';
import 'package:carbon_music/features/auth/domain/auth_repository.dart';
import 'package:carbon_music/features/auth/presentation/login_screen.dart';
import 'package:carbon_music/injection_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final authRepo = sl<AuthRepository>();
    await authRepo.signOut();
    
    if (!context.mounted) return;
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), 
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.album_rounded,
                          size: 24,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARBON',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              letterSpacing: 4,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'MUSIC',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              letterSpacing: 6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.black54),
                    onPressed: () => _handleSignOut(context),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(28.0),
              ),
              padding: const EdgeInsets.all(40),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.graphic_eq_rounded,
                    size: 48,
                    color: Colors.black26,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'MUSIC FEED\nCOMING SOON',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45,
                      letterSpacing: 2,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }
}