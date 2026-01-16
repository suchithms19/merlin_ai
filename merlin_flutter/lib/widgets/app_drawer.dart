import 'package:flutter/material.dart';
import 'package:merlin_client/merlin_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../main.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback? onClose;

  const AppDrawer({
    super.key,
    this.onClose,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isGoogleConnected = false;
  bool _isLoading = false;
  String? _userEmail;
  String? _userName;
  bool _showAccountsExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _checkGoogleConnection();
  }

  Future<void> _loadUserInfo() async {
    try {
      final isConnected = await client.googleOAuth.getGoogleConnectionStatus();
      if (isConnected) {
        setState(() {
          _isGoogleConnected = true;
        });
      }
    } catch (e) {
    }
  }

  Future<void> _checkGoogleConnection() async {
    setState(() => _isLoading = true);
    try {
      final isConnected = await client.googleOAuth.getGoogleConnectionStatus();
      if (isConnected) {
        try {
          final calendars = await client.calendar.getCalendars();
          if (calendars.isNotEmpty) {
            final primary = calendars.firstWhere(
              (c) => c.isPrimary,
              orElse: () => calendars.first,
            );
            setState(() {
              _isGoogleConnected = true;
              _isLoading = false;
              _userEmail = primary.name;
            });
          } else {
            setState(() {
              _isGoogleConnected = isConnected;
              _isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            _isGoogleConnected = isConnected;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isGoogleConnected = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _connectGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authUrl = await client.googleOAuth.initiateGoogleOAuth();
      final uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        _pollForConnection();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect: $e')),
        );
      }
    }
  }

  void _pollForConnection() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      try {
        final isConnected = await client.googleOAuth.getGoogleConnectionStatus();
        if (isConnected) {
          timer.cancel();
          try {
            final calendars = await client.calendar.getCalendars();
            if (calendars.isNotEmpty) {
              final primary = calendars.firstWhere(
                (c) => c.isPrimary,
                orElse: () => calendars.first,
              );
              setState(() {
                _isGoogleConnected = true;
                _isLoading = false;
                _userEmail = primary.name;
              });
            } else {
              setState(() {
                _isGoogleConnected = true;
                _isLoading = false;
              });
            }
          } catch (e) {
            setState(() {
              _isGoogleConnected = true;
              _isLoading = false;
            });
          }
        } else if (timer.tick >= 60) {
          timer.cancel();
          setState(() => _isLoading = false);
        }
      } catch (e) {
        timer.cancel();
        setState(() => _isLoading = false);
      }
    });
  }

  Future<void> _disconnectGoogle() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Google Account'),
        content: const Text(
          'Are you sure you want to disconnect your Google account? '
          'You will lose access to your calendar and email features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await client.googleOAuth.disconnectGoogle();
        setState(() {
          _isGoogleConnected = false;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to disconnect: $e')),
          );
        }
      }
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await client.auth.signOutDevice();

        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign out: $e')),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeAreaPadding = MediaQuery.of(context).padding;

    return Container(
      width: AppTheme.isMobile(context) ? null : 320,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          if (AppTheme.isMobile(context))
            Container(
              padding: EdgeInsets.only(top: safeAreaPadding.top + 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: AppTheme.isMobile(context) ? 24 : safeAreaPadding.top + 24,
              bottom: 20,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _getInitials(_userName ?? _userEmail ?? 'U'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName ?? 'User',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_userEmail != null)
                        Text(
                          _userEmail!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      else if (!_isGoogleConnected)
                        Text(
                          'Not connected',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSectionHeader(context, 'Connected Accounts'),
                _buildExpandableMenuItem(
                  context,
                  icon: Icons.g_mobiledata_rounded,
                  title: 'Manage Accounts',
                  isExpanded: _showAccountsExpanded,
                  onToggle: () {
                    setState(() {
                      _showAccountsExpanded = !_showAccountsExpanded;
                    });
                  },
                ),
                if (_showAccountsExpanded) ...[
                  if (_isGoogleConnected)
                    _buildGoogleAccountStatus(context),
                  _buildAddAccountButton(context),
                ],
              ],
            ),
          ),

          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.logout_rounded,
                      color: theme.colorScheme.error,
                    ),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    onTap: _signOut,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }


  Widget _buildExpandableMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title),
      trailing: AnimatedRotation(
        turns: isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 200),
        child: const Icon(Icons.keyboard_arrow_down),
      ),
      onTap: onToggle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }


  Widget _buildGoogleAccountStatus(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        Icons.g_mobiledata_rounded,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        _userEmail ?? 'Google Account',
        style: theme.textTheme.bodyMedium,
      ),
      trailing: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              icon: Icon(
                Icons.link_off,
                size: 18,
                color: theme.colorScheme.error.withOpacity(0.7),
              ),
              onPressed: _disconnectGoogle,
              tooltip: 'Disconnect',
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildAddAccountButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isGoogleConnected ? null : _connectGoogle,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  _isGoogleConnected ? 'Account Connected' : 'Add Account',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
