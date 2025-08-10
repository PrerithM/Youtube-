import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/kids_mode_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/video_player_screen.dart';
import 'theme/app_theme.dart';
import 'models/video.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Filter Kids',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/kids-mode',
      routes: {
        '/kids-mode': (context) => const KidsModeScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/video-player': (context) => VideoPlayerScreen(
          video: Video(
            id: '',
            title: '',
            thumbnailUrl: '',
            channelTitle: '',
          ),
        ),
      },
    );
  }
}

