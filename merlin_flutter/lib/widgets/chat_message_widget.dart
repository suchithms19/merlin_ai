import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum MessageRole { user, assistant }

class ChatMessageWidget extends StatelessWidget {
  final String content;
  final MessageRole role;
  final DateTime? timestamp;
  final List<String>? functionsExecuted;
  final bool isError;

  const ChatMessageWidget({
    super.key,
    required this.content,
    required this.role,
    this.timestamp,
    this.functionsExecuted,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = role == MessageRole.user;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(context, isUser),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? theme.colorScheme.primary
                        : isError
                            ? theme.colorScheme.errorContainer
                            : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: isUser
                      ? Text(
                          content,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 15,
                          ),
                        )
                      : MarkdownBody(
                          data: content,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: isError
                                  ? theme.colorScheme.onErrorContainer
                                  : theme.colorScheme.onSurface,
                              fontSize: 15,
                              height: 1.4,
                            ),
                            h1: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            h3: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            listBullet: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                            code: TextStyle(
                              backgroundColor:
                                  theme.colorScheme.surface,
                              color: theme.colorScheme.primary,
                              fontSize: 13,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          selectable: true,
                        ),
                ),
                if (functionsExecuted != null && functionsExecuted!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: functionsExecuted!.map((fn) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getFunctionIcon(fn),
                              size: 12,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatFunctionName(fn),
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (timestamp != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(timestamp!),
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(context, isUser),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isUser) {
    final theme = Theme.of(context);
    
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isUser
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.tertiaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUser ? Icons.person : Icons.auto_awesome,
        size: 20,
        color: isUser
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onTertiaryContainer,
      ),
    );
  }

  IconData _getFunctionIcon(String functionName) {
    if (functionName.contains('Calendar') || functionName.contains('Event')) {
      return Icons.calendar_today;
    } else if (functionName.contains('Email') || functionName.contains('email')) {
      return Icons.email;
    } else if (functionName.contains('search')) {
      return Icons.search;
    }
    return Icons.bolt;
  }

  String _formatFunctionName(String functionName) {
    // Convert camelCase to readable format
    return functionName
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .trim()
        .toLowerCase();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      final hour = timestamp.hour.toString().padLeft(2, '0');
      final minute = timestamp.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
