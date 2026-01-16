import 'package:flutter/material.dart';
import 'package:merlin_client/merlin_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class GoogleConnectionWidget extends StatefulWidget {
  final Client client;

  const GoogleConnectionWidget({
    super.key,
    required this.client,
  });

  @override
  State<GoogleConnectionWidget> createState() => _GoogleConnectionWidgetState();
}

class _GoogleConnectionWidgetState extends State<GoogleConnectionWidget> {
  bool _isConnected = false;
  bool _isLoading = false;
  DateTime? _lastSyncTime;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  Future<void> _checkConnectionStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isConnected = await widget.client.googleOAuth
          .getGoogleConnectionStatus();
      setState(() {
        _isConnected = isConnected;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _errorMessage = 'Failed to check connection status';
      });
    }
  }

  Future<void> _connectGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authUrl = await widget.client.googleOAuth.initiateGoogleOAuth();

      final uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        // Launch OAuth URL in external browser
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        _setupOAuthCallbackListener();
      } else {
        throw Exception('Could not launch OAuth URL');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to connect: $e';
      });
    }
  }

  void _setupOAuthCallbackListener() {
    // Poll for connection status every 2 seconds for up to 2 minutes
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      try {
        final isConnected = await widget.client.googleOAuth
            .getGoogleConnectionStatus();

        if (isConnected) {
          timer.cancel();
          setState(() {
            _isConnected = true;
            _isLoading = false;
            _lastSyncTime = DateTime.now();
          });
        } else {
          if (timer.tick >= 60) {
            timer.cancel();
            setState(() {
              _isLoading = false;
              _errorMessage = 'Connection timeout. Please try again.';
            });
          }
        }
      } catch (e) {
        timer.cancel();
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to verify connection: $e';
        });
      }
    });
  }

  Future<void> _disconnectGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.client.googleOAuth.disconnectGoogle();
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _lastSyncTime = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to disconnect: $e';
      });
    }
  }

  Future<void> _syncNow() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement sync functionality when calendar/email sync is ready
      await Future.delayed(const Duration(seconds: 1)); // Placeholder
      setState(() {
        _lastSyncTime = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Sync failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.email, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Google Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isConnected ? Colors.green : Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            if (_isConnected)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status: Connected',
                    style: TextStyle(color: Colors.green),
                  ),
                  if (_lastSyncTime != null)
                    Text(
                      'Last sync: ${_formatTime(_lastSyncTime!)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _syncNow,
                          icon: const Icon(Icons.sync, size: 18),
                          label: const Text('Sync Now'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _disconnectGoogle,
                          icon: const Icon(Icons.link_off, size: 18),
                          label: const Text('Disconnect'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _connectGoogle,
                  icon: const Icon(Icons.link),
                  label: const Text('Connect Google Account'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
