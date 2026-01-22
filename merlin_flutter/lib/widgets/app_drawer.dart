import 'package:flutter/material.dart';
import 'package:merlin_client/merlin_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../main.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onGoogleDisconnected;
  final VoidCallback? onGoogleConnected;

  const AppDrawer({
    super.key,
    this.onClose,
    this.onGoogleDisconnected,
    this.onGoogleConnected,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isGoogleConnected = false;
  bool _isLoading = false;
  String? _userEmail;
  String? _userName;

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
    } catch (e) {}
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
        final isConnected = await client.googleOAuth
            .getGoogleConnectionStatus();
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
            widget.onGoogleConnected?.call();
          } catch (e) {
            setState(() {
              _isGoogleConnected = true;
              _isLoading = false;
            });
            widget.onGoogleConnected?.call();
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
          _userEmail = null;
        });
        widget.onGoogleDisconnected?.call();
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

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeAreaPadding = MediaQuery.of(context).padding;

    return Container(
      width: AppTheme.isMobile(context) ? null : 260,
      decoration: BoxDecoration(
        color: const Color(0xFF0E0D14),
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          if (AppTheme.isMobile(context))
            Container(
              padding: EdgeInsets.only(top: safeAreaPadding.top + 8),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

          _buildUserHeader(context, safeAreaPadding),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    title: 'ACCOUNTS',
                    children: [
                      if (_isGoogleConnected)
                        _buildAccountTile(context)
                      else
                        _buildConnectButton(context),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    context,
                    title: 'SETTINGS',
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.tune_rounded,
                        label: 'My Preferences',
                        onTap: () => _showContextDialog(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, EdgeInsets safeAreaPadding) {
    final theme = Theme.of(context);
    final displayName = _userName ?? 'User';
    final displayEmail = _userEmail ?? 'No account linked';

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: AppTheme.isMobile(context) ? 20 : safeAreaPadding.top + 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.8),
                  theme.colorScheme.secondary.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              _getInitials(displayName),
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  displayEmail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.35),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildAccountTile(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    size: 16,
                    color: Color(0xFF4285F4),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Google',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _userEmail ?? 'Connected',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  GestureDetector(
                    onTap: _disconnectGoogle,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _connectGoogle,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(6),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : Icon(
                          Icons.add_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Connect Google',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.08),
              width: 1,
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _signOut,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: theme.colorScheme.error.withOpacity(0.8),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Sign out',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.error.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showContextDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const _UserContextDialog(),
    );
  }
}

class _UserContextDialog extends StatefulWidget {
  const _UserContextDialog();

  @override
  State<_UserContextDialog> createState() => _UserContextDialogState();
}

class _UserContextDialogState extends State<_UserContextDialog> {
  List<UserContext> _contexts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContexts();
  }

  Future<void> _loadContexts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final contexts = await client.userContext.getUserContexts();
      setState(() {
        _contexts = contexts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load: $e';
      });
    }
  }

  Future<void> _addContext() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const _AddEditContextDialog(),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      try {
        await client.userContext.addUserContext(
          result['title']!,
          result['content']!,
        );
        await _loadContexts();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to add: $e';
        });
      }
    }
  }

  Future<void> _editContext(UserContext ctx) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddEditContextDialog(
        initialTitle: ctx.title,
        initialContent: ctx.content,
      ),
    );

    if (result != null && ctx.id != null) {
      setState(() => _isLoading = true);
      try {
        await client.userContext.updateUserContext(
          ctx.id!,
          result['title']!,
          result['content']!,
        );
        await _loadContexts();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to update: $e';
        });
      }
    }
  }

  Future<void> _deleteContext(UserContext ctx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Delete "${ctx.title}"?'),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && ctx.id != null) {
      setState(() => _isLoading = true);
      try {
        await client.userContext.deleteUserContext(ctx.id!);
        await _loadContexts();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to delete: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
          maxHeight: 520,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'My Preferences',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Tell Merlin about yourself',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              Flexible(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _contexts.isEmpty
                    ? _buildEmptyState(context)
                    : _buildContextList(context),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _isLoading ? null : _addContext,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Preference'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tune_rounded,
            size: 40,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'No preferences yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add work hours, focus time, etc.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextList(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _contexts.length,
      itemBuilder: (context, index) {
        final ctx = _contexts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: ListTile(
            dense: true,
            title: Text(
              ctx.title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              ctx.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  onPressed: () => _editContext(ctx),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: theme.colorScheme.error.withOpacity(0.7),
                  ),
                  onPressed: () => _deleteContext(ctx),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddEditContextDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;

  const _AddEditContextDialog({
    this.initialTitle,
    this.initialContent,
  });

  @override
  State<_AddEditContextDialog> createState() => _AddEditContextDialogState();
}

class _AddEditContextDialogState extends State<_AddEditContextDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTitle != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit' : 'Add Preference'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Work Hours',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Details',
                hintText: 'e.g., Mon-Fri 9am-5pm',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
