import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoGlow;

  late AnimationController _bgController;
  late Animation<Color?> _bgAnimation;

  late AnimationController _progressController;

  final List<_Sparkle> _sparkles = [];

  int _currentIndex = 0;  // Track the current index of the translations
  late Timer _textSwitchTimer;

  // List of Translations
  final List<Map<String, dynamic>> _translations = [
    {'text': 'Sygnal', 'language': 'English'},
    {'text': 'सिग्नल', 'language': 'Hindi'},
    {'text': 'Сигнал', 'language': 'Russian'},
    {'text': 'Signal', 'language': 'French'},
    {'text': 'シグナル', 'language': 'Japanese'},
    {'text': 'Sygnaal', 'language': 'Dutch'},
    {'text': '信号', 'language': 'Chinese'},
    {'text': 'Señal', 'language': 'Spanish'},
    {'text': 'علامة', 'language': 'Arabic'},
  ];

  @override
  void initState() {
    super.initState();

    // Set up the timer to switch languages faster (every 500 milliseconds)
    _textSwitchTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _translations.length;
        });
      }
    });

    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoGlow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    _logoController.forward();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _bgAnimation = ColorTween(
      begin: const Color(0xFF0D0C1D),
      end: const Color(0xFF1D1E33),
    ).animate(_bgController);

    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          _sparkles.add(_Sparkle());
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _textSwitchTimer.cancel();
    _logoController.dispose();
    _bgController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _bgAnimation.value,
          body: Stack(
            children: [
              // Sparkles
              ..._sparkles.map((sparkle) => sparkle.build(context)),

              // Content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(_logoGlow.value), // Darker purple glow
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shield_moon_outlined,
                          size: 100,
                          color: Colors.purpleAccent, // Slightly darker logo for better contrast
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // AnimatedSwitcher for text transition
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        _translations[_currentIndex]['text'],
                        key: ValueKey<int>(_currentIndex), // Unique key for each language
                        style: GoogleFonts.rajdhani(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.purpleAccent.withOpacity(0.7),
                              blurRadius: 15.0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Glowing progress bar
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (_, __) {
                        return Container(
                          width: 100 + 50 * sin(_progressController.value * 2 * pi),
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.7),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Sparkle {
  final double x = Random().nextDouble();
  final double y = Random().nextDouble();
  final double size = 1 + Random().nextDouble() * 2;
  final double opacity = 0.1 + Random().nextDouble() * 0.5;

  Widget build(BuildContext context) {
    return Positioned(
      top: y * MediaQuery.of(context).size.height,
      left: x * MediaQuery.of(context).size.width,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
