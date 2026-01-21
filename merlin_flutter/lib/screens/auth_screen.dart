import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../main.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final Widget child;

  const AuthScreen({
    super.key,
    required this.child,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isSignedIn = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    _animationController.dispose();
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return widget.child;
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: child,
                        ),
                      );
                    },
                    child: _buildContent(context, constraints),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final isWideScreen = screenWidth > AppTheme.mobileBreakpoint;
    final contentMaxWidth = AppTheme.responsiveMaxWidth(context);

    return Padding(
      padding: AppTheme.responsivePadding(context),
      child: Column(
        children: [
          SizedBox(height: constraints.maxHeight * 0.12),

          // Logo
          Center(
            child: _MerlinLogo(
              size: isWideScreen ? 120 : 100,
            ),
          ),

          SizedBox(height: constraints.maxHeight * 0.04),

          // Title
          Center(
            child: _buildTitle(context),
          ),

          const SizedBox(height: 8),

          // Tagline
          Center(
            child: Text(
              'Own your time',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: constraints.maxHeight * 0.06),

          // Sign in form
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: _buildSignInCard(context),
            ),
          ),

          // Bottom spacer
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: 'Merlin AI',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Widget _buildSignInCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3D1515),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFF6B6B),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFFF6B6B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFFFB3B3),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _clearError,
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFFFB3B3),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Colors.black,
              cardTheme: const CardThemeData(
                color: Colors.black,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                surface: Colors.black,
                surfaceContainerHighest: Colors.black,
                surfaceContainerHigh: Colors.black,
                surfaceContainerLow: Colors.black,
                surfaceContainerLowest: Colors.black,
              ),
              scaffoldBackgroundColor: Colors.black,
              dialogTheme: DialogThemeData(backgroundColor: Colors.black),
            ),
            child: SignInWidget(
              client: client,
              onAuthenticated: () {
                _clearError();
              },
              onError: (error) {
                String errorMessage;
                final errorString = error.toString().toLowerCase();

                if (errorString.contains('invalid') ||
                    errorString.contains('credentials') ||
                    errorString.contains('password') ||
                    errorString.contains('incorrect')) {
                  errorMessage = 'Invalid email or password. Please try again.';
                } else if (errorString.contains('network') ||
                    errorString.contains('connection') ||
                    errorString.contains('timeout')) {
                  errorMessage = 'Network error. Please check your connection.';
                } else if (errorString.contains('not found') ||
                    errorString.contains('user')) {
                  errorMessage = 'Account not found. Please check your email.';
                } else {
                  errorMessage = 'An error occurred. Please try again.';
                }

                _showError(errorMessage);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MerlinLogo extends StatefulWidget {
  final double size;

  const _MerlinLogo({
    this.size = 100,
  });

  @override
  State<_MerlinLogo> createState() => _MerlinLogoState();
}

class _MerlinLogoState extends State<_MerlinLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _MerlinLogoPainter(
            animation: _controller.value,
          ),
        );
      },
    );
  }
}

class _MerlinLogoPainter extends CustomPainter {
  final double animation;

  _MerlinLogoPainter({
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.28;
    final strokeWidth = size.width * 0.08;

    const colors = [
      Color(0xFF5FD4AA),
      Color(0xFFE8B99D),
      Color(0xFFB8A5C7),
    ];

    for (int i = 0; i < 3; i++) {
      final baseAngle = (i * 2.094) + (animation * 0.5);
      final ringCenter = Offset(
        center.dx + radius * 0.3 * _smoothCos(baseAngle),
        center.dy + radius * 0.3 * _smoothSin(baseAngle),
      );

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      paint.shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0,
        endAngle: 6.283,
        colors: [
          colors[i],
          colors[i].withOpacity(0.7),
          colors[i],
        ],
        transform: GradientRotation(animation * 3.14),
      ).createShader(Rect.fromCircle(center: ringCenter, radius: radius));

      canvas.drawCircle(ringCenter, radius, paint);
    }
  }

  double _smoothSin(double angle) =>
      (3.141592653589793 * angle).remainder(6.283185307179586).abs() <
          3.141592653589793
      ? (angle.remainder(1) < 0.5
                ? angle.remainder(1) * 2
                : 2 - angle.remainder(1) * 2) -
            0.5
      : -((angle.remainder(1) < 0.5
                ? angle.remainder(1) * 2
                : 2 - angle.remainder(1) * 2) -
            0.5);

  double _smoothCos(double angle) => _smoothSin(angle + 1.5707963267948966);

  @override
  bool shouldRepaint(_MerlinLogoPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
