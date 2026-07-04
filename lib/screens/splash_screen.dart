import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase_options.dart';
import 'notes_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _progressAnimation;

  String _statusText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<double>(begin: 25.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutQuad),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.95, curve: Curves.easeInOut),
      ),
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start animations
    _controller.forward();

    final stopWatch = Stopwatch()..start();

    // Step 1: Initialize Firebase
    try {
      setState(() => _statusText = 'Connecting to services...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() => _statusText = 'Ready');
    } catch (e) {
      debugPrint('Firebase init error: $e');
      setState(() => _statusText = 'Starting application...');
    }

    final elapsed = stopWatch.elapsedMilliseconds;
    const minDuration =
        2800; // slightly longer than animation to show "Ready" state briefly
    if (elapsed < minDuration) {
      await Future.delayed(Duration(milliseconds: minDuration - elapsed));
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const NotesListScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF131324), Color(0xFF0C0C16)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // Glow Effect in background behind the icon
                  Positioned.fill(
                    child: Center(
                      child: Opacity(
                        opacity: _logoOpacity.value * 0.15,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                            boxShadow: [
                              BoxShadow(
                                color: primary,
                                blurRadius: 80,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Container
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF16213E,
                                ).withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primary.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.notes_rounded,
                                size: 72,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        Opacity(
                          opacity: _textOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0, _textSlide.value),
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [primary, const Color(0xFFF2C49B)],
                              ).createShader(bounds),
                              child: Text(
                                'NOTES',
                                style: GoogleFonts.outfit(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Tagline
                        Opacity(
                          opacity: _taglineOpacity.value,
                          child: Text(
                            'Capture. Organize. Recall.',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.5),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progress Loading indicator at bottom
                  Positioned(
                    bottom: 80,
                    left: 48,
                    right: 48,
                    child: Column(
                      children: [
                        // Progress bar track
                        Container(
                          height: 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primary, const Color(0xFFF2C49B)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(alpha: 0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Status Text
                        Text(
                          _statusText,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.35),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
