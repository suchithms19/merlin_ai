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
                  if (_isGoogleConnected) _buildGoogleAccountStatus(context),
                  _buildAddAccountButton(context),
                ],
                const SizedBox(height: 16),
                _buildSectionHeader(context, 'AI Preferences'),
                _buildAddContextButton(context),
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

  Widget _buildAddContextButton(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        Icons.psychology_outlined,
        color: theme.colorScheme.primary,
      ),
      title: const Text('Add Context'),
      subtitle: Text(
        'Add preferences or info for AI',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurface.withOpacity(0.3),
      ),
      onTap: () => _showContextDialog(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Future<void> _showContextDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const _UserContextDialog(),
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

/// Dialog for managing user contexts
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
        _error = 'Failed to load contexts: $e';
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
          _error = 'Failed to add context: $e';
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
          _error = 'Failed to update context: $e';
        });
      }
    }
  }

  Future<void> _deleteContext(UserContext ctx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Context'),
        content: Text('Are you sure you want to delete "${ctx.title}"?'),
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
          _error = 'Failed to delete context: $e';
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
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI Context & Preferences',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Add information that Merlin should know about you to provide better assistance.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.error.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 14,
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _addContext,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Context'),
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
            Icons.lightbulb_outline,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No context added yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add preferences, work info, or anything\nMerlin should know about you.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
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
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              ctx.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              ctx.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _editContext(ctx),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: () => _deleteContext(ctx),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Dialog for adding or editing a context
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
      title: Text(isEditing ? 'Edit Context' : 'Add Context'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Work Schedule, Preferences',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'e.g., I work Mon-Fri 9am-5pm',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter content';
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
