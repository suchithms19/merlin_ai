import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum MessageRole { user, assistant }

/// Chat message bubble with modern dark mode design
/// Supports markdown rendering for AI responses
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                        ? theme.colorScheme.primary.withOpacity(0.15)
                        : isError
                            ? theme.colorScheme.errorContainer.withOpacity(0.3)
                            : theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    border: isUser
                        ? Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  child: isUser
                      ? Text(
                          content,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: content,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: theme.textTheme.bodyLarge?.copyWith(
                              color: isError
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface,
                              height: 1.5,
                            ),
                            h1: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            h3: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            listBullet: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                            code: TextStyle(
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              color: theme.colorScheme.primary,
                              fontSize: 13,
                              fontFamily: 'monospace',
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            blockquotePadding: const EdgeInsets.only(left: 12),
                            blockquoteDecoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: theme.colorScheme.primary.withOpacity(0.5),
                                  width: 3,
                                ),
                              ),
                            ),
                            a: TextStyle(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                ),
                
                // Functions executed badges
                if (functionsExecuted != null && functionsExecuted!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: functionsExecuted!.map((fn) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.secondary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getFunctionIcon(fn),
                              size: 12,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatFunctionName(fn),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
                
                // Timestamp
                if (timestamp != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(timestamp!),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser
            ? theme.colorScheme.primary.withOpacity(0.2)
            : theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
        size: 18,
        color: isUser
            ? theme.colorScheme.primary
            : theme.colorScheme.onTertiaryContainer,
      ),
    );
  }

  IconData _getFunctionIcon(String functionName) {
    final fn = functionName.toLowerCase();
    if (fn.contains('calendar') || fn.contains('event') || fn.contains('schedule')) {
      return Icons.calendar_today_rounded;
    } else if (fn.contains('email') || fn.contains('mail')) {
      return Icons.email_rounded;
    } else if (fn.contains('search')) {
      return Icons.search_rounded;
    } else if (fn.contains('create')) {
      return Icons.add_circle_outline_rounded;
    } else if (fn.contains('delete')) {
      return Icons.delete_outline_rounded;
    } else if (fn.contains('update')) {
      return Icons.edit_rounded;
    }
    return Icons.bolt_rounded;
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
