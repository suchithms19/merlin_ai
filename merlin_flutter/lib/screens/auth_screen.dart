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
    final theme = Theme.of(context);
    final contentMaxWidth = AppTheme.responsiveMaxWidth(context);

    return Padding(
      padding: AppTheme.responsivePadding(context),
      child: Column(
        children: [
          const Spacer(),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: Column(
                children: [
                  Text(
                    'Merlin',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                      height: 1.1,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSignInCard(context),
                ],
              ),
            ),
          ),
          const Spacer(),
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
        color: const Color(0xFF12111A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF3D3849),
          width: 1,
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
                  color: const Color(0xFFE86B6B),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFE86B6B),
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
              cardColor: const Color(0xFF12111A),
              cardTheme: const CardThemeData(
                color: Color(0xFF12111A),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                surface: const Color(0xFF12111A),
                surfaceContainerHighest: const Color(0xFF26232F),
                surfaceContainerHigh: const Color(0xFF1C1A26),
                surfaceContainerLow: const Color(0xFF15131D),
                surfaceContainerLowest: const Color(0xFF0C0B0F),
              ),
              scaffoldBackgroundColor: const Color(0xFF0C0B0F),
              dialogTheme: const DialogThemeData(
                backgroundColor: Color(0xFF1C1A26),
              ),
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
