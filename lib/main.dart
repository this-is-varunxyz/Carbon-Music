import 'package:carbon_music/features/auth/presentation/login_screen.dart';
import 'package:carbon_music/features/home/presentation/root_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
        ),
      ),
      home:StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Scaffold(
              backgroundColor: Color(0xFFF5F5F7),
              body: Center(child: CircularProgressIndicator(color: Colors.black54)),
            );
        }
          if (snapshot.hasData) {
            return const RootScreen();
          }
          return const LoginScreen();
      }),
    );
  }
}